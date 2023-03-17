import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/presentation/screens/reconstruction/camera_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../../../configs/size_config.dart';

import '../../../cubits/cubits.dart';
import 'image_gallery_screen.dart';

import 'package:marketplace/data/repositories/gen3d_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<Widget> modelQuality = <Widget>[
  Text('High'),
  Text('Medium'),
  Text('Low')
];

class ReconstructionConfigScreen extends StatefulWidget {
  final List<XFile> imageFiles;
  final List<Map<String,dynamic>?>? cameraParameterList;
  const ReconstructionConfigScreen({Key? key,required this.imageFiles, this.cameraParameterList})
      : super(key: key);

  @override
  _ReconstructionConfigScreenState createState() =>
      _ReconstructionConfigScreenState();
}

class _ReconstructionConfigScreenState
    extends State<ReconstructionConfigScreen> {
  List<XFile>? imageFiles;
  List<Map<String,dynamic>?>? cameraParameterList;

  Map<String, dynamic> reconstructionConfigs = {
    "userId": -888,
    "modelId": -888,
    "objectDetection": false,
    "quality": 'Low',
    "googleARCore":false,
  };
  final List<bool> _selectModelQuality = <bool>[false, false, true];
  final Gen3DModelRepository gen3dModelRepository = Gen3DModelRepository();
  

  bool vertical = false;
  @override
  void initState() {
    super.initState();
    if (widget.imageFiles != null && widget.imageFiles!.isNotEmpty) {
      imageFiles = widget.imageFiles;
    } else {
      imageFiles = [];
  
    }
            if (widget.cameraParameterList != null && widget.cameraParameterList!.isNotEmpty) {
      cameraParameterList = widget.cameraParameterList;
    } else {
      cameraParameterList = [];
    }
    
  }

  _sendRequestToGenerate3DModel() async {
    String zipFilePath = await _zipFiles();
    print(zipFilePath);
    var response = await gen3dModelRepository.gen3DModel(
        zipFilePath, reconstructionConfigs,cameraParameterList);
    return response;
  }

  _zipFiles() async {
    Directory? appDocDirectory = await getApplicationDocumentsDirectory();
    var encoder = ZipFileEncoder();

    String  zipFilePath =
          '${appDocDirectory.path}/${reconstructionConfigs['modelId']}_${reconstructionConfigs['userId']}.zip';


    encoder.create(zipFilePath);

    for (var image in imageFiles!) {
      
      encoder.addFile(File(image.path));
    }

    encoder.close();

    return zipFilePath;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("ตั้งค่าการสร้างโมเดล 3 มิติ",
              style: Theme.of(context).textTheme.headline4),
          leading: BackButton(
              onPressed: () => {
                  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(imageFiles: imageFiles,cameraParameterList:cameraParameterList),
                  ),
                )

              },
            )
          
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: getProportionateScreenHeight(50),
            child: ElevatedButton(
              onPressed: () {
                context
                    .read<StoreModelsCubit>()
                    .addReconstructionModel(imageFiles![0])
                    .then((model) => {
                          if (model != null)
                            {
                              setState(() {
                                reconstructionConfigs['modelId'] =
                                    model.modelId;
                                reconstructionConfigs['userId'] = model.userId;
                              }),
                              _sendRequestToGenerate3DModel(),
                            }
                        });
              },
              child: const Text(
                "สร้างโมเดล 3 มิติ",
              ),
            ),
          ),
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
                        Text("รูปภาพ (${imageFiles!.length})"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ImageGalleryScreen(
                                  imageFiles: imageFiles!,
                                  cameraParameterList:cameraParameterList!,
                                  previousScreen: "rc",
                                ),
                              ),
                            );
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
                Text("คุณภาพของโมเดล 3 มิติ"),
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
                    Text("ระบบตรวจจับเฉพาะวัตถุ"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ระบบ Google ARCore"),
                    Switch(
                      value: reconstructionConfigs["googleARCore"],
                      onChanged: (value) {
                        setState(() {
                          reconstructionConfigs["googleARCore"] = value;
                        });
                      },
                      activeTrackColor: primarySoftColor,
                      activeColor: primaryColor,
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
