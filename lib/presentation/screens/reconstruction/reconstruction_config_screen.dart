import 'package:archive/archive_io.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:marketplace/constants/colors.dart';
import 'package:path_provider/path_provider.dart';
import '../../../configs/size_config.dart';

import '../../../cubits/cubits.dart';
import 'image_gallery_screen.dart';
import 'package:marketplace/routes/screens_routes.dart';
import 'package:marketplace/data/repositories/gen3d_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<Widget> modelQuality = <Widget>[
  Text('High'),
  Text('Medium'),
  Text('Low')
];

class ReconstructionConfigScreen extends StatefulWidget {
  final List<XFile>? imageFiles;
  const ReconstructionConfigScreen({Key? key, this.imageFiles})
      : super(key: key);

  @override
  _ReconstructionConfigScreenState createState() =>
      _ReconstructionConfigScreenState();
}

class _ReconstructionConfigScreenState
    extends State<ReconstructionConfigScreen> {
  List<XFile>? imageFiles;
  Map<String, dynamic> configs = {"removeBackground": false, "quality": 'Low'};
  final List<bool> _selectModelQuality = <bool>[false, false, true];
  final Gen3DModelRepository gen3dModelRepository = Gen3DModelRepository();
  String zipFilePath = "";

  bool vertical = false;
  @override
  void initState() {
    super.initState();
    if (widget.imageFiles != null && widget.imageFiles!.isNotEmpty) {
      imageFiles = widget.imageFiles;
    } else {
      imageFiles = [];
    }
  }

  _sendRequestToGenerate3DModel(int modelId, int userId) async {
    await _zipFiles(modelId, userId);
    var response = await gen3dModelRepository.gen3DModel(
        zipFilePath, configs, modelId, userId);
    print(response);
    return response;
  }

  _zipFiles(int modelId, int userId) async {
    Directory? appDocDirectory = await getExternalStorageDirectory();
    var encoder = ZipFileEncoder();
    zipFilePath = appDocDirectory!.path +
        '/' +
        modelId.toString() +
        '_' +
        userId.toString() +
        '.zip';
    encoder.create(zipFilePath);

    for (var image in imageFiles!) {
      encoder.addFile(File(image.path));
    }

    encoder.close();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("ตั้งค่าการสร้างโมเดล 3 มิติ",
              style: Theme.of(context).textTheme.headline4),
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
                              _sendRequestToGenerate3DModel(
                                  model.modelId, model.userId)
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
                            configs['quality'] = quality.data;
                          } else {
                            _selectModelQuality[i] = false;
                          }
                        }
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Colors.white,
                    selectedColor: Colors.white,
                    fillColor: primaryLight,
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
                      value: configs["removeBackground"],
                      onChanged: (value) {
                        setState(() {
                          configs["removeBackground"] = value;
                        });
                      },
                      activeTrackColor: primaryLight,
                      activeColor: primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
