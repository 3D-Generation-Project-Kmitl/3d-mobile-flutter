import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace/configs/size_config.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/data/repositories/gen3d_repository.dart';
import 'package:marketplace/presentation/screens/reconstruction/model_viewer.dart';
import 'package:marketplace/presentation/screens/reconstruction/reconstruction_config_screen.dart';
import 'package:marketplace/presentation/screens/reconstruction/file_image_preview_button.dart';
import 'package:marketplace/presentation/screens/reconstruction/image_viewer_screen.dart';
import 'package:marketplace/presentation/screens/reconstruction/image_progress_indicator.dart';
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
  // bool isARCoreSupported=false;

  List<XFile>? imageFiles;

  String modelPath = "";
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;
  final Gen3DModelRepository gen3dModelRepository = Gen3DModelRepository();

  @override
  void initState() {
    super.initState();

    _initCamera();
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    setState(() {
      _cameraController =
          CameraController(camera, ResolutionPreset.high, enableAudio: false);
      _initializeControllerFuture = _cameraController.initialize();
    });

    // isARCoreSupported=await CameraDataFromARCore.isARCoreSupported();
  }

  _manualTakePicture() async {
    await _initializeControllerFuture;
    imageFiles!.add(await _cameraController.takePicture());
    // if (isARCoreSupported) {

    //   Map<String, dynamic>? cameraData = await CameraDataFromARCore.getCameraData();
    //   print('hello pure');
    //   print(cameraData);
    // }

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

    return SafeArea(
      child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Stack(alignment: Alignment.bottomCenter, children: [
                  // Material(
                  //   child: IconButton(
                  //                onPressed: (){
                  //                  Navigator.pop(context);
                  //                },
                  //                icon:Icon(Icons.arrow_back_ios), 
                  //                //replace with our own icon data.
                  //             ),
                  // ),
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
                                child: FileImagePreviewButton(
                                    imageFiles: imageFiles!),
                              ),
                            ),
                            Container(
                               height: 70.0,
                              width: 70.0,
                              child: FloatingActionButton(
                                heroTag: "takePictureButton",
                                backgroundColor: Colors.white,
                                onPressed: () => _manualTakePicture(),
                              ),
                            ),
                            Container(
                              height: 40.0,
                              width: 40.0,
                              child: FloatingActionButton(
                                heroTag: "nextButton",
                                backgroundColor: Colors.white,
                                onPressed: () => {
                                  if (imageFiles!.length < 20)
                                    {
                                      _showMinmumImagesModal(context)
                                    }
                                  else
                                    {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReconstructionConfigScreen(
                                                  imageFiles: imageFiles!),
                                        ),
                                      )
                                    }
                                },
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ]),
                      const SizedBox(height: 20),
                    ],
                  )
                ]),
                Expanded(
                    flex: 5,
                    child: Container(
                        color: surfaceColor,
                        child: ImageProgressIndicatior(imageFiles: imageFiles)))
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

_showMinmumImagesModal(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            constraints: BoxConstraints(maxHeight: 150),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: 
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text:
                            "กรุณาถ่ายรูปขั้นต่ำอย่างน้อย 20 รูป",
                        style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: secondaryDark)),
                  ),
                
              ),
            ),
          ),
        );
      });
}






// class CameraDataFromARCore {
//   static const MethodChannel _channel = const MethodChannel('arcore');

//   static Future<bool> isARCoreSupported() async {
//     try {
//       final bool result = await _channel.invokeMethod('isARCoreSupported');
//       return result;
//     } on PlatformException catch (e) {
//       print(e);
//       return false;
//     }
//   }

//   static Future<Map<String, dynamic>?> getCameraData() async {
//     try {
//       final Map<String, dynamic> result =
//           await _channel.invokeMethod('getCameraData');
//       return result;
//     } on PlatformException catch (e) {
//       print(e);
//       return null;
//     }
//   }
// }
