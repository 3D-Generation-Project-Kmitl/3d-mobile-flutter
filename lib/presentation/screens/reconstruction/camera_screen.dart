
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
import 'package:marketplace/presentation/widgets/image_card_widget.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:path/path.dart' as path;
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

const List<Widget> cameraMode = <Widget>[Text('Manual'), Text('Auto')];

class CameraScreen extends StatefulWidget {
  final List<XFile>? imageFiles;

  const CameraScreen({Key? key, this.imageFiles}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // bool isARCoreSupported=false;
MethodChannel channel = const MethodChannel('ar.core.platform/depth');
  List<XFile>? imageFiles;

  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;

  final List<bool> _selectCameraMode = <bool>[true, false];
  bool vertical = false;
  Timer? timer;
  bool isTaking = false;
  bool isARCoreSupported = false;

  late int? id;

  @override
  void initState() {
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
    timer?.cancel();
    super.dispose();
  }

  _renameImageFile(XFile imageXFile) async {
    File imageFile = File(imageXFile.path);
    print('Original path: ${imageFile.path}');
    String dir = path.dirname(imageFile.path);
    String newPath = path.join(
        dir, "${(imageFiles!.length + 1).toString().padLeft(4, '0')}.jpg");
    print('NewPath: ${newPath}');
    imageFile = imageFile.renameSync(newPath);
    return new XFile(imageFile.path);
  }
  Future<XFile> takePicture() async {
    try {
      final path = await channel.invokeMethod<String>('takePicture');
      print('path '+path!!);
      if (path != null) return XFile(path);
      throw Exception('error taking picture');
    } catch (e) {
      print('takePicture error: $e');
      throw Exception();
    }
  }
  Future<dynamic> getCameraPost() async{
       try {
      final cameraPose = await channel.invokeMethod<dynamic>('getCameraPose');

      if (cameraPose != null) return cameraPose;
      throw Exception('error get camera pose');
    } catch (e) {
      print('getCameraPose error: $e');
      throw Exception();
    }
  }
  _manualTakePicture() async {
    XFile image = await _renameImageFile(await takePicture());
    imageFiles!.add(image);

    dynamic cameraData = await getCameraPost();
    print('hello pure: $cameraData');
    

    setState(() {
      imageFiles=imageFiles;
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


    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 80,
              child: Stack(alignment: Alignment.center, children: [
                AndroidView(
                  viewType: 'ar.core.platform',
                  creationParamsCodec: StandardMessageCodec(),
                ),
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
                                  });
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
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
                                                    imageFiles: imageFiles!),
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
                                        backgroundColor:
                                            Color.fromARGB(122, 255, 255, 255),
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
                                                        imageFiles:
                                                            imageFiles!),
                                              ),
                                            ),
                                            setState(() {
                                              isTaking = !isTaking;
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


 

