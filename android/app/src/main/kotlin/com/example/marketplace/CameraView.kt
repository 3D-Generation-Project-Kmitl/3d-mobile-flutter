package com.example.marketplace

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.graphics.*
import android.graphics.ImageFormat
import android.hardware.camera2.*
import android.media.Image
import android.media.ImageReader
import android.opengl.GLES20
import android.opengl.GLSurfaceView
import android.os.Handler
import android.os.HandlerThread
import android.util.Log
import android.util.Size
import android.util.SparseIntArray
import android.view.*
import android.widget.FrameLayout
import android.widget.LinearLayout
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.google.ar.core.*
import com.google.ar.core.exceptions.CameraNotAvailableException
import io.carius.lars.ar_flutter_plugin.Serialization.serializePose
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.io.File
import java.io.IOException
import java.nio.ByteOrder
import java.util.*
import java.util.concurrent.atomic.AtomicBoolean
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10

class CameraView(private val activity: Activity, dartExecutor: DartExecutor) :
        DefaultLifecycleObserver,
        PlatformView,
        ImageReader.OnImageAvailableListener,
        MethodChannel.MethodCallHandler,
        EventChannel.StreamHandler,
        SurfaceTexture.OnFrameAvailableListener,
        GLSurfaceView.Renderer {
    private var isTakePose: Boolean = false
    private lateinit var flutterPoseResult: MethodChannel.Result
    private val channel = MethodChannel(dartExecutor, "ar.core.platform/depth")
    private val eventChanel = EventChannel(dartExecutor, "ar.core.platform/tracking")
    private val frameLayout: FrameLayout
    private val surfaceView: GLSurfaceView
    private val backgroundRenderer = BackgroundRenderer()
    private val depthRenderer = DepthRenderer()
    private val displayRotationHelper = DisplayRotationHelper(activity)
    //    private val pointCloudRenderer = PointCloudRenderer()
    //    private val planeRenderer = PlaneRenderer()
    private var session: Session? = null
    private lateinit var sharedCamera: SharedCamera
    private lateinit var cameraId: String
    private var backgroundHandlerThread: HandlerThread? = null
    private var backgroundHandler: Handler? = null
    private var cameraDevice: CameraDevice? = null
    private lateinit var previewCaptureRequestBuilder: CaptureRequest.Builder
    private var captureSession: CameraCaptureSession? = null
    private var cpuImageReader: ImageReader? = null
    private var pictureImageReader: ImageReader? = null
    private lateinit var previewSize: Size
    private lateinit var textureView: TextureView
    private var errorCreatingSession = false
    private var shouldUpdateSurfaceTexture = AtomicBoolean(false)
    private var arcoreActive = false
    //    private var isSupported = false
    //    private var installRequested = false
    //    private var depthReceived = false
    private var isGetDepth = false
    //    private var capturePicture = false
    private var mWidth = 0
    private var mHeight = 0
    private lateinit var captureFile: File
    private lateinit var flutterResult: MethodChannel.Result
    private var isTakePic = false

    private var event: EventChannel.EventSink? = null

    private val frameInUseLock = Object()
    private var depthTimestamp: Long = -1
    private var containsNewDepthData = false

    //    private val renderer = Renderer()
    private var surfaceCreated = false
    //    private var captureSessionChangesPossible = true
    private lateinit var imageTextLinearLayout: LinearLayout
    private var hasSetTextureNames = false
    //    private lateinit var depthData: ArrayList<ArrayList<String>>

    //    private var depth: ((ArrayList<ArrayList<String>>) -> Unit)? = null
    //    private var depth: ((ShortArray) -> Unit)? = null
    private lateinit var array: ShortArray
    private var imageWidth: Int = 720
    private var imageHeight: Int = 1280
    private var mSensorOrientation = 0
    private val ORIENTATIONS: SparseIntArray = SparseIntArray()



    init {
        Log.d("ARCore:", "Init starting -> $this")
        ORIENTATIONS.append(Surface.ROTATION_0, 90)
        ORIENTATIONS.append(Surface.ROTATION_90, 0)
        ORIENTATIONS.append(Surface.ROTATION_180, 270)
        ORIENTATIONS.append(Surface.ROTATION_270, 180)

        frameLayout = FrameLayout(this.activity)
        surfaceView = GLSurfaceView(this.activity)

        surfaceView.preserveEGLContextOnPause = true
        surfaceView.setEGLContextClientVersion(2)
        surfaceView.setEGLConfigChooser(8, 8, 8, 8, 16, 0)
        surfaceView.setRenderer(this)
        surfaceView.renderMode = GLSurfaceView.RENDERMODE_CONTINUOUSLY
        surfaceView.setWillNotDraw(false)

        surfaceView.layoutParams =
                LinearLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.MATCH_PARENT
                )

        frameLayout.layoutParams =
                LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.MATCH_PARENT,
                        LinearLayout.LayoutParams.MATCH_PARENT
                )

        frameLayout.setBackgroundColor(Color.parseColor("#000000"))
        frameLayout.addView(surfaceView)

        Log.d(
                "ARCore",
                "frame: ${frameLayout.width}, ${frameLayout.height} / surface: ${surfaceView.width}, ${surfaceView.height}"
        )

        imageTextLinearLayout = LinearLayout(activity)

        channel.setMethodCallHandler(this)
        eventChanel.setStreamHandler(this)
        resumeARCore()
        //        resumeDepth()

        Log.d("ARCore:", "Init ended")
    }

    //    private val surfaceTextureListener = object : TextureView.SurfaceTextureListener {
    //        override fun onSurfaceTextureAvailable(p0: SurfaceTexture, p1: Int, p2: Int) {
    //            createSession()
    //            openCamera()
    //        }
    //
    //        override fun onSurfaceTextureSizeChanged(p0: SurfaceTexture, p1: Int, p2: Int) {
    //
    //        }
    //
    //        override fun onSurfaceTextureDestroyed(p0: SurfaceTexture): Boolean {
    //            return true
    //        }
    //
    //        override fun onSurfaceTextureUpdated(p0: SurfaceTexture) {
    //
    //        }
    //
    //    }

    //    @Synchronized
    //    private fun waitUntilCameraCaptureSessionIsActive() {
    //        while (!captureSessionChangesPossible) {
    //            try {
    //                delay(1000)
    //            } catch (e: InterruptedException) {
    //                Log.e("ARCore", "Unable to wait for a safe time to make changes to the capture
    // session", e)
    //            }
    //        }
    //    }

    override fun onResume(owner: LifecycleOwner) {
        super.onResume(owner)
        Log.d("ARCore", "onResume")
        surfaceView.onResume()
        displayRotationHelper.onResume()
        hasSetTextureNames = false
    }

    override fun onPause(owner: LifecycleOwner) {
        shouldUpdateSurfaceTexture.set(false)
        surfaceView.onPause()
        displayRotationHelper.onPause()
        if (session != null) session!!.pause()
        closeCamera()
        stopBackgroundThread()
        super.onPause(owner)
    }

    private fun closeCamera() {
        if (captureSession != null) captureSession!!.close()
        if (cameraDevice != null) cameraDevice!!.close()
        if (cpuImageReader != null) cpuImageReader!!.close()
    }

    //    override fun onDestroy(owner: LifecycleOwner) {
    //        if (session != null) {
    //            session!!.close()
    //            session = null
    //        }
    //        super.onDestroy(owner)
    //    }
    //    override fun onResume(owner: LifecycleOwner) {
    //        super.onResume(owner)
    //        Log.d("ARCore:", "onResume starting")
    //        startBackgroundThread()
    //        surfaceView.onResume()
    //
    //        if (surfaceCreated) {
    //            openCamera()
    //        }
    //        Log.d("ARCore:", "onResume ended")
    //    }

    private val cameraDeviceStateCallback =
            object : CameraDevice.StateCallback() {
                override fun onOpened(camera: CameraDevice) {
                    Log.d("ARCore:", "Camera device ID" + camera.id + " opened.")
                    cameraDevice = camera
                    createCameraPreviewSession()
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

    private fun createCameraPreviewSession() {
        try {
            session!!.setCameraTextureName(backgroundRenderer.textureId)
            sharedCamera.surfaceTexture.setOnFrameAvailableListener(this)
            previewCaptureRequestBuilder =
                    cameraDevice!!.createCaptureRequest(CameraDevice.TEMPLATE_RECORD)

            val surfaceList: MutableList<Surface> = sharedCamera.arCoreSurfaces
            //            val surfaceTexture: SurfaceTexture? = textureView.surfaceTexture
            //            surfaceTexture?.setDefaultBufferSize(previewSize.width,
            // previewSize.height)
            //            val previewSurface: Surface = Surface(surfaceTexture)

            surfaceList.add(cpuImageReader!!.surface)
            //            surfaceList.add(previewSurface)

            for (surface in surfaceList) {
                Log.d("ARCore: ", "Surface!!")
                previewCaptureRequestBuilder.addTarget(surface)
            }

            val wrappedCallback =
                    sharedCamera.createARSessionStateCallback(
                            cameraSessionStateCallback,
                            backgroundHandler
                    )

            cameraDevice!!.createCaptureSession(surfaceList, wrappedCallback, backgroundHandler)
        } catch (e: CameraAccessException) {
            Log.d("ARCore:", "CameraAccessException$e")
        }
    }
    private fun rotateBitmap(bitmap: Bitmap): Bitmap? {
        val matrix = Matrix()
        matrix.postRotate(90F)
        return Bitmap.createBitmap(
            bitmap,
            0,
            0,
            bitmap.getWidth(),
            bitmap.getHeight(),
            matrix,
            true
        )
    }

    private val cameraSessionStateCallback =
            object : CameraCaptureSession.StateCallback() {
                override fun onConfigured(session: CameraCaptureSession) {
                    captureSession = session
                    setRepeatingCaptureRequest()
                }

                override fun onConfigureFailed(session: CameraCaptureSession) {
                    Log.e("ARCore", "Failed to configure camera capture session.")
                }

                override fun onActive(session: CameraCaptureSession) {
                    Log.d("ARCore", "Camera capture session active.")
                    if (!arcoreActive) {
                        resumeARCore()
                    }
                }
            }

    private fun resumeARCore() {
        if (session == null) {
            return
        }
        if (!arcoreActive) {
            try {
                // To avoid flicker when resuming ARCore mode inform the renderer to not suppress
                // rendering
                // of the frames with zero timestamp.
                //                backgroundRenderer.suppressTimestampZeroRendering(false);
                // Resume ARCore.
                session!!.resume()
                arcoreActive = true

                // Set capture session callback while in AR mode.
                sharedCamera.setCaptureCallback(cameraCaptureCallback, backgroundHandler)
            } catch (e: CameraNotAvailableException) {
                Log.e("ARCore", "Failed to resume ARCore session: $e")
                return
            }
        }
    }

    private val cameraCaptureCallback =
            object : CameraCaptureSession.CaptureCallback() {
                override fun onCaptureCompleted(
                        session: CameraCaptureSession,
                        request: CaptureRequest,
                        result: TotalCaptureResult
                ) {
                    shouldUpdateSurfaceTexture.set(true)
                }

                override fun onCaptureBufferLost(
                        session: CameraCaptureSession,
                        request: CaptureRequest,
                        target: Surface,
                        frameNumber: Long
                ) {
                    Log.e("ARCore", "onCaptureBufferLost: $frameNumber")
                }

                override fun onCaptureFailed(
                        session: CameraCaptureSession,
                        request: CaptureRequest,
                        failure: CaptureFailure
                ) {
                    Log.e(
                            "ARCore",
                            "onCaptureFailed: " + failure.frameNumber + " " + failure.reason
                    )
                }

                override fun onCaptureSequenceAborted(
                        session: CameraCaptureSession,
                        sequenceId: Int
                ) {
                    Log.e("ARCore", "onCaptureSequenceAborted: $sequenceId $session")
                }
            }

    fun setRepeatingCaptureRequest() {
        captureSession!!.setRepeatingRequest(
                previewCaptureRequestBuilder.build(),
                cameraCaptureCallback,
                backgroundHandler
        )
    }

    private fun resumeDepth() {
        if (session == null) {
            if (!CameraPermissionHelper.hasCameraPermission(activity)) {
                CameraPermissionHelper.requestCameraPermission(activity)
                return
            }
            session = Session(activity)

            if (!session!!.isDepthModeSupported(Config.DepthMode.AUTOMATIC)) {
                Log.d("ARCore", "This device does not support the ARCore Raw Depth API.")
                session = null
                return
            }
        }
        try {
            synchronized(frameInUseLock) {
                val config = session!!.config
                config.depthMode = Config.DepthMode.AUTOMATIC
                config.focusMode = Config.FocusMode.FIXED
                session!!.configure(config)
                Log.d("ARCore", "Set camera config")
                session!!.resume()
            }
        } catch (e: CameraNotAvailableException) {
            Log.e("ARCore", "Camera not available. Try restarting the app.", e)
            session = null
            return
        }

        surfaceView.onResume()
    }

    private fun createSession() {
        if (!CameraPermissionHelper.hasCameraPermission(activity)) {
            CameraPermissionHelper.requestCameraPermission(activity)
            return
        }
        startBackgroundThread()

        session = Session(activity, EnumSet.of(Session.Feature.SHARED_CAMERA))

        val config = session!!.config
        val isDepthSupported = session!!.isDepthModeSupported(Config.DepthMode.AUTOMATIC)
        if (isDepthSupported) {
            config.depthMode = Config.DepthMode.AUTOMATIC
            Log.d("ARCore:", "isDepthSupported = $isDepthSupported")
        } else {
            config.depthMode = Config.DepthMode.DISABLED
        }
        config.focusMode = Config.FocusMode.AUTO

        session!!.configure(config)

        val filter = CameraConfigFilter(session)
        //        filter.targetFps = EnumSet.of(CameraConfig.TargetFps.TARGET_FPS_30)
        filter.depthSensorUsage = EnumSet.of(CameraConfig.DepthSensorUsage.DO_NOT_USE)
        val cameraConfigList = session!!.getSupportedCameraConfigs(filter)

        session!!.cameraConfig = cameraConfigList[0]

        sharedCamera = session!!.sharedCamera
        cameraId = session!!.cameraConfig.cameraId
    }

    private fun startBackgroundThread() {
        backgroundHandlerThread = HandlerThread("CameraThread")
        backgroundHandlerThread!!.start()
        backgroundHandler = Handler(backgroundHandlerThread!!.looper)
    }

    private fun stopBackgroundThread() {
        if (backgroundHandlerThread != null) {
            backgroundHandlerThread!!.quitSafely()
            try {
                backgroundHandlerThread!!.join()
                backgroundHandlerThread = null
                backgroundHandler = null
            } catch (e: InterruptedException) {
                Log.e("ARCore", "Interrupted while trying to join background handler thread", e)
            }
        }
    }

    @SuppressLint("MissingPermission")
    fun openCamera() {
        if (cameraDevice != null) {
            return
        }
        if (session == null) {
            try {
                createSession()
            } catch (e: Exception) {
                errorCreatingSession = true
                Log.e("ARCore", "Failed to create ARCore session that supports camera sharing", e)
                return
            }
        }
        errorCreatingSession = false

        previewSize = session!!.cameraConfig.imageSize
        Log.d("ARCore", "preview: ${previewSize.width}, ${previewSize.height}")
        cpuImageReader = ImageReader.newInstance(imageWidth, imageHeight, ImageFormat.JPEG, 2)
        cpuImageReader!!.setOnImageAvailableListener(this, backgroundHandler)

        //        pictureImageReader =
        //                ImageReader.newInstance(
        //                        previewSize.width,
        //                        previewSize.height,
        //                        ImageFormat.JPEG,
        //                        1);

        sharedCamera.setAppSurfaces(cameraId, listOf(cpuImageReader!!.surface))

        val wrappedCallback =
                sharedCamera.createARDeviceStateCallback(
                        cameraDeviceStateCallback,
                        backgroundHandler
                )
        val cameraManager = activity.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        //        val cameraCharacteristics = cameraManager.getCameraCharacteristics(cameraId)
        //
        //        if (cameraCharacteristics.get(CameraCharacteristics.LENS_FACING) ==
        // CameraCharacteristics.LENS_FACING_FRONT) {
        //        }

        cameraManager.openCamera(cameraId, wrappedCallback, backgroundHandler)
    }

    //    private fun getDepth(): Array<IntArray> {
    ////        session!!.resume()
    ////        surfaceView.onResume()
    ////        displayRotationHelper.onResume()
    //        val frame = session!!.update()
    //        val depthArray = Array(10) { IntArray(10) }
    //        synchronized(frameInUseLock) {
    //            try {
    //                frame.acquireDepthImage().use { depthImage ->
    //                    for (i in depthArray.indices) {
    //                        for (j in depthArray.indices) {
    //                            val (x, y) = getDepthCoordinate(frame, depthImage, i + 100, j +
    // 100)
    //                            Log.d("ARCore", "DepthCoordinate $x, $y from $i, $y")
    //                            if (x >= 0 && y >= 0) {
    //                                depthArray[i][j] = getMillimetersDepth(depthImage, x, y)
    //                                Log.d("ARCore", "Depth $i, $j = ${depthArray[i][j]}")
    //                            }
    //                        }
    //                    }
    //                    return depthArray
    //                }
    //            } catch (e: NotYetAvailableException) {
    //                Log.d("ARCore:", "Depth image is not available")
    //                throw e
    //            }
    //        }
    //    }

    private fun getDepthCoordinate(
            frame: Frame,
            depthImage: Image,
            cpuCoordinateX: Int,
            cpuCoordinateY: Int
    ): Pair<Int, Int> {
        val cpuCoordinates = floatArrayOf(cpuCoordinateX.toFloat(), cpuCoordinateY.toFloat())
        val textureCoordinates = FloatArray(2)
        frame.transformCoordinates2d(
                Coordinates2d.IMAGE_PIXELS,
                cpuCoordinates,
                Coordinates2d.TEXTURE_NORMALIZED,
                textureCoordinates
        )
        if (textureCoordinates[0] < 0 || textureCoordinates[1] < 0) {
            // There are no valid depth coordinates, because the coordinates in the CPU image are in
            // the
            // cropped area of the depth image.
            return -1 to -1
        }
        return (textureCoordinates[0] * depthImage.width).toInt() to
                (textureCoordinates[1] * depthImage.height).toInt()
    }

    private fun getMillimetersDepth(depthImage: Image, x: Int, y: Int): String {
        // The depth image has a single plane, which stores depth for each
        // pixel as 16-bit unsigned integers.
        val plane = depthImage.planes[0]
        Log.d("ARCore", "plane: ${depthImage.width}, ${depthImage.height}")
        val byteIndex = x * plane.pixelStride + y * plane.rowStride
        Log.d("ARCore", "pixelStride: ${plane.pixelStride}")
        Log.d("ARCore", "rowStride: ${plane.rowStride}")
        val buffer = plane.buffer.order(ByteOrder.nativeOrder())
        val array = ShortArray(buffer.remaining() / 2)
        //        buffer.asShortBuffer().get(array)
        //        Log.d("ARCore", "byteIndex: $byteIndex")
        //        Log.d("ARCore", "Array[${byteIndex / 2}]: ${array[byteIndex / 2]}")
        this.array = array
        val depthSample = buffer.getShort(byteIndex)
        return depthSample.toString()
    }

    override fun getView(): View {
        return frameLayout
    }

    override fun dispose() {
        closeCamera()
        stopBackgroundThread()
        if (session != null) {
            session!!.close()
        }
    }

    private val imageSaverCallback =
            object : ImageSaver.Callback {
                override fun onComplete(absolutePath: String?) {
                    flutterResult.success(absolutePath)
                }

                override fun onError(errorCode: String?, errorMessage: String?) {
                    flutterResult.error(errorCode!!, errorMessage, null)
                }
            }

    override fun onImageAvailable(imageReader: ImageReader) {
        //        Log.d("ARCore", "onImageAvailable")
        if (isTakePic) {
            isTakePic = false
            Log.d(
                    "imageReader size:",
                    "image height = ${imageReader!!.height}, image width = ${imageReader!!.width}"
            )
            Log.d(
                    "cpuImageReader size:",
                    "image height = ${cpuImageReader!!.height}, image width = ${cpuImageReader!!.width}"
            )

            backgroundHandler!!.post(
                    ImageSaver(imageReader!!.acquireNextImage(), captureFile, imageSaverCallback)
            )
        }
        val image: Image? = imageReader.acquireLatestImage()
        if (image == null) {
            Log.d("ARCore:", "onImageAvailable: Skipping null image.")
            return
        }
        image.close()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when {
            call.method.equals("getDepth") -> {
                try {
                    isGetDepth = true
                    flutterResult = result
                    //                    waitUntilGetDepthData()
                    //                        val depth = getDepth()
                    //                    depth = { res -> result.success(res) }
                    Log.d("ARCore", "Depth return")
                    //                    result.success(depthData)
                } catch (e: Exception) {
                    result.success(false)
                }
            }
            call.method.equals("takePicture") -> {
                takePicture(result)
            }
            call.method.equals("getCameraParameter") -> {
                getCameraParameter(result)
            }
            call.method.equals(("closeSession")) -> {
                session!!.close()
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun takePicture(result: MethodChannel.Result) {
        flutterResult = result
        val outputDir = activity.cacheDir
        try {
            captureFile = File.createTempFile("CAP", ".jpg", outputDir)
        } catch (e: IOException) {
            return
        }

        if (captureSession == null) {
            return
        }

        previewCaptureRequestBuilder =
                cameraDevice!!.createCaptureRequest(CameraDevice.TEMPLATE_STILL_CAPTURE)
        previewCaptureRequestBuilder.addTarget(cpuImageReader!!.surface)
        val rotation = activity.windowManager.defaultDisplay.rotation
        val manager = activity.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        val characteristics = manager.getCameraCharacteristics(cameraId)
        mSensorOrientation = characteristics.get(CameraCharacteristics.SENSOR_ORIENTATION)!!;
                
        previewCaptureRequestBuilder.set(
            CaptureRequest.JPEG_ORIENTATION,
            getJpegOrientation(characteristics,rotation));
        captureSession!!.capture(
                previewCaptureRequestBuilder.build(),
                cameraCaptureCallback,
                backgroundHandler
        )

        isTakePic = true
    }
    private fun getOrientation(rotation: Int): Int {
        // Sensor orientation is 90 for most devices, or 270 for some devices (eg. Nexus 5X)
        // We have to take that into account and rotate JPEG properly.
        // For devices with orientation of 90, we simply return our mapping from ORIENTATIONS.
        // For devices with orientation of 270, we need to rotate the JPEG 180 degrees.
        return 360
        return (ORIENTATIONS.get(rotation) + mSensorOrientation + 270) % 360
    }
    private fun getJpegOrientation(
        c: CameraCharacteristics,
        deviceOrientation: Int
    ): Int {
        var deviceOrientation = deviceOrientation
        if (deviceOrientation == OrientationEventListener.ORIENTATION_UNKNOWN) return 0
        val sensorOrientation = c[CameraCharacteristics.SENSOR_ORIENTATION]!!

        // Round device orientation to a multiple of 90
        deviceOrientation = (deviceOrientation + 45) / 90 * 90

        // Reverse device orientation for front-facing cameras
        val facingFront =
            c[CameraCharacteristics.LENS_FACING] === CameraCharacteristics.LENS_FACING_FRONT
        if (facingFront) deviceOrientation = -deviceOrientation

        // Calculate desired JPEG orientation relative to camera orientation to make
        // the image upright relative to the device orientation
        return (sensorOrientation + deviceOrientation + 360) % 360
    }
    
    private fun getCameraParameter(result: MethodChannel.Result) {
        flutterPoseResult = result
        isTakePose = true
    }

    @Synchronized
    private fun waitUntilGetDepthData() {
        while (isGetDepth) {
            try {
                frameInUseLock.wait()
            } catch (e: InterruptedException) {
                Log.e(
                        "ARCore",
                        "Unable to wait for a safe time to make changes to the capture session",
                        e
                )
            }
        }
    }

    override fun onFrameAvailable(p0: SurfaceTexture?) {}

    override fun onSurfaceCreated(p0: GL10?, p1: EGLConfig?) {
        surfaceCreated = true
        GLES20.glClearColor(0.1f, 0.1f, 0.1f, 1.0f)
        try {
            backgroundRenderer.createOnGlThread(activity)
            depthRenderer.createOnGlThread(activity)
            //            planeRenderer.createOnGlThread(activity, "models/trigrid.png");
            //            pointCloudRenderer.createOnGlThread(activity);
            // Create the camera preview image texture. Used in non-AR and AR mode.
            //            renderer.createOnGlThread(this.activity)
            openCamera()
        } catch (e: IOException) {
            Log.e("ARCore", "Failed to read an asset file", e)
        }
    }

    override fun onSurfaceChanged(p0: GL10?, width: Int, height: Int) {
        GLES20.glViewport(0, 0, width, height)
        displayRotationHelper.onSurfaceChanged(width, height)
        mWidth = width
        mHeight = height
        //
        //        runOnUiThread(
        //                Runnable {
        //                    // Adjust layout based on display orientation.
        //                    imageTextLinearLayout.setOrientation(
        //                            if (width > height) LinearLayout.HORIZONTAL else
        // LinearLayout.VERTICAL)
        //                })
    }

    override fun onDrawFrame(p0: GL10?) {
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT or GLES20.GL_DEPTH_BUFFER_BIT)

        if (session == null) {
            return
        }

        //        if (!hasSetTextureNames) {
        //            session!!.setCameraTextureNames(intArrayOf(backgroundRenderer.textureId))
        //            hasSetTextureNames = true
        //        }
        if (!shouldUpdateSurfaceTexture.get()) {
            // Not ready to draw.
            return
        }

        displayRotationHelper.updateSessionIfNeeded(session)

        synchronized(frameInUseLock) {
            try {
                onDrawFrameARCore()
            } catch (t: Throwable) {
                // Avoid crashing the application due to unhandled exceptions.
                Log.e("ARCore", "Exception on the OpenGL thread", t)
            }
        }
    }

    //
    private fun onDrawFrameARCore() {
        //        if (!arcoreActive) {
        //            // ARCore not yet active, so nothing to draw yet.
        //            return
        //        }
        //
        //        if (errorCreatingSession) {
        //            // Session not created, so nothing to draw.
        //            return
        //        }

        // Perform ARCore per-frame update.
        val frame = session!!.update()
        val camera = frame.camera
        if (isTakePose) {

            // To transform 2D depth pixels into 3D points we retrieve the intrinsic camera
            // parameters
            // corresponding to the depth image. See more information about the depth values at
            // https://developers.google.com/ar/develop/java/depth/overview#understand-depth-values.
            val intrinsics = camera.textureIntrinsics
            var cameraParameter = hashMapOf<Any, Any>()
            cameraParameter["imageWidth"]=imageWidth
            cameraParameter["imageHeight"]=imageHeight
            cameraParameter["focalLength"] = intrinsics.focalLength
            cameraParameter["principlePoint"] = intrinsics.principalPoint
            cameraParameter["cameraPose"] = serializePose(camera.displayOrientedPose)
            Log.d("cameraParameter kotlin", "${cameraParameter} kotlin")
            flutterPoseResult.success(cameraParameter)
            isTakePose = false
        }
        backgroundRenderer.draw(frame)

        if (camera.trackingState == TrackingState.PAUSED) {
            return
        }

        //         try {
        //             frame.acquireDepthImage().use { depthImage ->
        //                 containsNewDepthData = depthTimestamp == depthImage.timestamp
        //                 depthTimestamp = depthImage.timestamp
        // //                if (containsNewDepthData) {
        // //                    val plane = depthImage.planes[0]
        // //                    val buffer = plane.buffer.order(ByteOrder.nativeOrder())
        // //                    val array = ShortArray(buffer.remaining() / 2)
        // //                    buffer.asShortBuffer().get(array)
        // //                    Log.d("ARCore", "${array.toCollection(ArrayList())}")
        // //                }
        // //                activity.runOnUiThread {
        // //                    if (event != null) event!!.success(true)
        // //                }
        //             }
        //         } catch (e: NotYetAvailableException) {
        //             activity.runOnUiThread { if (event != null)
        // event!!.success("{\"hasPlane\":false, \"count\":0}") }
        //             containsNewDepthData = false
        //         }

        //         val points = DepthData.create(frame, session!!.createAnchor(camera.pose))
        //                 ?: return

        //         activity.runOnUiThread {
        //             if (event != null) event!!.success("{\"hasPlane\":true,
        // \"count\":${points.count}}")
        //         }

        //         if (isGetDepth) {
        //             Log.d("ARCore", "getting depth")
        //             val imageIntrinsics = camera.imageIntrinsics
        //             val focalLength = imageIntrinsics.focalLength[0]
        //             val size = imageIntrinsics.imageDimensions
        //             Log.d("ARCore", "f: $focalLength, w: ${size[0]}, h: ${size[1]}")
        //             val fovW = Math.toDegrees(2 * atan(size[0] / (focalLength * 2.0)))
        //             val fovH = Math.toDegrees(2 * atan(size[1] / (focalLength * 2.0)))
        //             Log.d("ARCore", "$fovW, $fovH")
        //             frame.acquireDepthImage().use { depthImage ->
        //                 val plane = depthImage.planes[0]
        //                 Log.d("ARCore", "plane: ${depthImage.width}, ${depthImage.height}")
        //                 val buffer = plane.buffer.order(ByteOrder.nativeOrder())
        //                 val array = ShortArray(buffer.remaining() / 2)
        //                 buffer.asShortBuffer().get(array)
        //                 isGetDepth = false
        //                 flutterResult.success("{\"depth\":\"${array.toCollection(ArrayList())}\",
        // \"fovW\":\"$fovW\", \"fovH\":\"$fovH\"}")
        //             }
        //         }

        //        DepthData.filterUsingPlanes(points, session!!.getAllTrackables(Plane::class.java))

        // depthRenderer.update(points.points)
        // depthRenderer.draw(camera)
        //
        //        // Get projection matrix.
        //        val projmtx = FloatArray(16)
        //        camera.getProjectionMatrix(projmtx, 0, 0.1f, 100.0f)
        //
        //        // Get camera matrix and draw.
        //        val viewmtx = FloatArray(16)
        //        camera.getViewMatrix(viewmtx, 0)
        //
        //        val colorCorrectionRgba = FloatArray(4)
        //        frame.lightEstimate.getColorCorrection(colorCorrectionRgba, 0)
        //
        //        frame.acquirePointCloud().use { pointCloud ->
        //            pointCloudRenderer.update(pointCloud)
        //            pointCloudRenderer.draw(viewmtx, projmtx)
        //        }
        //
        //        planeRenderer.drawPlanes(
        //                session!!.getAllTrackables(Plane::class.java), camera.displayOrientedPose,
        // projmtx)

    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        //        Log.d("ARCore", "containsNewDepthData: $containsNewDepthData")
        event = events
        //        events!!.success(containsNewDepthData)
    }

    override fun onCancel(arguments: Any?) {
        event = null
    }
}
