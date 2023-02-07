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

const List<Widget> cameraMode = <Widget>[Text('Manual'), Text('Auto')];

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
  final List<bool> _selectCameraMode = <bool>[true, false];
  bool vertical = false;
  Timer? timer;
  bool isTaking = false;

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
    timer?.cancel();
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
    _cameraController =
        CameraController(camera, ResolutionPreset.high, enableAudio: false);
    setState(() {
      _initializeControllerFuture = _cameraController.initialize();
    });
    await _cameraController.lockCaptureOrientation();
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

  _autoTakePicture() async {
    if (isTaking == false) {
      timer = Timer.periodic(
          Duration(milliseconds: 1250), (Timer t) => _manualTakePicture());
    } else {
      timer?.cancel();
    }
    setState(() {
      isTaking = !isTaking;
    });
  }

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

    return Material(
      child: SafeArea(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Expanded(
                    flex: 80,
                    child: Stack(alignment: Alignment.center, children: [
                      CameraPreview(_cameraController),
                      Container(
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: Column(
                                children: [
                                  Container(
                                    height: 40,
                                    // width:80,
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(122, 255, 255, 255),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: ToggleButtons(
                                      direction: vertical
                                          ? Axis.vertical
                                          : Axis.horizontal,
                                      onPressed: (int index) {
                                        setState(() {
                                          // The button that is tapped is set to true, and the others to false.
                                          for (int i = 0;
                                              i < _selectCameraMode.length;
                                              i++) {
                                            _selectCameraMode[i] = i == index;
                                          }
                                        });
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      color: Colors.black,
                                      selectedColor: primaryLight,
                                      renderBorder: false,
                                      fillColor: Colors.white,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(color: primaryColor),
                                      constraints: const BoxConstraints(
                                          minWidth: 75.0, minHeight: 40.0),
                                      isSelected: _selectCameraMode,
                                      children: cameraMode,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
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
                                                  builder: (context) =>
                                                      ImageViewerScreen(
                                                          previewImage:
                                                              imageFiles!.last,
                                                          imageFiles:
                                                              imageFiles!),
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
                                              backgroundColor: Color.fromARGB(
                                                  122, 255, 255, 255),
                                              child: Icon(
                                                isTaking
                                                    ? Icons.stop
                                                    : Icons.circle,
                                                color: _selectCameraMode[0]
                                                    ? Colors.white
                                                    : Colors.red,
                                                size: 70,
                                              ),
                                              onPressed: () => {
                                                    if (_selectCameraMode[0])
                                                      {_manualTakePicture()}
                                                    else if (_selectCameraMode[
                                                        1])
                                                      {_autoTakePicture()}
                                                  }),
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
                                                  _showMinmumImagesModal(
                                                      context)
                                                }
                                              else
                                                {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReconstructionConfigScreen(
                                                              imageFiles:
                                                                  imageFiles!),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                        color: surfaceColor,
                        child: ImageProgressIndicatior(imageFiles: imageFiles)),
                  )
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
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                      text: "กรุณาถ่ายรูปขั้นต่ำอย่างน้อย 20 รูป",
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
