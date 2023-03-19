part of 'reconstruction_cubit.dart';

class ReconstructionState {
  ReconstructionState(
      {this.imageFiles = const [], this.cameraParameterList = const []});

  final List<XFile> imageFiles;
  final List<Map<String, dynamic>> cameraParameterList;

  ReconstructionState copyWith({
    List<XFile>? imageFiles,
    List<Map<String, dynamic>>? cameraParameterList,
  }) {
    return ReconstructionState(
      imageFiles: imageFiles ?? this.imageFiles,
      cameraParameterList: cameraParameterList ?? this.cameraParameterList,
    );
  }
}
