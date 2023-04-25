import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/configs/size_config.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/constants/reconstruction.dart';
import 'package:marketplace/cubits/cubits.dart';
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

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;

  final List<bool> _selectCameraMode = <bool>[true, false];
  bool vertical = false;
  Timer? timer;
  bool isTaking = false;
  bool isLoading = true;
  late ReconstructionCubit reconstructionCubit;
  int rotateClockwise90Degree = 0;
  bool showFocusCircle = false;
  bool splashOnce = false;
  double x = 0;
  double y = 0;
  late int? id;

  @override
  void initState() {
    super.initState();
    _initFlutterCamera();
    WidgetsBinding.instance.addObserver(this);
    reconstructionCubit = context.read<ReconstructionCubit>();
  }

  Future<void> _initFlutterCamera() async {
    try {
      final cameras = await availableCameras();

      final camera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back);

      _cameraController = CameraController(camera, ResolutionPreset.veryHigh,
          enableAudio: false);

      await _cameraController?.initialize().then((_) {
        if (!mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("ขออภัย มีบางอย่างผิดพลาดเกิดขึ้นกับกล้อง"),
            ),
          );
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          return;
        } else {
          setState(() => isLoading = false);
        }
      });

      _cameraController?.addListener(() {
        if (mounted) {
          _changeOrientation();
        }
        ;
        if (_cameraController!.value.hasError) {}
      });
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'cameraPermission':
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("ขออภัย ไม่ได้รับสิทธิ์ในการเข้าถึงกล้อง"),
              ),
            );
            break;
          default:
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("ขออภัย มีบางอย่างผิดพลาดเกิดขึ้นกับกล้อง"),
              ),
            );
            break;
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("ขออภัย มีบางอย่างผิดพลาดเกิดขึ้น"),
        ));
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
    try {
      await _cameraController?.setFlashMode(FlashMode.off);
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = _cameraController!;

    // App state changed before we got the chance to initialize.
    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      _stopTakingPicture();
    } else if (state == AppLifecycleState.resumed) {
      _initFlutterCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.removeListener(() {
      if (mounted) {
        _changeOrientation();
      }
      ;
      if (_cameraController!.value.hasError) {}
    });
    _cameraController?.dispose();
    timer?.cancel();

    super.dispose();
  }

  _changeOrientation() {
    if (_cameraController?.value.deviceOrientation ==
        DeviceOrientation.portraitUp) {
      rotateClockwise90Degree = 0;
      vertical = false;
    } else if (_cameraController?.value.deviceOrientation ==
        DeviceOrientation.landscapeLeft) {
      rotateClockwise90Degree = 3;
      vertical = true;
    } else if (_cameraController?.value.deviceOrientation ==
        DeviceOrientation.portraitDown) {
      rotateClockwise90Degree = 0;
      vertical = false;
    } else if (_cameraController?.value.deviceOrientation ==
        DeviceOrientation.landscapeRight) {
      rotateClockwise90Degree = 1;
      vertical = true;
    }
    setState(() {
      rotateClockwise90Degree = rotateClockwise90Degree;
      vertical = vertical;
    });
  }

  _manualTakePicture() async {
    if(_cameraController!.value.isTakingPicture || !_cameraController!.value.isInitialized) return;
    ReconstructionState state = context.read<ReconstructionCubit>().state;
    if(state.imageFiles.isEmpty){
      double _minAvailableExposureOffset = await _cameraController!.getMinExposureOffset();
      double _maxAvailableExposureOffset = await _cameraController!.getMaxExposureOffset();
      double _currentExposureOffset = (_minAvailableExposureOffset+_maxAvailableExposureOffset)/2;
      await _cameraController!.setExposureOffset(_currentExposureOffset);
    }
    setState(() {
      splashOnce = true;
      Future.delayed(const Duration(milliseconds: 200)).whenComplete(() {
        setState(() {
          splashOnce = false;
        });
      });
    });

    reconstructionCubit.takePicture(_cameraController!,rotateClockwise90Degree);
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
                    _showInfoDialog(
                      context,
                      title: "ถ่ายรูปได้สูงสุด $maxImages รูป",
                      delay: 3000,
                      rotation: rotateClockwise90Degree,
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

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    // setState(() {
    showFocusCircle = true;
    x = details.localPosition.dx;
    y = details.localPosition.dy;
    // });

    if (_cameraController == null) {
      return;
    }
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    // _cameraController!.setExposurePoint(offset);
    _cameraController!.setFocusPoint(offset);
    setState(() {
      Future.delayed(const Duration(milliseconds: 1000)).whenComplete(() {
        setState(() {
          showFocusCircle = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
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
                alignment: Alignment.center,
                children: [
                  RotatedBox(
                    quarterTurns: rotateClockwise90Degree,
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: splashOnce
                          ? Container(
                              color: Colors.black,
                            )
                          : CameraPreview(
                              _cameraController!
                            ),
                    ),
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                          style: BorderStyle.solid),
                    ),
                  ),
                  LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) =>
                          onViewFinderTap(details, constraints),
                    );
                  }),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: rotateClockwise90Degree == 1
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: IconButton(
                          icon: const Icon(
                            Icons.clear,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _stopTakingPicture();
                            _showConfirmCancelModal(context,rotateClockwise90Degree);

                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Column(
                          children: [
                            RotatedBox(
                              quarterTurns: rotateClockwise90Degree,
                              child: Container(
                                height:
                                    rotateClockwise90Degree == 0 ? 40 : null,
                                // width:80,
                                padding: EdgeInsets.zero,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(122, 255, 255, 255),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: ToggleButtons(
                                  direction: vertical
                                      ? Axis.vertical
                                      : Axis.horizontal,
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RotatedBox(
                                  quarterTurns: rotateClockwise90Degree,
                                  child: Visibility(
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
                                                _showInfoDialog(
                                                  context,
                                                  title:
                                                      "ถ่ายรูปได้สูงสุด $maxImages รูป",
                                                  delay: 3000,
                                                  rotation:
                                                      rotateClockwise90Degree,
                                                ),
                                                _stopTakingPicture(),
                                              }
                                          }),
                                ),
                                RotatedBox(
                                  quarterTurns: rotateClockwise90Degree,
                                  child: SizedBox(
                                    height: 40.0,
                                    width: 40.0,
                                    child: FloatingActionButton(
                                      heroTag: "nextButton",
                                      backgroundColor: Colors.white,
                                      onPressed: () => {
                                        _stopTakingPicture(),
                                        if (state.imageFiles.length < minImages)
                                          {
                                            _showInfoDialog(
                                              context,
                                              title:
                                                  "กรุณาถ่ายรูปขั้นต่ำอย่างน้อย $minImages รูป",
                                              delay: 3000,
                                              rotation: rotateClockwise90Degree,
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (showFocusCircle)
                    Positioned(
                        top: y - 20,
                        left: x - 20,
                        child: Container(
                          height: 40,
                          width: 40,
                          child: Center(
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 1.0)),
                            ),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 1.0)),
                        )),
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

Future<void> _showInfoDialog(BuildContext context,
    {String title = "",
    String message = "",
    int delay = 1000,
    int rotation = 0}) async {
  Timer timer = Timer(Duration(milliseconds: delay), () {
    Navigator.of(context).pop();
  });
  await showDialog<void>(
    barrierColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return RotatedBox(
        quarterTurns: rotation,
        child: AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.7),
          title: Center(
              child: Text(
            title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Colors.white,
                ),
          )),
          content: message != '' ? Text(message) : null,
        ),
      );
    },
  ).then(
    (value) => {
      timer.cancel(),
    },
  );
}

_showConfirmCancelModal(context,int rotation){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RotatedBox(
          quarterTurns: rotation,
          child: AlertDialog(
          title: const Text("คุณแน่ใจหรือไม่ว่าต้องการออกจากการถ่ายรูป"),
          titleTextStyle: 
            const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,fontSize: 20),
            actionsOverflowButtonSpacing: 20,
            actions: [
              ElevatedButton(onPressed: (){
              
              ReconstructionCubit reconstructionCubit = context.read<ReconstructionCubit>();
              reconstructionCubit.clear();
              Navigator.pop(context);
              Navigator.pop(context);
              },
              style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
               ), child: const Text("ออก",style: TextStyle(color: Colors.red ))),
               const SizedBox(width: 10,),
              ElevatedButton(onPressed: (){
          Navigator.of(context).pop();
              }, child: const Text("อยู่ต่อ")),
            ],
            content: const Text("การออกจากการถ่ายรูปจะทำให้รูปที่ถ่ายไว้หายไป",style: TextStyle(fontSize: 18),),
        ),
        );
    });
  }