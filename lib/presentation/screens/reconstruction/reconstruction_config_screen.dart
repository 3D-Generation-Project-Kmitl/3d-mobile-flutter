import 'package:flutter/material.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/presentation/helpers/helpers.dart';
import '../../../configs/size_config.dart';
import '../../../constants/reconstruction.dart';
import '../../../cubits/cubits.dart';
import '../../../routes/screens_routes.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

const List<Widget> modelQuality = <Widget>[
  Text('High'),
  Text('Medium'),
  Text('Low')
];

class ReconstructionConfigScreen extends StatefulWidget {
  const ReconstructionConfigScreen({Key? key}) : super(key: key);

  @override
  State<ReconstructionConfigScreen> createState() =>
      _ReconstructionConfigScreenState();
}

class _ReconstructionConfigScreenState
    extends State<ReconstructionConfigScreen> {
  bool isSending = false;

  Map<String, dynamic> reconstructionConfigs = {
    "userId": -888,
    "modelId": -888,
    "objectDetection": true,
    "quality": 'Low',
    "googleARCore": false,
  };
  final List<bool> _selectModelQuality = <bool>[false, false, true];

  bool vertical = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReconstructionCubit, ReconstructionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("ตั้งค่าการสร้างโมเดล 3 มิติ",
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("รูปภาพ (${state.imageFiles.length})"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, reconGalleryRoute);
                            },
                            child: Text('รูปภาพทั้งหมด',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: primaryColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("คุณภาพของโมเดล 3 มิติ"),
                  Center(
                    child: ToggleButtons(
                      direction: vertical ? Axis.vertical : Axis.horizontal,
                      onPressed: (int index) {
                        setState(() {
                          // The button that is tapped is set to true, and the others to false.
                          for (int i = 0; i < _selectModelQuality.length; i++) {
                            if (i == index) {
                              _selectModelQuality[i] = true;
                              Text quality = modelQuality[index] as Text;
                              reconstructionConfigs['quality'] = quality.data;
                            } else {
                              _selectModelQuality[i] = false;
                            }
                          }
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.white,
                      selectedColor: Colors.white,
                      fillColor: primaryColor,
                      color: Colors.black,
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),
                      isSelected: _selectModelQuality,
                      children: modelQuality,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("ระบบตรวจจับเฉพาะวัตถุ"),
                      Switch(
                        value: reconstructionConfigs["objectDetection"],
                        onChanged: (value) {
                          setState(() {
                            reconstructionConfigs["objectDetection"] = value;
                          });
                        },
                        activeTrackColor: primarySoftColor,
                        activeColor: primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: getProportionateScreenHeight(50),
              child: ElevatedButton(
                onPressed: () {
                  if (state.imageFiles.length < minImages) {
                    showInfoDialog(
                      context,
                      title: "กรุณาถ่ายรูปขั้นต่ำอย่างน้อย $minImages รูป",
                      delay: 3000,
                    );
                  } else {
                    setState(() {
                      isSending = true;
                    });
                    buildSending();
                    context
                        .read<StoreModelsCubit>()
                        .addReconstructionModel(state.imageFiles[0])
                        .then(
                          (model) => {
                            if (model != null)
                              {
                                setState(() {
                                  reconstructionConfigs['modelId'] =
                                      model.modelId;
                                  reconstructionConfigs['userId'] =
                                      model.userId;
                                }),
                                context
                                    .read<ReconstructionCubit>()
                                    .gen3DModel(reconstructionConfigs)
                                    .then((value) => {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              storeModelRoute,
                                              ModalRoute.withName(storeRoute))
                                        })
                              },
                          },
                        );
                  }
                },
                child: const Text(
                  "สร้างโมเดล 3 มิติ",
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> buildSending() {
    return showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('กำลังส่งข้อมูล',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: secondaryColor)),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
