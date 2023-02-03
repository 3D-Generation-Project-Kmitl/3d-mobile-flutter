import 'package:flutter/material.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/download.dart';
import '../../../configs/size_config.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';

class ViewModelScreen extends StatelessWidget {
  final Model model;
  const ViewModelScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 50,
        title: Text(
          "โมเดล 3 มิติ",
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: SizeConfig.screenHeight,
          width: double.infinity,
          child: BabylonJSViewer(
            src: model.model,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: getProportionateScreenHeight(50),
          child: ElevatedButton(
              onPressed: () async {
                final file = await downloadFile(
                    model.model, model.model.split('/').last);
                if (file != null) {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('ดาวน์โหลดสำเร็จ'),
                          content: Text('ไฟล์ถูกบันทึกไว้ที่ ${file.path}'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'ปิด',
                                  style: Theme.of(context).textTheme.headline3,
                                ))
                          ],
                        );
                      });
                }
              },
              child: const Text('ดาวน์โหลด')),
        ),
      ),
    );
  }
}
