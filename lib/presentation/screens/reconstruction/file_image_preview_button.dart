import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileImagePreviewButton extends StatelessWidget {
  final List<XFile> imageFiles;
  const FileImagePreviewButton({super.key, required this.imageFiles});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReconstructionCubit, ReconstructionState>(
        builder: (context, state) {
      return imageFiles.isNotEmpty
          ? Stack(
              children: [
                Container(
                    height: 40,
                    width: 40,
                    color: Colors.grey,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: Image.memory(state.imageMemoryFiles.last,cacheWidth:state.imagesSize.last? 180: 320,
                                  cacheHeight: state.imagesSize.last? 320: 180,),
                    )),
                Container(
                    height: 40,
                    width: 40,
                    color: Colors.grey.withOpacity(0.3),
                    child: Center(
                        child: DefaultTextStyle(
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            child: Text(state.imageMemoryFiles.length.toString())))),
              ],
            )
          : Container(
              height: 40,
              width: 40,
              color: Colors.grey.withOpacity(0),
            );
    });
  }
}
