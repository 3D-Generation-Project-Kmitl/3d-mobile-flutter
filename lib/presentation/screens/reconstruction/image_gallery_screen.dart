import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';

import 'package:marketplace/routes/screens_routes.dart';

import '../../../configs/size_config.dart';

class ImageGalleryScreen extends StatelessWidget {
  const ImageGalleryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // int imageWidth=SizeConfig.screenWidth~/1;
    // int imageHeight=;
    // print('imageWidth: $imageWidth');
    return BlocBuilder<ReconstructionCubit, ReconstructionState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
                title: Text('${state.imageMemoryFiles.length.toString()} รูป',
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
                              child: Image.memory(state.imageMemoryFiles[index],
                                  cacheWidth:state.imagesSize[index]? 90: 160,
                                  cacheHeight: state.imagesSize[index]? 160: 90, frameBuilder: ((context,
                                      child, frame, wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) return child;
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: frame != null ? child : null,
                                );
                              })),
                            ),
                          );
                        },
                        childCount: state.imageMemoryFiles.length,
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
