import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace/configs/size_config.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/constants/reconstruction.dart';
import 'package:marketplace/presentation/screens/reconstruction/reconstruction_config_screen.dart';
import 'package:marketplace/presentation/screens/reconstruction/file_image_preview_button.dart';
import 'package:marketplace/presentation/screens/reconstruction/image_viewer_screen.dart';
import 'package:marketplace/presentation/screens/reconstruction/image_progress_indicator.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'dart:io';

const List<Widget> cameraMode = <Widget>[Text('Manual'), Text('Auto')];

// ignore: must_be_immutable
class CameraScreen extends StatefulWidget {
  List<XFile>? imageFiles = [];
  List<Map<String, dynamic>?>? cameraParameterList = [];

  CameraScreen({Key? key, this.imageFiles, this.cameraParameterList})
      : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isARCoreSupported = false;

  MethodChannel channel =
      const MethodChannel('$arcoreMethodChannel/cameraParameter');

  late CameraController _cameraController;

  final List<bool> _selectCameraMode = <bool>[true, false];
  bool vertical = false;
  Timer? timer;
  bool isTaking = false;
  bool isLoading = true;

  late int? id;

  @override
  void initState() {
    // _checkARCoreSupport();
  
    _initFlutterCamera();
    
    super.initState();
    widget.imageFiles ??= [];
  }

  void onPlatformViewCreated(int id) async {
    setState(() {
      isLoading = false;
    });
  }

  // Future<void> _checkARCoreSupport() async {
  //   try {
  //     MethodChannel supportChannel = const MethodChannel(arcoreMethodChannel);
  //     final String result =
  //         await supportChannel.invokeMethod('isARCoreSupported');

  //     if (result == 'support') {
  //       setState(() {
  //         isARCoreSupported = true;
  //       });
  //     } else {
  //       setState(() {
  //         isARCoreSupported = false;
  //         widget.cameraParameterList = null;
  //       });
        
  //     }
  //   } on PlatformException catch (e) {
  //     throw Exception();
  //   }
  // }

  Future<void> _initFlutterCamera() async {
    final cameras = await availableCameras();

    final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(camera, ResolutionPreset.ultraHigh,
        enableAudio: false);
    await _cameraController.initialize();
    await _cameraController.lockCaptureOrientation();
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    timer?.cancel();

    super.dispose();
  }

  _renameImageFile(XFile imageXFile, String fileName) async {
    File imageFile = File(imageXFile.path);
    String dir = path.dirname(imageFile.path);
    String newPath = path.join(dir, fileName);
    imageFile = imageFile.renameSync(newPath);
    return XFile(imageFile.path);
  }

  Future<XFile> takePicture() async {
    try {
      final path = await channel.invokeMethod<String>('takePicture');
      if (path != null) return XFile(path);
      throw Exception('error taking picture');
    } catch (e) {
      throw Exception();
    }
  }

  List<List<double>> decodeDoubleArray(List<double> cameraPose) {
    List<List<double>> cameraPose2DArray =
        List.generate(4, (i) => List.generate(4, (j) => 0.00));
    for (var i = 0; i < cameraPose.length; i++) {
      cameraPose2DArray[i % 4][i ~/ 4] = cameraPose[i];
    }

    return cameraPose2DArray;
  }

  Future<Map<dynamic, dynamic>> getCameraParameter() async {
    try {
      final cameraParameter = await channel
          .invokeMethod<Map<dynamic, dynamic>>('getCameraParameter');
      if (cameraParameter != null) {
        return cameraParameter;
      }

      throw Exception('error get camera parameter');
    } catch (e) {
      throw Exception();
    }
  }

