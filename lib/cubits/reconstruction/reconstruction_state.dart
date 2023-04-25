part of 'reconstruction_cubit.dart';

class ReconstructionState {
  ReconstructionState(
      {this.imageFiles = const [], this.cameraParameterList = const [],this.imageMemoryFiles=const[],  this.imageCount=0,this.imagesSize=const[]});

  final List<XFile> imageFiles;
  final List<Uint8List> imageMemoryFiles;
  final List<Map<String, dynamic>> cameraParameterList;
  final int imageCount;

  final List<bool> imagesSize;

  ReconstructionState copyWith({
    List<XFile>? imageFiles,
    List<Map<String, dynamic>>? cameraParameterList,
    List<Uint8List>? imageMemoryFiles,
    int? imageCount,
    List<bool>? imagesSize,
    
  }) {
    return ReconstructionState(
      imageFiles: imageFiles ?? this.imageFiles,
      cameraParameterList: cameraParameterList ?? this.cameraParameterList,
      imageMemoryFiles: imageMemoryFiles ?? this.imageMemoryFiles,
      imageCount: imageCount ?? this.imageCount,
      imagesSize: imagesSize ?? this.imagesSize,
    );
  }
}


