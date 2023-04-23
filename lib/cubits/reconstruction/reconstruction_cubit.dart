import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
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
    if (!cameraController.value.isTakingPicture && cameraController.value.isInitialized) {
    String fileName =
        "${(state.imageCount + 1).toString().padLeft(4, '0')}.jpg";
      XFile image =
          await renameImageFile(await cameraController.takePicture(), fileName);
      addImageFile(image,state.imageCount + 1);
    }
  }

  void addImageFile(XFile imageFile,int imageCount) {
    List<XFile> imageFiles = state.imageFiles;
    List<Uint8List> imageMemoryFiles = state.imageMemoryFiles;
    Uint8List imageMemoryFile=File(imageFile.path).readAsBytesSync();
    
    emit(state.copyWith(imageFiles: [...imageFiles, imageFile],imageMemoryFiles:[...imageMemoryFiles,imageMemoryFile], imageCount: imageCount));
  }

  void removeImageFile(XFile imageFile) {
    List<XFile> imageFiles = state.imageFiles;
    List<Uint8List> imageMemoryFiles = state.imageMemoryFiles;
    Uint8List imageMemoryFile=File(imageFile.path).readAsBytesSync();
    emit(state.copyWith(
        imageFiles:
            imageFiles.where((element) => element != imageFile).toList(),
          imageMemoryFiles:
            imageMemoryFiles.where((element) => element != imageMemoryFile).toList(),));
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
