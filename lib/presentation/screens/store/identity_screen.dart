import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/constants/constants.dart';
import 'package:image_picker/image_picker.dart';

import '../../../configs/size_config.dart';
import '../../../cubits/cubits.dart';
import '../../helpers/helpers.dart';
import '../../widgets/widgets.dart';

class IdentityScreen extends StatefulWidget {
  const IdentityScreen({Key? key}) : super(key: key);

  @override
  State<IdentityScreen> createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _idCardController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _bankNameController;
  late TextEditingController _bankAccountController;
  bool isReSend = false;
  XFile? cardPicture;
  XFile? cardFacePicture;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _idCardController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _bankNameController = TextEditingController();
    _bankAccountController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.clear();
    _firstNameController.dispose();
    _lastNameController.clear();
    _lastNameController.dispose();
    _idCardController.clear();
    _idCardController.dispose();
    _phoneNumberController.clear();
    _phoneNumberController.dispose();
    _bankNameController.clear();
    _bankNameController.dispose();
    _bankAccountController.clear();
    _bankAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text("ลงทะเบียนร้านค้า",
            style: Theme.of(context).textTheme.headline2),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: BlocBuilder<IdentityCubit, IdentityState>(
            builder: (context, state) {
              if (state is IdentityLoaded) {
                final identity = state.identity;
                if (identity?.status == "PENDING") {
                  return Center(
                    child: Text(
                      "รอการตรวจสอบ",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  );
                } else if (identity?.status == "REJECTED" && !isReSend) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ไม่ผ่านการตรวจสอบ",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        Text(
                          "เนื่องจาก: ${identity?.issue}",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.04),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.5,
                          height: getProportionateScreenHeight(50),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isReSend = true;
                              });
                            },
                            child: Text("ส่งใหม่"),
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                      ],
                    ),
                  );
                }
                return Form(
                  key: _keyForm,
                  child: ListView(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      buildIdCardFormField(),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      buildFirstNameFormField(),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      buildLastNameFormField(),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      buildPhoneNumberFormField(),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      buildBankNameFormField(),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      buildBankAccountFormField(),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      buildPictureForm(
                        title: "รูปบัตรประชาชน",
                        photo: cardPicture,
                        onTap: () {
                          final picker = ImagePicker();
                          picker.pickImage(source: ImageSource.camera).then(
                            (value) {
                              setState(() {
                                cardPicture = value;
                              });
                            },
                          );
                        },
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      buildPictureForm(
                        title: "รูปบัตรประชาชนพร้อมใบหน้า",
                        photo: cardFacePicture,
                        onTap: () {
                          final picker = ImagePicker();
                          picker.pickImage(source: ImageSource.camera).then(
                            (value) {
                              setState(() {
                                cardFacePicture = value;
                              });
                            },
                          );
                        },
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      SizedBox(
                        width: double.infinity,
                        height: getProportionateScreenHeight(50),
                        child: ElevatedButton(
                          onPressed: () {
                            if (cardPicture == null ||
                                cardFacePicture == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("กรุณาใส่รูปภาพ"),
                                ),
                              );
                              return;
                            }
                            if (_keyForm.currentState!.validate()) {
                              if (state.identity == null) {
                                context.read<IdentityCubit>().createIdentity(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      idCardNumber: _idCardController.text,
                                      phone: _phoneNumberController.text,
                                      bankName: _bankNameController.text,
                                      bankAccount: _bankAccountController.text,
                                      cardPicture: cardPicture!,
                                      cardFacePicture: cardFacePicture!,
                                    );
                              } else {
                                context.read<IdentityCubit>().updateIdentity(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      idCardNumber: _idCardController.text,
                                      phone: _phoneNumberController.text,
                                      bankName: _bankNameController.text,
                                      bankAccount: _bankAccountController.text,
                                      cardPicture: cardPicture!,
                                      cardFacePicture: cardFacePicture!,
                                    );
                              }
                            }
                          },
                          child: const Text("ยืนยัน"),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildFirstNameFormField() {
    return TextFormField(
      controller: _firstNameController,
      validator: nameValidator,
      keyboardType: TextInputType.name,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "ชื่อ",
      ),
    );
  }

  Widget buildLastNameFormField() {
    return TextFormField(
      controller: _lastNameController,
      validator: surnameValidator,
      keyboardType: TextInputType.name,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "นามสกุล",
      ),
    );
  }

  Widget buildIdCardFormField() {
    return TextFormField(
      controller: _idCardController,
      validator: idCardValidator,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "เลขบัตรประชาชน",
      ),
    );
  }

  Widget buildPhoneNumberFormField() {
    return TextFormField(
      controller: _phoneNumberController,
      validator: phoneNumberValidator,
      keyboardType: TextInputType.phone,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "เบอร์โทรศัพท์",
      ),
    );
  }

  Widget buildBankNameFormField() {
    return DropdownWidgetQ(
      isValidate: true,
      label: "ธนาคาร",
      hint: "เลือกธนาคาร",
      items: banks,
      onChanged: (value) {
        setState(() {
          _bankNameController.text = value;
        });
      },
      value: _bankNameController.text,
    );
  }

  Widget buildBankAccountFormField() {
    return TextFormField(
      controller: _bankAccountController,
      validator: bankAccountValidator,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "เลขบัญชีธนาคาร",
      ),
    );
  }

  Future getImageFromCamera() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.camera);
    return photo;
  }

  Widget buildPictureForm(
      {required String title,
      required void Function()? onTap,
      required XFile? photo}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
          child: photo != null
              ? Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              : const SizedBox(),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: outlineColor),
              borderRadius: const BorderRadius.all(Radius.circular(
                      10.0) //                 <--- border radius here
                  ),
            ),
            height: 200,
            child: photo == null
                ? Center(
                    child: Text("กดเพื่อถ่าย$title"),
                  )
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Image.file(
                      File(photo.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
