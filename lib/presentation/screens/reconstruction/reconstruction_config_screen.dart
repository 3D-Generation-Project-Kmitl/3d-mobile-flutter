import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'image_gallery_screen.dart';

enum ModelQuality { HIGH, MEDIUM, LOW }

const List<Widget> modelQuality = <Widget>[
  Text('High'),
  Text('Medium'),
  Text('Low')
];

class ReconstructionConfigScreen extends StatefulWidget {
  final List<XFile>? imageFiles;
  const ReconstructionConfigScreen({Key? key, this.imageFiles})
      : super(key: key);

  @override
  _ReconstructionConfigScreenState createState() =>
      _ReconstructionConfigScreenState();
}

class _ReconstructionConfigScreenState
    extends State<ReconstructionConfigScreen> {
  List<XFile>? imageFiles;
  Map<String, dynamic> configs = {
    "removeBackground": false,
    "quality": ModelQuality.LOW
  };
  final List<bool> _selectedFruits = <bool>[true, false, false];
  final List<bool> _selectedVegetables = <bool>[false, true, false];
  final List<bool> _selectedWeather = <bool>[false, false, true];
  bool vertical = false;
  @override
  void initState() {
    super.initState();
    if (widget.imageFiles != null && widget.imageFiles!.isNotEmpty) {
      imageFiles = widget.imageFiles;
    } else {
      imageFiles = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: DefaultTextStyle(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              child: Text('ตั้งค่าการสร้างโมเดล 3 มิติ')),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("รูปภาพ (${imageFiles!.length})"),
                          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(color: Colors.red,fontSize: 12),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ImageGalleryScreen(
                    imageFiles: imageFiles!,
                  ),
                ),
              );
            },
            child: const Text('รูปภาพทั้งหมด'),
          ),
                Text("คุณภาพของโมเดล 3 มิติ"),
                ToggleButtons(
                  direction: vertical ? Axis.vertical : Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {
                      // The button that is tapped is set to true, and the others to false.
                      for (int i = 0; i < _selectedFruits.length; i++) {
                        _selectedFruits[i] = i == index;
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.red[700],
                  selectedColor: Colors.white,
                  fillColor: Colors.red[200],
                  color: Colors.red[400],
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedFruits,
                  children: modelQuality,
                ),
                Text("ต้องการลบภาพพื้นหลังหรือไม่"),
                Switch(
            value: configs["removeBackground"],
            onChanged: (value) {
              setState(() {
                configs["removeBackground"] = value;
                print(configs["removeBackground"]);
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          )
              ],
            ),
          ),
        ));
  }
}
