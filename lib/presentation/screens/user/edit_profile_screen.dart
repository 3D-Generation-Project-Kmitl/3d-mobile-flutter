import 'package:flutter/material.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/presentation/widgets/widgets.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../configs/size_config.dart';
import '../../helpers/helpers.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> genders = <String>["ชาย", "หญิง", "ไม่ระบุ"];
  late User user;
  late TextEditingController _nameController;
  late String? gender;
  late TextEditingController _dateOfBirthController;
  late String picture;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    final userCubit = context.read<UserCubit>();
    user = (userCubit.state as UserLoaded).user;
    picture = user.picture ?? "";
    gender = user.gender;
    _nameController.text = user.name;
    if (user.dateOfBirth != null) {
      _dateOfBirthController.text =
          DateFormat('yyyy-MM-dd').format(user.dateOfBirth!);
    } else {
      _dateOfBirthController.text = "";
    }
  }

  @override
  void dispose() {
    _nameController.clear();
    _nameController.dispose();
    super.dispose();
  }

  void onSubmit() {
    context.read<UserCubit>().updateUser(
          userId: user.userId,
          name: _nameController.text,
          gender: gender,
          dateOfBirth: _dateOfBirthController.text,
        );
  }

  bool isChanged() {
    return context.read<UserCubit>().isChanged(
          name: _nameController.text,
          gender: gender,
          dateOfBirth: _dateOfBirthController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text("แก้ไขโปรไฟล์ผู้ใช้",
            style: Theme.of(context).textTheme.headline2),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
        child: Form(
          key: _keyForm,
          child: Column(
            children: [
              Center(
                  child: GestureDetector(
                onTap: () {},
                child: Stack(
                  children: [
                    ImageCard(
                      imageURL: picture,
                      radius: 50,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: buildEditIcon(Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              )),
              SizedBox(height: SizeConfig.screenHeight * 0.03),
              buildNameFormField(),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              DropdownWidgetQ(
                items: genders,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
                hint: gender ?? "ไม่ระบุ",
                value: gender ?? "ไม่ระบุ",
                label: "เพศ",
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              buildDateOfBirthFormField(),
            ],
          ),
        ),
      )),
      bottomNavigationBar: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: getProportionateScreenHeight(50),
              child: ElevatedButton(
                onPressed: isChanged() ? onSubmit : null,
                child: (state is UserLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('บันทึก')),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildNameFormField() {
    return TextFormField(
      controller: _nameController,
      validator: nameValidator,
      keyboardType: TextInputType.name,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "ชื่อ",
      ),
    );
  }

  Widget buildDateOfBirthFormField() {
    return TextFormField(
      controller: _dateOfBirthController,
      keyboardType: TextInputType.datetime,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "วันเกิด",
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            _dateOfBirthController.text = formattedDate;
          });
        }
      },
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
