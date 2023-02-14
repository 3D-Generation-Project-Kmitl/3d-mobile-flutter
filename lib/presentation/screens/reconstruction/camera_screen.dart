import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace/configs/size_config.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/constants/reconstruction.dart';
import 'package:marketplace/presentation/screens/reconstruction/model_viewer.dart';
import 'package:marketplace/presentation/screens/reconstruction/reconstruction_config_screen.dart';
import 'package:marketplace/presentation/screens/reconstruction/file_image_preview_button.dart';
import 'package:marketplace/presentation/screens/reconstruction/image_viewer_screen.dart';
import 'package:marketplace/presentation/screens/reconstruction/image_progress_indicator.dart';
import 'package:marketplace/presentation/widgets/image_card_widget.dart';
// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
// import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
// import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_camera_manager.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:path/path.dart' as path;
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


  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;

  final List<bool> _selectCameraMode = <bool>[true, false];
  bool vertical = false;
  Timer? timer;
  bool isTaking = false;
  bool isARCoreSupported = false;
  // ARCameraManager? arCameraManager;

  late int? id;

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
    // isARCoreSupported = await CameraDataFromARCore.isARCoreSupported();
  }

  _renameImageFile(XFile imageXFile) async{
    File imageFile = File(imageXFile.path);
    print('Original path: ${imageFile.path}');
    String dir = path.dirname(imageFile.path);
    String newPath = path.join(dir, "${(imageFiles!.length+1).toString().padLeft(4, '0')}.jpg");
    print('NewPath: ${newPath}');
    imageFile=imageFile.renameSync(newPath);
    return new XFile(imageFile.path);
  }

  _manualTakePicture() async {
    await _initializeControllerFuture;
    XFile image = await _renameImageFile(await _cameraController.takePicture());
    imageFiles!.add(image);
    // if (isARCoreSupported) {

    // Matrix4? cameraData = await arCameraManager!.getCameraPose();
    // print('hello pure');
    // print(cameraData);
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



  @override
  Widget build(BuildContext buildContext) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SizeConfig().init(context);
    // arCameraManager=ARCameraManager(buildContext);

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
                                                    ? Icons.stop_rounded
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
                                              if (imageFiles!.length < minImages)
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

class CameraDataFromARCore {
  static const MethodChannel _channel = const MethodChannel('arcore');

  // static Future<bool> isARCoreSupported() async {
  //   try {
  //     final bool result = await _channel.invokeMethod('isARCoreSupported');
  //     return result;
  //   } on PlatformException catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

  // static Future<Matrix4?> getCameraData(ARCameraManager arCameraManager) async {
  //   try {
  //     final Matrix4? result =
  //         await arCameraManager.getCameraPose();
  //     return result;
  //   } on PlatformException catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
}
