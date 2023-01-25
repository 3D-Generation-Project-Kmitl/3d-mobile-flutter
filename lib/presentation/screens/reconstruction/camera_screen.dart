import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/configs/size_config.dart';
import 'package:marketplace/data/repositories/gen3d_repository.dart';
import 'package:marketplace/presentation/screens/reconstruction/model_viewer.dart';
import 'package:marketplace/presentation/screens/reconstruction/file_image_preview_button.dart';
import 'package:marketplace/presentation/screens/reconstruction/image_viewer_screen.dart';
import 'package:marketplace/presentation/widgets/image_card_widget.dart';
import 'dart:async';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isLoading = true;
  bool _isTaking = false;
  int numberOfPicture = 0;
  List<XFile> imageFiles = [];
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
    _cameraController =
        CameraController(camera, ResolutionPreset.high, enableAudio: false);
    await _cameraController.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  _manualTakePicture() async {
    imageFiles.add(await _cameraController.takePicture());
    setState(() {
      imageFiles = imageFiles;
      numberOfPicture += 1;
    });
  }

  _autoTakePicture() async {}

  // _sendRequestToGenerate3DModel() async {
  //   modelPath = await gen3dModelRepository.gen3DModel(file.path, file.name);
  //   print('File name: ${file.name}');
  //   print('File path: ${file.path}');
  // }

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
      return SafeArea(
        child: Center(
          child: Stack(
            children: [
              Column(
                children: [
                  AppBar(backgroundColor: Colors.white),
                  CameraPreview(_cameraController),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Visibility(
                          maintainSize: true,
                          visible: imageFiles.isNotEmpty,
                          maintainAnimation: true,
                          maintainState: true,
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ImageViewerScreen(
                                    previewImage: imageFiles.last,
                                    imageFiles:imageFiles
                                  ),
                                ),
                              )
                            },
                            child: FileImagePreviewButton(
                                imagePath: imageFiles.isNotEmpty
                                    ? imageFiles.last.path
                                    : '',
                                numberOfPicture: numberOfPicture),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () => _manualTakePicture(),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {},
                          child: const Text('Next'),
                        )
                      ]),
                  Container(
                    height: 80.0,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
