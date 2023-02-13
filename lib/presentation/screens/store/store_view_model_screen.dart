import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import '../../../configs/size_config.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';

import '../../../data/models/models.dart';

class StoreViewModelScreen extends StatefulWidget {
  final Model model;
  const StoreViewModelScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<StoreViewModelScreen> createState() => _StoreViewModelScreenState();
}

class _StoreViewModelScreenState extends State<StoreViewModelScreen> {
  File? imgFile;
  bool isLoading = false;

  @override
  void initState() {
    Permission.storage.request();
    super.initState();
  }

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<File> saveImage() async {
    final ScreenshotController screenshotController = ScreenshotController();
    final img = await screenshotController.captureFromWidget(previewImage());
    final directory = await getApplicationDocumentsDirectory();
    final file = await File('${directory.path}/image.png').create();
    await file.writeAsBytes(img);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 50,
        title: Text(
          "โมเดล 3 มิติ",
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: SafeArea(
        child: buildModelViewer(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: getProportionateScreenHeight(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SizeConfig.screenWidth * 0.45,
                height: getProportionateScreenHeight(50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    //outline
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  onPressed: () async {
                    if (isLoading == false) {
                      toggleLoading();
                      String? path = await NativeScreenshot.takeScreenshot();
                      if (path != null) {
                        setState(() {
                          imgFile = File(path);
                        });
                      } else {
                        print("Error");
                      }
                      toggleLoading();
                      imageDialog();
                    }
                  },
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : Text("บันทึกภาพ",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: SizeConfig.screenWidth * 0.45,
                height: getProportionateScreenHeight(50),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("ลงขาย"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildModelViewer() {
    return SizedBox(
      height: SizeConfig.screenHeight,
      width: double.infinity,
      child: BabylonJSViewer(
        src: widget.model.model,
      ),
    );
  }

  Widget previewImage() {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Image.file(
        imgFile!,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> imageDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการเปลี่ยนรูปภาพ'),
          content: previewImage(),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'ยกเลิก',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<ModelsCubit>()
                    .updateModel(imgFile!, widget.model.modelId)
                    .then((value) => {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("บันทึกภาพสำเร็จ"),
                            ),
                          ),
                          Navigator.of(context).pop(),
                        });
              },
              child: Text(
                'ยืนยัน',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
