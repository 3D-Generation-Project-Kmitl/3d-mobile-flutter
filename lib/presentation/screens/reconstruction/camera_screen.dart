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

class CameraScreen extends StatefulWidget {
  final List<XFile>? imageFiles;
  final List<Map<String, dynamic>?>? cameraParameterList;

  const CameraScreen({Key? key, this.imageFiles, this.cameraParameterList})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isARCoreSupported = false;

  MethodChannel channel =
      const MethodChannel('$arcoreMethodChannel/cameraParameter');
  List<XFile>? imageFiles;
  List<Map<String, dynamic>?>? cameraParameterList;
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;

  final List<bool> _selectCameraMode = <bool>[true, false];
  bool vertical = false;
  Timer? timer;
  bool isTaking = false;
  bool isLoading = true;

  late int? id;

  @override
  void initState() {
    if (widget.imageFiles != null && widget.imageFiles!.isNotEmpty) {
        imageFiles = widget.imageFiles;
      } else {
        imageFiles = [];
      }
      if (widget.cameraParameterList != null &&
          widget.cameraParameterList!.isNotEmpty) {
        cameraParameterList = widget.cameraParameterList;
      } else {
        cameraParameterList = [];
      }
    _checkARCoreSupport();

    print('isARCoreSupported: $isARCoreSupported');
    if (!isARCoreSupported) {
      _initFlutterCamera();
      cameraParameterList = null;
      
    } 

    super.initState();
  }

  void onPlatformViewCreated(int id) async {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _checkARCoreSupport() async {
    try {
      MethodChannel supportChannel = const MethodChannel(arcoreMethodChannel);
      final String result =
          await supportChannel.invokeMethod('isARCoreSupported');
      print('checkARCoreSupport: $result');
      setState(() {
        if (result == 'support') {
          isARCoreSupported = true;
        } else {
          isARCoreSupported = false;
        }
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _initFlutterCamera() async {
    final cameras = await availableCameras();

    final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);
    await _cameraController.initialize();
    await _cameraController.lockCaptureOrientation();
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    timer?.cancel();
    setState(() {
      isLoading = true;
    });
    super.dispose();
  }

  _renameImageFile(XFile imageXFile, String fileName) async {
    File imageFile = File(imageXFile.path);
    print('Original path: ${imageFile.path}');
    String dir = path.dirname(imageFile.path);
    String newPath = path.join(dir, fileName);
    print('NewPath: ${newPath}');
    imageFile = imageFile.renameSync(newPath);
    return new XFile(imageFile.path);
  }

  Future<XFile> takePicture() async {
    try {
      final path = await channel.invokeMethod<String>('takePicture');
      print('path ' + path!!);
      if (path != null) return XFile(path);
      throw Exception('error taking picture');
    } catch (e) {
      print('takePicture error: $e');
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
      // final resultMap = Map<String, dynamic>.from(cameraParameterList!.cast<String, dynamic>());
      if (cameraParameter != null) {
        print('cameraParameter: $cameraParameter');
        print('cameraParameter Type: ${cameraParameter.runtimeType}');

        return cameraParameter;
      }

      throw Exception('error get camera parameter');
    } catch (e) {
      print('getcameraParameterList error: $e');
      throw Exception();
    }
  }

  _manualTakePicture() async {
    String fileName =
        "${(imageFiles!.length + 1).toString().padLeft(4, '0')}.jpg";

    if (isARCoreSupported) {
      XFile image = await _renameImageFile(await takePicture(), fileName);
      imageFiles!.add(image);
      Map<dynamic, dynamic> cameraParameter = await getCameraParameter();
      cameraParameterList!.add({
        'file_path': 'images/$fileName',
        'camera_parameter': cameraParameter
      });
      print('cameraParameterList: $cameraParameterList');
    } else {
      await _cameraController.initialize();
      await _cameraController.lockCaptureOrientation();
      XFile image = await _renameImageFile(
          await _cameraController.takePicture(), fileName);
      imageFiles!.add(image);
    }

    setState(() {
      imageFiles = imageFiles;
    });
  }

  _autoTakePicture() async {
    if (isTaking == false) {
      timer = Timer.periodic(
          Duration(milliseconds: 1250), (Timer t) => {
            if(!_cameraController.value.isTakingPicture){
            _manualTakePicture()
            }
            });
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
    print('cameraParameterList: $cameraParameterList');
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
                          creationParamsCodec: StandardMessageCodec(),
                          onPlatformViewCreated: onPlatformViewCreated,
                        )
                      : CameraPreview(_cameraController),
                  Container(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
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
                                      isTaking = false;
                                    });
                                  },
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
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
                                      visible: imageFiles!.isNotEmpty,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: GestureDetector(
                                        onTap: () => {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageViewerScreen(
                                                cameraParameterList:
                                                    cameraParameterList,
                                                cameraParameter:
                                                    cameraParameterList != null
                                                        ? cameraParameterList!
                                                            .last
                                                        : null,
                                                previewImage: imageFiles!.last,
                                                imageFiles: imageFiles!,
                                                previousScreen: 'c',
                                              ),
                                            ),
                                          ),
                                          setState(() {
                                            isTaking = !isTaking;
                                          }),
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
                                    Container(
                                      height: 40.0,
                                      width: 40.0,
                                      child: FloatingActionButton(
                                        heroTag: "nextButton",
                                        backgroundColor: Colors.white,
                                        onPressed: () => {
                                          if (imageFiles!.length < minImages)
                                            {_showMinmumImagesModal(context)}
                                          else
                                            {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReconstructionConfigScreen(
                                                    imageFiles: imageFiles!,
                                                    cameraParameterList:
                                                        cameraParameterList,
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
          ),
        ),
      );
    }
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