  _manualTakePicture() async {
    String fileName =
        "${(widget.imageFiles!.length + 1).toString().padLeft(4, '0')}.jpg";
    widget.imageFiles ??= [];
    if (isARCoreSupported) {
      XFile image = await _renameImageFile(await takePicture(), fileName);

      widget.imageFiles!.add(image);
      Map<dynamic, dynamic> cameraParameter = await getCameraParameter();
      widget.cameraParameterList ??= [];
      widget.cameraParameterList!.add({
        'file_path': 'images/$fileName',
        'camera_parameter': cameraParameter
      });
    } else {

      if (!_cameraController.value.isTakingPicture) {
        XFile image = await _renameImageFile(
            await _cameraController.takePicture(), fileName);
        widget.imageFiles!.add(image);
      }
    }

    setState(() {
      widget.imageFiles = widget.imageFiles;
    });
  }

  _autoTakePicture() async {
    if (isTaking == false) {
      timer = Timer.periodic(const Duration(milliseconds: 1250),
          (Timer t) => {_manualTakePicture()});
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
    if (isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Material(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 80,
                child: Stack(alignment: Alignment.center, children: [
                  isARCoreSupported
                      ? AndroidView(
                          viewType: arcoreMethodChannel,
                          creationParamsCodec: const StandardMessageCodec(),
                          onPlatformViewCreated: onPlatformViewCreated,
                        )
                      : CameraPreview(_cameraController),
                  Column(
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
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(122, 255, 255, 255),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: ToggleButtons(
                                direction:
                                    vertical ? Axis.vertical : Axis.horizontal,
                                onPressed: (int index) {
                                  setState(() {
                                    // The button that is tapped is set to true, and the others to false.
                                    for (int i = 0;
                                        i < _selectCameraMode.length;
                                        i++) {
                                      _selectCameraMode[i] = i == index;
                                    }
                                    isTaking = false;
                                  });
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                color: Colors.black,
                                selectedColor: primaryColor,
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
                                    visible: widget.imageFiles!.isNotEmpty,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: GestureDetector(
                                      onTap: () => {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ImageViewerScreen(
                                              cameraParameterList:
                                                  widget.cameraParameterList,
                                              cameraParameter:
                                                  widget.cameraParameterList !=
                                                          null
                                                      ? widget
                                                          .cameraParameterList!
                                                          .last
                                                      : null,
                                              previewImage:
                                                  widget.imageFiles!.last,
                                              imageFiles: widget.imageFiles!,
                                              previousScreen: 'c',
                                            ),
                                          ),
                                        ),
                                        setState(() {
                                          isTaking = !isTaking;
                                        }),
                                      },
                                      child: FileImagePreviewButton(
                                          imageFiles: widget.imageFiles!),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70.0,
                                    width: 70.0,
                                    child: FloatingActionButton(
                                        heroTag: "takePictureButton",
                                        backgroundColor: const Color.fromARGB(
                                            122, 255, 255, 255),
                                        child: Icon(
                                          isTaking && _selectCameraMode[1]
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
                                              else if (_selectCameraMode[1])
                                                {_autoTakePicture()}
                                            }),
                                  ),
                                  SizedBox(
                                    height: 40.0,
                                    width: 40.0,
                                    child: FloatingActionButton(
                                      heroTag: "nextButton",
                                      backgroundColor: Colors.white,
                                      onPressed: () => {
                                        if (widget.imageFiles!.length <
                                            minImages)
                                          {_showMinimumImagesModal(context)}
                                        else
                                          {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReconstructionConfigScreen(
                                                  imageFiles:
                                                      widget.imageFiles!,
                                                  cameraParameterList: widget
                                                      .cameraParameterList,
                                                ),
                                              ),
                                            ),
                                            setState(() {
                                              isTaking = false;
                                            }),
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
                ]),
              ),
              Expanded(
                flex: 6,
                child: Container(
                    color: surfaceColor,
                    child:
                        ImageProgressIndicatior(imageFiles: widget.imageFiles)),
              )
            ],
          ),
        ),
      );
    }
  }
}

_showMinimumImagesModal(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 150),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                      text: "กรุณาถ่ายรูปขั้นต่ำอย่างน้อย $minImages รูป",
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
