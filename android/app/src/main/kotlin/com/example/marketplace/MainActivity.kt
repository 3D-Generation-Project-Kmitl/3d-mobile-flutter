package com.example.marketplace

import com.google.ar.core.ArCoreApk
import com.google.ar.core.Config
import com.google.ar.core.Session
import com.google.ar.core.exceptions.UnavailableException
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
//     private val CHANNEL = "ar.core.platform"
//     private var isSupported = false
//     private var session: Session? = null
//     private var flutterResult: MethodChannel.Result? = null
//     private var isInstallRequest = false
//     private var isCameraRequest = false

//     override fun onResume() {
//         super.onResume()
//         if (flutterResult != null && isInstallRequest) {
//             flutterResult = null
//             isSupported = isARCoreSupportedAndUpToDate()
//             isInstallRequest = false
//             if (isSupported) flutterResult!!.success("support")
//             else flutterResult!!.success("notInstall")
//         }
//     }

//     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)
//         flutterEngine.platformViewsController.registry.registerViewFactory("ar.core.platform", CameraViewFactory(this, flutterEngine.dartExecutor))
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//             if (call.method.equals("isARCoreSupported")) {
//                 isSupported = isARCoreSupportedAndUpToDate()
//                 if (isSupported) {
// //                    if (session == null) {
                        
// //                            session = Session(this)
// //                            if (!session!!.isDepthModeSupported(Config.DepthMode.AUTOMATIC)) {
// //                                session = null
// //                                result.success("notSupport")
// //                            } else {
// //                                session = null
//                                 result.success("support")
// //                            }
                        
// //                    }
//                 } else if (!isSupported && isInstallRequest) {
//                     flutterResult = result
//                 } else {
//                     result.success("notSupport");
//                 }
//             }
//         }
//     }

//     private fun isARCoreSupportedAndUpToDate(): Boolean {
//         return when (ArCoreApk.getInstance().checkAvailability(this)!!) {
//             ArCoreApk.Availability.SUPPORTED_INSTALLED -> true
//             ArCoreApk.Availability.SUPPORTED_APK_TOO_OLD, ArCoreApk.Availability.SUPPORTED_NOT_INSTALLED ->false
// //            ArCoreApk.Availability.SUPPORTED_APK_TOO_OLD, ArCoreApk.Availability.SUPPORTED_NOT_INSTALLED -> {
//                 // try {
//                 //     when (ArCoreApk.getInstance().requestInstall(this,false)!!) {
//                 //         ArCoreApk.InstallStatus.INSTALL_REQUESTED -> {
//                 //             Log.d("ARCore:", "ARCore installation requested.")
//                 //             isInstallRequest = true
//                 //             false
//                 //         }
//                 //         ArCoreApk.InstallStatus.INSTALLED -> true
//                 //     }
//                 // } catch (e: UnavailableException) {
//                 //     Log.d("ARCore:", "ARCore not installed", e)
//                 //     false
//                 // }
// //            }
//             ArCoreApk.Availability.UNSUPPORTED_DEVICE_NOT_CAPABLE -> {
//                 Log.d("ARCore:", "UNSUPPORTED_DEVICE_NOT_CAPABLE")
//                 false
//             }
//             ArCoreApk.Availability.UNKNOWN_CHECKING, ArCoreApk.Availability.UNKNOWN_ERROR, ArCoreApk.Availability.UNKNOWN_TIMED_OUT -> {
//                 Log.d("ARCore:", "UNKNOWN")
//                 false
//             }
//         }
//     }
}
