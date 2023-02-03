import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import './dio_client.dart';
import 'dart:io';

Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      // ignore: avoid_slow_async_io
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    }
  } catch (err, stack) {
    print("Cannot get download folder path");
  }
  return directory?.path;
}

Future<File?> downloadFile(String url, String fileName) async {
  final status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  final appStorageDir = await getDownloadPath();
  final filePath = '$appStorageDir/$fileName';
  final file = File(filePath);
  if (await file.exists()) {
    return file;
  }
  try {
    final response = await DioClient().dio.get(
          url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ),
        );
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  } catch (e) {
    print(e);
    return null;
  }
}

// final file = await downloadFile(
//                     model.model, model.model.split('/').last);
//                 if (file != null) {
//                   await showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: const Text('ดาวน์โหลดสำเร็จ'),
//                           content: Text('ไฟล์ถูกบันทึกไว้ที่ ${file.path}'),
//                           actions: [
//                             TextButton(
//                                 onPressed: () async {
//                                   Navigator.pop(context);
//                                   await FilePicker.platform.pickFiles(
//                                     initialDirectory: file.path,
//                                   );
//                                 },
//                                 child: Text(
//                                   'ไปยังไฟล์',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .headline3!
//                                       .copyWith(
//                                           color:
//                                               Theme.of(context).primaryColor),
//                                 )),
//                             TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text(
//                                   'ปิด',
//                                   style: Theme.of(context).textTheme.headline3,
//                                 ))
//                           ],
//                         );
//                       });
//                 }