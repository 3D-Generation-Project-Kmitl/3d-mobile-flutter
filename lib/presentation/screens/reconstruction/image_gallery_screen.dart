import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'dart:io';

import 'package:marketplace/routes/screens_routes.dart';

class ImageGalleryScreen extends StatelessWidget {
  const ImageGalleryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReconstructionCubit, ReconstructionState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
                title: Text('${state.imageFiles.length.toString()} รูป',
                    style: Theme.of(context).textTheme.headline4),
                leading: BackButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                  },
                )),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 10, 15),
                child: CustomScrollView(
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 5,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                            onTap: () => {
                              Navigator.pushNamed(
                                  context, reconImagePreviewRoute,
                                  arguments: [state.imageFiles[index], false])
                            },
                            child: FittedBox(
                              fit: BoxFit.cover,
                              clipBehavior: Clip.hardEdge,
                              child: Image.file(
                                  File(state.imageFiles[index].path)),
                            ),
                          );
                        },
                        childCount: state.imageFiles.length,
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
