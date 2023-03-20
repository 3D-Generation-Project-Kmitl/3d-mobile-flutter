import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class SearchScreen extends StatelessWidget {
  final String keyword;
  const SearchScreen({Key? key, this.keyword = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leadingWidth: 35,
          title: SizedBox(
            height: 42,
            child: SearchField(keyword: keyword),
          ),
        ),
        body: const SafeArea(child: SingleChildScrollView()));
  }
}
