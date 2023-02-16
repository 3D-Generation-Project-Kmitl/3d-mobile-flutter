import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/presentation/widgets/widgets.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:marketplace/routes/screens_routes.dart';

import '../../../configs/size_config.dart';
import '../../../data/models/models.dart';
import '../../helpers/helpers.dart';
import '../../../cubits/cubits.dart';

class StoreAddProductScreen extends StatefulWidget {
  final Model model;
  const StoreAddProductScreen({Key? key, required this.model})
      : super(key: key);

  @override
  State<StoreAddProductScreen> createState() => _StoreAddProductScreenState();
}

class _StoreAddProductScreenState extends State<StoreAddProductScreen> {
  late TextEditingController _nameController;
  late CurrencyTextInputFormatter _priceFormatter;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  int? _category;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _priceFormatter =
        CurrencyTextInputFormatter(locale: 'th', symbol: '฿', decimalDigits: 0);
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title:
            Text("เพิ่มสินค้า", style: Theme.of(context).textTheme.headline2),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Form(
            key: _keyForm,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: SizeConfig.screenWidth * 0.23),
                  child: roundedImageCard(
                      imageURL: widget.model.picture, ratio: 0.9),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                buildNameFormField(),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                buildPriceFormField(),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                buildCategoriesFormField(),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                buildDescriptionFormField(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: getProportionateScreenHeight(50),
          child: ElevatedButton(
            onPressed: () {
              if (_keyForm.currentState!.validate()) {
                context
                    .read<MyStoreProductCubit>()
                    .addProductToStore(
                      name: _nameController.text,
                      price: int.parse(_priceController.text
                          .replaceAll(RegExp(r'[^0-9]'), '')),
                      details: _descriptionController.text,
                      categoryId: _category!,
                      modelId: widget.model.modelId,
                    )
                    .then((value) => {
                          context
                              .read<StoreModelsCubit>()
                              .removeModel(widget.model.modelId),
                          Navigator.pop(context),
                          Navigator.pop(context),
                          Navigator.pushNamed(context, storeProductRoute),
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("ลงขายสินค้าสำเร็จ"),
                            ),
                          ),
                        });
              }
            },
            child: const Text("ลงขาย"),
          ),
        ),
      ),
    );
  }

  Widget buildNameFormField() {
    return TextFormField(
      controller: _nameController,
      validator: productNameValidator,
      keyboardType: TextInputType.name,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "ชื่อสินค้า",
      ),
    );
  }

  Widget buildPriceFormField() {
    return TextFormField(
      controller: _priceController,
      inputFormatters: [_priceFormatter],
      validator: productPriceValidator,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "ราคา",
      ),
    );
  }

  Widget buildCategoriesFormField() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          return DropdownWidgetQ(
            isValidate: true,
            label: "หมวดหมู่สินค้า",
            hint: "เลือกหมวดหมู่สินค้า",
            customItems: state.categories.map<DropdownMenuItem>(
              (item) {
                return DropdownMenuItem(
                  value: item.categoryId,
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                _category = value;
              });
            },
            value: _category,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildDescriptionFormField() {
    return TextFormField(
      controller: _descriptionController,
      validator: productDescriptionValidator,
      keyboardType: TextInputType.name,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "รายละเอียด",
      ),
      minLines: 3,
      maxLines: 5,
    );
  }
}
