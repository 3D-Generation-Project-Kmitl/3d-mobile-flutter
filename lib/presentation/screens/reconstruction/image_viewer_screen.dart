// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:marketplace/constants/colors.dart';
// import 'package:marketplace/cubits/cubits.dart';
// import 'package:marketplace/routes/screens_routes.dart';
// import 'dart:io';
// import '../../../configs/size_config.dart';

// class ImageViewerScreen extends StatelessWidget {
//   final XFile previewImage;
//   final bool isShowAll;

//   const ImageViewerScreen(
//       {super.key, required this.previewImage, required this.isShowAll});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReconstructionCubit, ReconstructionState>(
//       builder: (context, state) {
//         return Scaffold(
//             appBar: AppBar(
//               title: Text(previewImage.name,
//                   style: Theme.of(context).textTheme.headline4),
//               actions: !isShowAll
//                   ? null
//                   : [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacementNamed(context, reconGalleryRoute);
//                         },
//                         child: Text('รูปภาพทั้งหมด',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyText2!
//                                 .copyWith(color: primaryColor)),
//                       )
//                     ],
//             ),
//             body: SafeArea(
//                 child: Padding(
//               padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//               child: Center(
//                 child: Image.file(
//                   File(previewImage.path),
//                   width: double.infinity,
//                 ),
//               ),
//             )),
//             bottomNavigationBar: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: SizedBox(
//                 height: getProportionateScreenHeight(50),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     context
//                         .read<ReconstructionCubit>()
//                         .removeImageFile(previewImage);
//                     Navigator.pop(context);
//                   },
//                   child: const Text(
//                     "ลบรูปภาพ",
//                   ),
//                 ),
//               ),
//             ));
//       },
//     );
//   }
// }
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/routes/screens_routes.dart';
import 'dart:io';
import '../../../configs/size_config.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewerScreen extends StatefulWidget {
  XFile? previewImage;
  final bool isShowAll;

  ImageViewerScreen(
      {super.key,
      this.previewImage,
      required this.isShowAll});
  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreen();
}

class _ImageViewerScreen extends State<ImageViewerScreen> {
  PageController? pageController;
  int? imageIndex;
  onPageChanged(int index) {
    setState(() {
    imageIndex=index;
    ReconstructionState state;
    state=context.read<ReconstructionCubit>().state;
    widget.previewImage=state.imageFiles[index];
    });
  }
  @override
  void initState() {
    super.initState();
    ReconstructionState state;
    state=context.read<ReconstructionCubit>().state;
    imageIndex = state.imageFiles.indexOf(widget.previewImage!);

    pageController=PageController(initialPage: imageIndex!);
    setState(() {
      imageIndex = imageIndex;
      
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReconstructionCubit, ReconstructionState>(
      builder: (context, state) {
        
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.previewImage!.name,
                  style: Theme.of(context).textTheme.headline4),
              actions: !widget.isShowAll
                  ? null
                  : [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, reconGalleryRoute);
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
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider:
                          MemoryImage(state.imageMemoryFiles[index]),
                      initialScale: PhotoViewComputedScale.contained * 1,
                      minScale: PhotoViewComputedScale.contained * 1,
                      maxScale: PhotoViewComputedScale.covered * 16,
                      heroAttributes: PhotoViewHeroAttributes(
                          tag: state.imageFiles[index].name),
                    );
                  },
                  itemCount: state.imageFiles.length,
                  loadingBuilder: (context, progress) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: progress == null
                            ? null
                            : progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!,
                        strokeWidth:2,
                      ),
                    ),
                  ),
                  backgroundDecoration: const BoxDecoration(
                    color: Color.fromARGB(255, 241, 241, 241),
                  ),
                  pageController: pageController,
                  onPageChanged: onPageChanged,
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
                        .removeImageFile(widget.previewImage!);
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
