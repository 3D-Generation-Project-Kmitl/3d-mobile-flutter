import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TextField(
      textInputAction: TextInputAction.search,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'ค้นหาสินค้า',
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: outlineColor,
        contentPadding: EdgeInsets.all(8),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
