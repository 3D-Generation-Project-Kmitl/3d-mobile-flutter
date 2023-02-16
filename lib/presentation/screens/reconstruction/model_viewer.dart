import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:flutter/material.dart';
import '../../../configs/size_config.dart';

class ModelViewer extends StatelessWidget {
  // final String modelPath;
  final String response;
  const ModelViewer({
    Key? key,
    // required this.modelPath,
    required this.response,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // String modelURL = 'http://161.246.5.159:443/' + modelPath;
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        resizeToAvoidBottomInset: false,
        // body: SafeArea(
        //     child: Column(children: [
        //   SizedBox(
        //     height: SizeConfig.screenHeight * 0.8,
        //     width: double.infinity,
        //     child: BabylonJSViewer(
        //       src: modelURL,
        //     ),
        //   ),
        // ]))
        body:Center(child:Text(response))
        );
  }
}
