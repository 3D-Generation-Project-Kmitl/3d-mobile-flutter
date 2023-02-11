package io.carius.lars.ar_flutter_plugin

import android.app.Activity
import android.app.Application
import android.content.Context
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.HandlerThread
import android.util.Log
import android.view.MotionEvent
import android.view.PixelCopy
import android.view.View
import android.widget.Toast
import com.google.ar.core.*
import com.google.ar.core.exceptions.*
import com.google.ar.sceneform.*
import com.google.ar.sceneform.math.Vector3
import com.google.ar.sceneform.ux.*
import io.carius.lars.ar_flutter_plugin.Serialization.deserializeMatrix4
import io.carius.lars.ar_flutter_plugin.Serialization.serializeAnchor
import io.carius.lars.ar_flutter_plugin.Serialization.serializeHitResult
import io.carius.lars.ar_flutter_plugin.Serialization.serializePose
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.nio.FloatBuffer
import java.util.concurrent.CompletableFuture

import android.R
import android.annotation.SuppressLint
import android.hardware.camera2.CameraCaptureSession
import android.hardware.camera2.CameraDevice
import android.hardware.camera2.CameraManager
import com.google.ar.sceneform.rendering.*

import android.view.ViewGroup
import com.google.ar.core.Camera

import com.google.ar.core.TrackingState
import java.util.*


internal class ArCameraData( val activity: Activity, messenger: BinaryMessenger)  {
    // constants
    private val TAG: String = "ArCameraData";
    // Lifecycle variables
    private var mUserRequestedInstall = true
    lateinit var activityLifecycleCallbacks: Application.ActivityLifecycleCallbacks
    // Platform channels
    private val cameraManagerChannel: MethodChannel = MethodChannel(messenger, "arcameradata")

    private var sharedSession: Session?=null;
    private var captureSession: CameraCaptureSession? = null
    private var sharedCamera:SharedCamera?=null:
    private var cameraId:String?=null;
    private var backgroundHandlerThread: HandlerThread? = null
    private var backgroundHandler: Handler? = null
    private var cameraDevice: CameraDevice? = null

    private lateinit var transformationSystem: TransformationSystem
    private var showFeaturePoints = false
    private var showAnimatedGuide = false
    private lateinit var animatedGuide: View
    private var pointCloudNode = Node()
    private var worldOriginNode = Node()
    // Setting defaults
    private var enableRotation = false
    private var enablePans = false
    private var keepNodeSelected = true;
    private var footprintSelectionVisualizer = FootprintSelectionVisualizer()



    private lateinit var sceneUpdateListener: com.google.ar.sceneform.Scene.OnUpdateListener
    private lateinit var onNodeTapListener: com.google.ar.sceneform.Scene.OnPeekTouchListener

