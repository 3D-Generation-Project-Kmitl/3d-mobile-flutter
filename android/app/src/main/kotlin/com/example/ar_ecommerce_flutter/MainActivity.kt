package com.example.marketplace

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity
import com.google.ar.core.ArCoreApk
import com.google.ar.core.Config
import com.google.ar.core.Session
import com.google.ar.core.Frame
import com.google.ar.core.Camera
import com.google.ar.core.Anchor
import com.google.ar.core.CameraIntrinsics
import com.google.ar.core.exceptions.UnavailableException
import io.flutter.Log


class MainActivity: FlutterActivity() {
    private val channel="arcore";
    private var session: Session?=null;
    private var isInstallRequest = false;


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
      call, result ->
      if(call.method=="isARCoreSupported"){
        session = Session(this);
        Config config = session.getConfig();
        session.configure(config);
        session.resume();
        result.success(isARCoreSupported());

      }else if(call.method=="getCameraData"){
        var cameraData=getCameraData();
        if(cameraData==null){
            result.error("UNAVAILABLE", "Camera data not available.", null);
        }else{
        result.success(cameraData);
        }
      }else {
        result.notImplemented();
      }
    }
  }
    private fun isARCoreSupported(): Boolean {
      return when (ArCoreApk.getInstance().checkAvailability(this)!!) {
          ArCoreApk.Availability.SUPPORTED_INSTALLED -> true
          ArCoreApk.Availability.SUPPORTED_APK_TOO_OLD, ArCoreApk.Availability.SUPPORTED_NOT_INSTALLED -> {
              try {
                  when (ArCoreApk.getInstance().requestInstall(this, !isInstallRequest)!!) {
                      ArCoreApk.InstallStatus.INSTALL_REQUESTED -> {
                          Log.d("ARCore:", "ARCore installation requested.")
                          isInstallRequest = true
                          false
                      }
                      ArCoreApk.InstallStatus.INSTALLED -> true
                  }
              } catch (e: UnavailableException) {
                  Log.d("ARCore:", "ARCore not installed", e)
                  false
              }
          }
          ArCoreApk.Availability.UNSUPPORTED_DEVICE_NOT_CAPABLE -> {
              Log.d("ARCore:", "UNSUPPORTED_DEVICE_NOT_CAPABLE")
              false
          }
          ArCoreApk.Availability.UNKNOWN_CHECKING, ArCoreApk.Availability.UNKNOWN_ERROR, ArCoreApk.Availability.UNKNOWN_TIMED_OUT -> {
              Log.d("ARCore:", "UNKNOWN")
              false
          }
      }
}
private fun getCameraData():Map<String,Any?>{
  try {
  var frame:Frame = session!!.update();
  var camera:Camera = frame.getCamera();
  var  cameraPoseAnchor:Anchor=session!!.createAnchor(camera.getPose());
  var  intrinsics:CameraIntrinsics = camera.getTextureIntrinsics();
  var modelMatrix:FloatArray = FloatArray(16);

  cameraPoseAnchor.getPose().toMatrix(modelMatrix, 0);

  var cameraData=mapOf("focalLength" to intrinsics.getFocalLength(), 
                          "principalPoint" to intrinsics.getPrincipalPoint(), 
                          "transformMatrix" to modelMatrix)

  return cameraData as Map<String,Any?>;
  }catch(e: UnavailableException){
      Log.d(e)
      return null as Map<String,Any?>;
  }

}

}


