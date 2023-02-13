import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/presentation/widgets/widgets.dart';
import 'package:marketplace/routes/screens_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../configs/size_config.dart';
import '../../../constants/constants.dart';
import '../../helpers/helpers.dart';

class StoreModelScreen extends StatelessWidget {
  const StoreModelScreen({Key? key}) : super(key: key);

  Future<PlatformFile?> getFileFromStorage(BuildContext context) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      PlatformFile file = result.files.first;
      if (modelFileExtensions.contains(file.extension)) {
        return file;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenWidth;
    return BlocBuilder<StoreModelsCubit, StoreModelsState>(
      builder: (context, state) {
        if (state is StoreModelsInitial) {
          context.read<StoreModelsCubit>().getModelsStore();
          return Scaffold(
              appBar: AppBar(
                titleSpacing: 20,
                title: Text("โมเดล 3 มิติของฉัน",
                    style: Theme.of(context).textTheme.headline2),
              ),
              resizeToAvoidBottomInset: false,
              body: const SafeArea(
                  child: Center(
                child: CircularProgressIndicator(),
              )));
        } else if (state is StoreModelsLoaded) {
          return Scaffold(
              appBar: AppBar(
                titleSpacing: 20,
                title: Text("โมเดล 3 มิติของฉัน",
                    style: Theme.of(context).textTheme.headline2),
              ),
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: SafeArea(
                  child: state.models.isEmpty
                      ? Center(
                          child: Text(
                            'ไม่มีโมเดล 3 มิติ',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        )
                      : _modelList(state.models, width),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: SizedBox(
                  height: getProportionateScreenHeight(50),
                  child: ElevatedButton(
                    onPressed: () {
                      getFileFromStorage(context).then((file) => {
                            if (file != null)
                              {
                                if (file.size > 100000000)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('ขนาดไฟล์ต้องไม่เกิน 100 MB'),
                                      ),
                                    ),
                                  }
                                else
                                  {
                                    showConfirmDialog(
                                      context,
                                      title:
                                          'คุณต้องการเพิ่มโมเดล 3 มิตินี้ใช่หรือไม่',
                                      message:
                                          'ชื่อไฟล์: ${file.name}\nขนาด: ${(file.size / 1000000).toStringAsFixed(2)} MB',
                                      onConfirm: () => context
                                          .read<StoreModelsCubit>()
                                          .addModel(file),
                                    ),
                                  }
                              }
                            else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('กรุณาเลือกไฟล์ให้ถูกต้อง'),
                                  ),
                                ),
                              }
                          });
                    },
                    child: const Text(
                      "เพิ่มโมเดล 3 มิติ",
                    ),
                  ),
                ),
              ));
        } else {
          return Scaffold(
              appBar: AppBar(
                titleSpacing: 20,
                title: Text("โมเดล 3 มิติของฉัน",
                    style: Theme.of(context).textTheme.headline2),
              ),
              resizeToAvoidBottomInset: false,
              body: const SafeArea(
                  child: Center(
                child: CircularProgressIndicator(),
              )));
        }
      },
    );
  }

  Widget _modelList(List<Model> models, double width) {
    return GridView.builder(
      itemCount: models.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 14,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final model = models[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              storeViewModelRoute,
              arguments: model,
            );
          },
          child: roundedImageCard(
            imageURL: model.picture,
          ),
        );
      },
    );
  }
}
