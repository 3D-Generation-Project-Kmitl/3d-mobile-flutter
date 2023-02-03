import 'package:flutter/material.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/download.dart';
import '../../../configs/size_config.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:flutter/services.dart';

class ViewModelScreen extends StatefulWidget {
  final Model model;
  const ViewModelScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<ViewModelScreen> createState() => _ViewModelScreenState();
}

class _ViewModelScreenState extends State<ViewModelScreen> {
  bool isLoading = false;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

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
            src: widget.model.model,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: getProportionateScreenHeight(50),
                  child: ElevatedButton(
                      onPressed: !isLoading
                          ? () async {
                              toggleLoading();
                              final file = await downloadFile(
                                  widget.model.model,
                                  widget.model.model.split('/').last);
                              if (file != null) {
                                toggleLoading();
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('ดาวน์โหลดสำเร็จ'),
                                      content: Text(
                                          'ไฟล์ถูกบันทึกไว้ที่ ${file.path}'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'ปิด',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ))
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          : () {},
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('ดาวน์โหลด')),
                ),
              ),
              const SizedBox(width: 15),
              Container(
                height: getProportionateScreenHeight(50),
                width: getProportionateScreenWidth(50),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                ),
                child: IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.model.model))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('คัดลอกลิงค์สำหรับดาวน์โหลดสำเร็จ')));
                    });
                  },
                  icon: Icon(Icons.ios_share,
                      color: Theme.of(context).primaryColor),
                  splashColor: Colors.transparent,
                  splashRadius: 1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
