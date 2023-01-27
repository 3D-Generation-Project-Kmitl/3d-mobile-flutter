import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace/configs/size_config.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/data/repositories/gen3d_repository.dart';
import 'package:marketplace/presentation/screens/reconstruction/model_viewer.dart';
import 'package:marketplace/presentation/screens/reconstruction/file_image_preview_button.dart';
import 'package:marketplace/presentation/screens/reconstruction/image_viewer_screen.dart';
import 'package:marketplace/presentation/widgets/image_card_widget.dart';
import 'dart:async';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  final List<XFile>? imageFiles;
  
  const CameraScreen({Key? key, this.imageFiles}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isLoading = true;
  bool _isTaking = false;
  bool isARCoreSupported=false;

  List<XFile>? imageFiles;

  String modelPath = "";
  late CameraController _cameraController;
  final Gen3DModelRepository gen3dModelRepository = Gen3DModelRepository();

  @override
  void initState() {
    _initCamera();
    super.initState();
    if (widget.imageFiles != null && widget.imageFiles!.isNotEmpty) {
      imageFiles = widget.imageFiles;
    } else {
      imageFiles = [];
    }
    
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
    isARCoreSupported=await CameraDataFromARCore.isARCoreSupported();
  }

  _manualTakePicture() async {
    imageFiles!.add(await _cameraController.takePicture());
    if (isARCoreSupported) {
      
      Map<String, dynamic>? cameraData = await CameraDataFromARCore.getCameraData();
      print('hello pure');
      print(cameraData);
    }


    setState(() {
      imageFiles = imageFiles;
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
              CameraPreview(_cameraController),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Visibility(
                          maintainSize: true,
                          visible: imageFiles!.isNotEmpty,
                          maintainAnimation: true,
                          maintainState: true,
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ImageViewerScreen(
                                      previewImage: imageFiles!.last,
                                      imageFiles: imageFiles!),
                                ),
                              )
                            },
                            child:
                                FileImagePreviewButton(imageFiles: imageFiles!),
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: "takePictureButton",
                          backgroundColor: Colors.white,
                          onPressed: () => _manualTakePicture(),
                        ),
                        Container(
                          height: 40.0,
                          width: 40.0,
                          child: FloatingActionButton(
                            heroTag: "nextButton",
                            backgroundColor: secondaryLight,
                            onPressed: () => {},
                            child: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 20),
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

class CameraDataFromARCore {
  static const MethodChannel _channel = const MethodChannel('arcore');

  static Future<bool> isARCoreSupported() async {
    try {
      final bool result = await _channel.invokeMethod('isARCoreSupported');
      return result;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getCameraData() async {
    try {
      final Map<String, dynamic> result =
          await _channel.invokeMethod('getCameraData');
      return result;
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
  }
}
