// package com.example.marketplace

// import android.app.Activity
// import android.content.Context
// import io.flutter.embedding.engine.dart.DartExecutor
// import io.flutter.plugin.common.StandardMessageCodec
// import io.flutter.plugin.platform.PlatformView
// import io.flutter.plugin.platform.PlatformViewFactory

// class CameraViewFactory(activity: Activity, dartExecutor: DartExecutor): PlatformViewFactory(StandardMessageCodec.INSTANCE) {
//     private val activity = activity
//     private val dartExecutor = dartExecutor
//     override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
//         val creationParms = args as Map<String?, Any?>?
//         return CameraView(activity, dartExecutor)
//     }
// }