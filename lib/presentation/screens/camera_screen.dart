import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/configs/size_config.dart';

import 'dart:async';
import 'dart:io';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(camera, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      print(file.path);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // return Center(
      //   child: Stack(
      //     alignment: Alignment.bottomCenter,
      //     children: [
      //       CameraPreview(_cameraController),
      //       Padding(
      //         padding: const EdgeInsets.all(25),
      //         child: FloatingActionButton(
      //           backgroundColor: Colors.white,
      //           child: Icon(_isRecording ? Icons.stop : Icons.circle),
      //           onPressed: () => _recordVideo(),
      //         ),
      //       ),
      //     ],
      //   ),
      // );
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        body: SafeArea(
          child: Stack(children: [
            Center(child: CameraPreview(_cameraController)),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {},
                        child: const Text('Auto'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          child: Icon(_isRecording ? Icons.stop : Icons.circle),
                          onPressed: () => _recordVideo(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                        ),
                        iconSize: 30,
                        tooltip: 'Generate a 3D Model',
                        onPressed: () {},
                        color: Colors.greenAccent,
                      )
                    ]),
                Container(
                  height: 100.0,
                  color: Colors.white,
                ),
              ],
            ),
          ]),
        ),
      );
    }
  }
}
