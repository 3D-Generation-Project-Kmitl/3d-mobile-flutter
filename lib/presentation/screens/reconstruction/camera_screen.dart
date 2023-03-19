import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/configs/size_config.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/constants/reconstruction.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/presentation/helpers/helpers.dart';
import 'package:marketplace/presentation/screens/reconstruction/file_image_preview_button.dart';
import 'package:marketplace/presentation/screens/reconstruction/image_progress_indicator.dart';
import 'dart:async';

import 'package:marketplace/routes/screens_routes.dart';

const List<Widget> cameraMode = <Widget>[Text('Manual'), Text('Auto')];

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;

  final List<bool> _selectCameraMode = <bool>[true, false];
  bool vertical = false;
  Timer? timer;
  bool isTaking = false;
  bool isLoading = true;
  late ReconstructionCubit reconstructionCubit;

  late int? id;

  @override
  void initState() {
    _initFlutterCamera();
    reconstructionCubit = context.read<ReconstructionCubit>();
    super.initState();
  }

  void onPlatformViewCreated(int id) async {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _initFlutterCamera() async {
    final cameras = await availableCameras();

    final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(camera, ResolutionPreset.ultraHigh,
        enableAudio: false);
    await _cameraController.initialize();
    await _cameraController.lockCaptureOrientation();
    try {
      await _cameraController.setFlashMode(FlashMode.off);
    } catch (e) {
      // ignore: avoid_print
    }
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    timer?.cancel();

    super.dispose();
  }

  _manualTakePicture() async {
    reconstructionCubit.takePicture(_cameraController);
  }

  _stopTakingPicture() {
    timer?.cancel();
    setState(() {
      isTaking = false;
    });
  }

  _autoTakePicture() async {
    if (isTaking == false) {
      ReconstructionState state;
      timer = Timer.periodic(
          const Duration(milliseconds: 1250),
          (Timer t) => {
                state = context.read<ReconstructionCubit>().state,
                if (state.imageFiles.length < maxImages)
                  {_manualTakePicture()}
                else
                  {
                    _stopTakingPicture(),
                    showInfoDialog(
                      context,
                      title: "ถ่ายรูปได้สูงสุด $maxImages รูป",
                      delay: 3000,
                    )
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

    if (isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return BlocBuilder<ReconstructionCubit, ReconstructionState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: CameraPreview(_cameraController),
                  ),
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
                            _stopTakingPicture();
                            Navigator.pop(context);
                            reconstructionCubit.clear();
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
                                  _stopTakingPicture();
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Visibility(
                                  maintainSize: true,
                                  visible: state.imageFiles.isNotEmpty,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  child: GestureDetector(
                                    onTap: () => {
                                      Navigator.pushNamed(
                                          context, reconImagePreviewRoute,
                                          arguments: [
                                            state.imageFiles.last,
                                            true
                                          ]),
                                      _stopTakingPicture(),
                                    },
                                    child: FileImagePreviewButton(
                                        imageFiles: state.imageFiles),
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
                                            if (state.imageFiles.length <
                                                maxImages)
                                              {
                                                if (_selectCameraMode[0])
                                                  {_manualTakePicture()}
                                                else if (_selectCameraMode[1])
                                                  {_autoTakePicture()}
                                              }
                                            else
                                              {
                                                showInfoDialog(
                                                  context,
                                                  title:
                                                      "ถ่ายรูปได้สูงสุด $maxImages รูป",
                                                  delay: 3000,
                                                ),
                                                _stopTakingPicture(),
                                              }
                                          }),
                                ),
                                SizedBox(
                                  height: 40.0,
                                  width: 40.0,
                                  child: FloatingActionButton(
                                    heroTag: "nextButton",
                                    backgroundColor: Colors.white,
                                    onPressed: () => {
                                      _stopTakingPicture(),
                                      if (state.imageFiles.length < minImages)
                                        {
                                          showInfoDialog(
                                            context,
                                            title:
                                                "กรุณาถ่ายรูปขั้นต่ำอย่างน้อย $minImages รูป",
                                            delay: 3000,
                                          )
                                        }
                                      else
                                        {
                                          Navigator.pushNamed(
                                            context,
                                            reconConfigRoute,
                                          )
                                        }
                                    },
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar:
                ImageProgressIndicator(imageFiles: state.imageFiles),
          );
        },
      );
    }
  }
}
