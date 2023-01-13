import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/configs/size_config.dart';
import 'package:marketplace/data/repositories/gen3d_repository.dart';
import 'package:marketplace/presentation/screens/reconstruction/model_viewer.dart';

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
  bool _isDone = false;
  late XFile file;
  String modelPath = "";
  late CameraController _cameraController;
  final Gen3DModelRepository gen3dModelRepository = Gen3DModelRepository();

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
    _cameraController = CameraController(camera, ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() {
      _isLoading = false;
      _isDone = false;
    });
  }

  _recordVideo() async {
    if (_isRecording) {
      file = await _cameraController.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _isDone = true;
        _isLoading = true;
      });
      await _sendRequestToGenerate3DModel();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ModelViewer(modelPath: modelPath)));
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() {
        _isRecording = true;
        _isDone = false;
      });
    }
  }

  _sendRequestToGenerate3DModel() async {
    modelPath = await gen3dModelRepository.gen3DModel(file.path, file.name);
    print('File name: ${file.name}');
    print('File path: ${file.path}');
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
      //     children: [
      //       Column(
      //         children: [
      //           AppBar(backgroundColor: Colors.white),
      //           CameraPreview(_cameraController),
      //         ],
      //       ),
      //       Column(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: [
      //                 TextButton(
      //                   style: TextButton.styleFrom(
      //                     foregroundColor:
      //                         Theme.of(context).colorScheme.onPrimary,
      //                     backgroundColor:
      //                         Theme.of(context).colorScheme.primary,
      //                   ),
      //                   onPressed: () {},
      //                   child: const Text('Auto'),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.all(25),
      //                   child: FloatingActionButton(
      //                     backgroundColor: Colors.black,
      //                     child: Icon(_isRecording ? Icons.stop : Icons.circle),
      //                     onPressed: () => _recordVideo(),
      //                   ),
      //                 ),
      //                 TextButton(
      //                   style: TextButton.styleFrom(
      //                     foregroundColor:
      //                         Theme.of(context).colorScheme.onPrimary,
      //                     backgroundColor:
      //                         Theme.of(context).colorScheme.primary,
      //                   ),
      //                   onPressed: () {},
      //                   child: const Text('Done'),
      //                 )
      //               ]),
      //           Container(
      //             height: 80.0,
      //             color: Colors.white,
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // );
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            CameraPreview(_cameraController),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // TextButton(
                      //   style: TextButton.styleFrom(
                      //     foregroundColor:
                      //         Theme.of(context).colorScheme.onPrimary,
                      //     backgroundColor:
                      //         Theme.of(context).colorScheme.primary,
                      //   ),
                      //   onPressed: () {},
                      //   child: const Text('Auto'),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          child: Icon(_isRecording ? Icons.stop : Icons.circle),
                          onPressed: () => _recordVideo(),
                        ),
                      ),
                      //       TextButton(
                      //         style: TextButton.styleFrom(
                      //           foregroundColor:
                      //               Theme.of(context).colorScheme.onPrimary,
                      //           backgroundColor:
                      //               Theme.of(context).colorScheme.primary,
                      //         ),
                      //         onPressed: () async {
                      //           if (_isDone) {}
                      //         },
                      //         child: const Text('Done'),
                      //       ),
                    ]),
                Container(
                  height: 80.0,
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
