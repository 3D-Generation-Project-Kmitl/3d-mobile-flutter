import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/configs/theme.dart';
import 'dart:io';
import '../../../configs/size_config.dart';
import 'package:marketplace/presentation/screens/reconstruction/image_gallery_screen.dart';
import 'package:marketplace/presentation/screens/reconstruction/camera_screen.dart';

class ImageViewerScreen extends StatelessWidget {
  final XFile previewImage;
  final List<XFile> imageFiles;
  final Map<String, dynamic>? cameraParameter;
  final List<Map<String, dynamic>?>? cameraParameterList;
  final String previousScreen;

  const ImageViewerScreen(
      {super.key, required this.previewImage,this.cameraParameter, required this.imageFiles,this.cameraParameterList,required this.previousScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(previewImage.name,
              style: Theme.of(context).textTheme.headline4),
          actions: [
            TextButton(
              // style: TextButton.styleFrom(
              //   textStyle: const TextStyle(color: Colors.red,fontSize: 12),
              // ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryScreen(
                      imageFiles: imageFiles,
                      cameraParameterList:cameraParameterList,
                      previousScreen: "iv",
                    ),
                  ),
                );
              },
              child: Text('รูปภาพทั้งหมด',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: primaryColor)),
            )
          ],
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Center(
            child: Image.file(
              File(previewImage.path),
              width: double.infinity,
            ),
          ),
        )),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: getProportionateScreenHeight(50),
            child: ElevatedButton(
              onPressed: () {
                imageFiles.removeWhere((image) => image == previewImage);
                if(cameraParameter!=null){
                  cameraParameterList!.removeWhere((camera)=>camera==cameraParameter);
                }
                if(previousScreen=='ig'){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageGalleryScreen(
                        imageFiles: imageFiles,
                        cameraParameterList:cameraParameterList,
                        previousScreen: "iv",
                      ),
                    ),
                  );
                }else if (previousScreen=='c'){
                    Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CameraScreen(
                        imageFiles: imageFiles,
                        cameraParameterList:cameraParameterList,
                      )
                    ),
                  );
                }

              },
              child: const Text(
                "ลบรูปภาพ",
              ),
            ),
          ),
        ));
  }
}
