import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:marketplace/constants/reconstruction.dart';
import 'package:path/path.dart' as path;
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/repositories/repository.dart';

part 'reconstruction_state.dart';

class ReconstructionCubit extends Cubit<ReconstructionState> {
  ReconstructionCubit() : super(ReconstructionState());

  final Gen3DModelRepository gen3dModelRepository = Gen3DModelRepository();

  Future<String> zipFiles(Map<String, dynamic> reconstructionConfigs) async {
    Directory? appDocDirectory = await getApplicationDocumentsDirectory();
    var encoder = ZipFileEncoder();

    String zipFilePath =
        '${appDocDirectory.path}/${reconstructionConfigs['userId']}_${reconstructionConfigs['modelId']}.zip';

    encoder.create(zipFilePath);

    for (var image in state.imageFiles) {
      encoder.addFile(File(image.path));
    }

    encoder.close();

    return zipFilePath;
  }

  Future gen3DModel(Map<String, dynamic> reconstructionConfigs) async {
    String zipFilePath = await zipFiles(reconstructionConfigs);
    var response = await gen3dModelRepository.gen3DModel(
        zipFilePath, reconstructionConfigs, state.cameraParameterList);
    clear();
    return response;
  }

  void clear() {
    emit(ReconstructionState());
  }

  void takePicture(CameraController cameraController) async {
    if (!cameraController.value.isTakingPicture) {
    String fileName =
        "${(state.imageFiles.length + 1).toString().padLeft(4, '0')}.jpg";
      XFile image =
          await renameImageFile(await cameraController.takePicture(), fileName);
      addImageFile(image);
    }
  }

  void addImageFile(XFile imageFile) {
    List<XFile> imageFiles = state.imageFiles;
    emit(state.copyWith(imageFiles: [...imageFiles, imageFile]));
  }

  void removeImageFile(XFile imageFile) {
    List<XFile> imageFiles = state.imageFiles;
    emit(state.copyWith(
        imageFiles:
            imageFiles.where((element) => element != imageFile).toList()));
  }

  Future<XFile> renameImageFile(XFile imageXFile, String fileName) async {
    File imageFile = File(imageXFile.path);
    String dir = path.dirname(imageFile.path);
    String newPath = path.join(dir, fileName);
    imageFile = imageFile.renameSync(newPath);
    return XFile(imageFile.path);
  }

  List<List<double>> decodeDoubleArray(List<double> cameraPose) {
    List<List<double>> cameraPose2DArray =
        List.generate(4, (i) => List.generate(4, (j) => 0.00));
    for (var i = 0; i < cameraPose.length; i++) {
      cameraPose2DArray[i % 4][i ~/ 4] = cameraPose[i];
    }

    return cameraPose2DArray;
  }
}
