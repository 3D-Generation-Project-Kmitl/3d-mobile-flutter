import 'dart:io';

import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/presentation/widgets/widgets.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:native_screenshot/native_screenshot.dart';

import '../../../configs/size_config.dart';
import '../../../constants/constants.dart';
import '../../../data/models/models.dart';
import '../../../utils/resizeImage.dart';
import '../../helpers/helpers.dart';
import '../../../cubits/cubits.dart';

class StoreEditProductScreen extends StatefulWidget {
  final Product product;
  const StoreEditProductScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<StoreEditProductScreen> createState() => _StoreEditProductScreenState();
}

class _StoreEditProductScreenState extends State<StoreEditProductScreen> {
  late TextEditingController _nameController;
  late CurrencyTextInputFormatter _priceFormatter;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  int? _category;
  File? imgFile;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _priceFormatter = CurrencyTextInputFormatter(
        locale: 'th', symbol: '฿', decimalDigits: 0, enableNegative: false);
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();

    _nameController.text = widget.product.name;
    _priceController.text = _priceFormatter.format('${widget.product.price}');
    _descriptionController.text = widget.product.details;
    _category = widget.product.category!.categoryId;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  bool isChanged() {
    return _nameController.text != widget.product.name ||
        _priceController.text !=
            _priceFormatter.format('${widget.product.price}') ||
        _descriptionController.text != widget.product.details ||
        _category != widget.product.category!.categoryId ||
        imgFile != null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text("แก้ไขข้อมูลสินค้า",
            style: Theme.of(context).textTheme.headline2),
      ),
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
                  child: Column(
                    children: [
                      imgFile == null
                          ? roundedImageCard(
                              imageURL: widget.product.model.picture,
                              ratio: 0.9)
                          : roundedImageCard(imageFile: imgFile, ratio: 0.9),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      buildEditIcon(),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                buildNameFormField(),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                buildPriceFormField(),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Text(
                  " ราคาสินค้าขั้นต่ำ $minProductPrice บาท",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
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
            onPressed: isChanged()
                ? () {
                    if (_keyForm.currentState!.validate()) {
                      context
                          .read<MyStoreProductCubit>()
                          .updateProduct(
                            productId: widget.product.productId,
                            name: _nameController.text,
                            price: int.parse(_priceController.text
                                .replaceAll(RegExp(r'[^0-9]'), '')),
                            details: _descriptionController.text,
                            categoryId: _category!,
                            modelId: widget.product.model.modelId,
                            file: imgFile,
                          )
                          .then(
                            (value) => {
                              Navigator.pop(context),
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("บันทึกสำเร็จ"),
                                ),
                              ),
                            },
                          );
                    }
                  }
                : null,
            child: const Text("บันทึก"),
          ),
        ),
      ),
    );
  }

  Future<void> imageDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('รูปภาพ'),
          content: AspectRatio(
            aspectRatio: 0.8,
            child: Image.file(
              imgFile!,
              fit: BoxFit.cover,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                deleteFile(imgFile!);
                setState(() {
                  imgFile = null;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'ยกเลิก',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'ยืนยัน',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> buildModelViewer() {
    return showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 20,
              title: Text("แก้ไขรูปภาพ",
                  style: Theme.of(context).textTheme.headline2),
            ),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: SizedBox(
                height: SizeConfig.screenHeight,
                width: double.infinity,
                child: BabylonJSViewer(
                  src: widget.product.model.model!,
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: getProportionateScreenHeight(50),
                child: ElevatedButton(
                  onPressed: () async {
                    String? path = await NativeScreenshot.takeScreenshot();
                    if (path != null) {
                      File resizedFile = await resizeImageFromPath(path);
                      setState(() {
                        imgFile = resizedFile;
                        imageDialog();
                      });
                    }
                  },
                  child: const Text("บันทึกภาพ"),
                ),
              ),
            ),
          );
        });
  }

  Widget buildEditIcon() {
    return SizedBox(
      height: getProportionateScreenHeight(40),
      child: ElevatedButton(
        onPressed: () {
          buildModelViewer();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          //outline
          side: const BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: Row(
          children: const [
            Icon(Icons.image, color: Colors.grey),
            SizedBox(width: 5),
            Text("แก้ไขรูปภาพ", style: TextStyle(color: Colors.grey)),
          ],
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
      validator: (value) {
        if (value!.isEmpty) {
          return "กรุณากรอกราคาสินค้า";
        } else {
          int amount = int.parse(value.replaceAll(RegExp(r'[^0-9]'), ''));
          if (amount < minProductPrice) {
            return "ราคาสินค้าต้องมากกว่า $minProductPrice บาท";
          }
        }
        return null;
      },
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