    // Method channel handlers
    private val onCameraMethodCall =
            object : MethodChannel.MethodCallHandler {
                override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
                    Log.d(TAG, "ArCameraData onCameramethodcall reveived a call!")
                    when (call.method) {
                        "getCameraPose" -> {
                            val cameraPose = sharedSession!!.update()!!.camera!!.displayOrientedPose
                            if (cameraPose != null) {
                                result.success(serializePose(cameraPose!!))
                            } else {
                                result.error("Error", "could not get camera pose", null)
                            }
                        }
                        else -> {}
                    }
                }
            }

    init {

        Log.d(TAG, "Initializing ArCameraData")
        setupLifeCycle()

        cameraManagerChannel.setMethodCallHandler(onCameraMethodCall)

        onResume() // call onResume once to setup initial session
        // TODO: find out why this does not happen automatically
    }

    private fun setupLifeCycle() {
        activityLifecycleCallbacks =
                object : Application.ActivityLifecycleCallbacks {
                    override fun onActivityCreated(
                            activity: Activity,
                            savedInstanceState: Bundle?
                    ) {
                        Log.d(TAG, "onActivityCreated")
                    }

                    override fun onActivityStarted(activity: Activity) {
                        Log.d(TAG, "onActivityStarted")
                    }

                    override fun onActivityResumed(activity: Activity) {
                        Log.d(TAG, "onActivityResumed")
                        onResume()
                    }

                    override fun onActivityPaused(activity: Activity) {
                        Log.d(TAG, "onActivityPaused")
                        onPause()
                    }

                    override fun onActivityStopped(activity: Activity) {
                        Log.d(TAG, "onActivityStopped")
                        // onStopped()
                        onPause()
                    }

                    override fun onActivitySaveInstanceState(
                            activity: Activity,
                            outState: Bundle
                    ) {}

                    override fun onActivityDestroyed(activity: Activity) {
                        Log.d(TAG, "onActivityDestroyed")
//                        onPause()
//                        onDestroy()
                    }
                }

        activity.application.registerActivityLifecycleCallbacks(this.activityLifecycleCallbacks)
    }

    @SuppressLint("MissingPermission")
    fun onResume() {
        // Create sharedSession if there is none
        if (sharedSession == null) {
            Log.d(TAG, "sharedSession sharedSession is null. Trying to initialize")
            try {
//                var sharedSession: Session?
                if (ArCoreApk.getInstance().requestInstall(activity, mUserRequestedInstall) ==
                        ArCoreApk.InstallStatus.INSTALL_REQUESTED) {
                    Log.d(TAG, "Install of ArCore APK requested")
                    sharedSession = null
                } else {
                    sharedSession = Session(activity, EnumSet.of(Session.Feature.SHARED_CAMERA))
                    sharedCamera = sharedSession!!.sharedCamera
                    cameraId = sharedSession!!.cameraConfig.cameraId
                    // Wrap the callback in a shared camera callback.
                    val wrappedCallback = sharedCamera!!.createARDeviceStateCallback(cameraDeviceStateCallback, backgroundHandler)

                    // Store a reference to the camera system service.
                    val cameraManager = activity.getSystemService(Context.CAMERA_SERVICE) as CameraManager

                    // Open the camera device using the ARCore wrapped callback.
                    cameraManager.openCamera(cameraId!!, wrappedCallback, backgroundHandler)

                }

                if (sharedSession == null) {
                    // Ensures next invocation of requestInstall() will either return
                    // INSTALLED or throw an exception.
                    mUserRequestedInstall = false
                    return
                } else {
                    val config = Config(sharedSession)
                    config.updateMode = Config.UpdateMode.LATEST_CAMERA_IMAGE
                    config.focusMode = Config.FocusMode.AUTO
                    sharedSession!!.configure(config)

                }
            } catch (ex: UnavailableUserDeclinedInstallationException) {
                // Display an appropriate message to the user zand return gracefully.
                Toast.makeText(
                        activity,
                        "TODO: handle exception " + ex.localizedMessage,
                        Toast.LENGTH_LONG)
                        .show()
                return
            } catch (ex: UnavailableArcoreNotInstalledException) {
                Toast.makeText(activity, "Please install ARCore", Toast.LENGTH_LONG).show()
                return
            } catch (ex: UnavailableApkTooOldException) {
                Toast.makeText(activity, "Please update ARCore", Toast.LENGTH_LONG).show()
                return
            } catch (ex: UnavailableSdkTooOldException) {
                Toast.makeText(activity, "Please update this app", Toast.LENGTH_LONG).show()
                return
            } catch (ex: UnavailableDeviceNotCompatibleException) {
                Toast.makeText(activity, "This device does not support AR", Toast.LENGTH_LONG)
                        .show()
                return
            } catch (e: Exception) {
                Toast.makeText(activity, "Failed to create AR session", Toast.LENGTH_LONG).show()
                return
            }
        }

        try {
            sharedSession!!.resume()
        } catch (ex: CameraNotAvailableException) {
            Log.d(TAG, "Unable to get camera" + ex)
            activity.finish()
            return
        } catch (e : Exception){
            return
        }
    }
    private val cameraDeviceStateCallback = object : CameraDevice.StateCallback() {
        override fun onOpened(camera: CameraDevice) {
            Log.d("ARCore:", "Camera device ID" + camera.id + " opened.")
            cameraDevice = camera
        }

        override fun onClosed(camera: CameraDevice) {
            cameraDevice!!.close()
        }

        override fun onDisconnected(p0: CameraDevice) {
            cameraDevice!!.close()
        }

        override fun onError(p0: CameraDevice, p1: Int) {
            cameraDevice!!.close()
        }
    }
    val cameraSessionStateCallback = object : CameraCaptureSession.StateCallback() {
        // Called when ARCore first configures the camera capture session after
        // initializing the app, and again each time the activity resumes.
        override fun onConfigured(session: CameraCaptureSession) {
            captureSession = session
            setRepeatingCaptureRequest()
        }

        override fun onActive(session: CameraCaptureSession) {
            if (arMode && !arcoreActive) {
                resumeARCore()
            }
        }
    }

    val cameraCaptureCallback = object : CameraCaptureSession.CaptureCallback() {
        override fun onCaptureCompleted(
            session: CameraCaptureSession,
            request: CaptureRequest,
            result: TotalCaptureResult
        ) {
            shouldUpdateSurfaceTexture.set(true);
        }
    }

    fun setRepeatingCaptureRequest() {
        captureSession.setRepeatingRequest(
            previewCaptureRequestBuilder.build(), cameraCaptureCallback, backgroundHandler
        )
    }

    fun resumeARCore() {
        // Resume ARCore.
        sharedSession.resume()
        arcoreActive = true

        // Set the capture session callback while in AR mode.
        sharedCamera.setCaptureCallback(cameraCaptureCallback, backgroundHandler)
    }

    fun onPause() {
        // hide instructions view if no longer required
        if (showAnimatedGuide){
            val view = activity.findViewById(R.id.content) as ViewGroup
            view.removeView(animatedGuide)
            showAnimatedGuide = false
        }
        sharedSession!!.pause()
    }

    fun onDestroy() {
        try {
            sharedSession?.close()

        }catch (e : Exception){
            e.printStackTrace();
        }
    }







}


