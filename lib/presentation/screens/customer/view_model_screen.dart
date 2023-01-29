import 'package:flutter/material.dart';
import 'package:marketplace/data/models/models.dart';
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
    );
  }
}
