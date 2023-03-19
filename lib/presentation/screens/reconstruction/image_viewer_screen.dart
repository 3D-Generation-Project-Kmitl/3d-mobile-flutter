import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/routes/screens_routes.dart';
import 'dart:io';
import '../../../configs/size_config.dart';

class ImageViewerScreen extends StatelessWidget {
  final XFile previewImage;
  final bool isShowAll;

  const ImageViewerScreen(
      {super.key, required this.previewImage, required this.isShowAll});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReconstructionCubit, ReconstructionState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(previewImage.name,
                  style: Theme.of(context).textTheme.headline4),
              actions: !isShowAll
                  ? null
                  : [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, reconGalleryRoute);
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
                    context
                        .read<ReconstructionCubit>()
                        .removeImageFile(previewImage);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ลบรูปภาพ",
                  ),
                ),
              ),
            ));
      },
    );
  }
}
