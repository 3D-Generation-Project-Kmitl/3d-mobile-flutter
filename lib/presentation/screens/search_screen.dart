import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leadingWidth: 35,
          title: const SizedBox(
            height: 42,
            child: SearchField(),
          ),
        ),
        body: SafeArea(child: SingleChildScrollView()));
  }
}
