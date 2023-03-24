import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';
import '../../../cubits/cubits.dart';
import '../../../routes/screens_routes.dart';

class SearchScreen extends StatefulWidget {
  final String keyword;
  const SearchScreen({Key? key, this.keyword = ''}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController keywordController;
  late List<String> filteredKeywords;
  late List<String> keywords;

  @override
  void initState() {
    keywordController = TextEditingController(text: widget.keyword);
    final productNames = context.read<ProductsCubit>().getProductNames();
    final categoryNames = context.read<CategoryCubit>().getCategoriesNames();
    keywords = [...categoryNames, ...productNames];
    filteredKeywords =
        keywords.where((element) => element.contains(widget.keyword)).toList();
    super.initState();
  }

  @override
  void dispose() {
    keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 35,
        title: SizedBox(height: 42, child: buildSearchField()),
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: filteredKeywords.length,
          itemBuilder: (context, index) {
            String keyword = filteredKeywords[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, searchResultRoute,
                      arguments: keyword);
                },
                child: Text(
                  keyword,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      ),
    );
  }

  Widget buildSearchField() {
    return TextField(
      controller: keywordController,
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        Navigator.pushNamed(context, searchResultRoute, arguments: value);
      },
      onChanged: (value) {
        setState(() {
          filteredKeywords =
              keywords.where((element) => element.contains(value)).toList();
        });
      },
      autofocus: true,
      decoration: const InputDecoration(
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
