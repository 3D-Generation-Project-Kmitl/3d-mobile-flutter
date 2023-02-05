import 'package:form_field_validator/form_field_validator.dart';

final idCardValidator = MultiValidator([
  RequiredValidator(errorText: 'โปรดระบุเลขบัตรประชาชน'),
  MinLengthValidator(13, errorText: 'เลขบัตรประชาชนต้องมีอย่างน้อย 13 หลัก'),
  MaxLengthValidator(13, errorText: 'เลขบัตรประชาชนต้องมีไม่เกิน 13 หลัก'),
]);

final phoneNumberValidator = MultiValidator([
  RequiredValidator(errorText: 'โปรดระบุเบอร์โทรศัพท์'),
  MinLengthValidator(10, errorText: 'เบอร์โทรศัพท์ต้องมีอย่างน้อย 10 หลัก'),
  MaxLengthValidator(10, errorText: 'เบอร์โทรศัพท์ต้องมีไม่เกิน 10 หลัก'),
]);

final nameValidator = MultiValidator([
  RequiredValidator(errorText: 'โปรดระบุชื่อ'),
]);

final surnameValidator = MultiValidator([
  RequiredValidator(errorText: 'โปรดระบุนามสกุล'),
]);

final bankNameValidator = MultiValidator([
  RequiredValidator(errorText: 'โปรดระบุชื่อธนาคาร'),
]);

final bankAccountValidator = MultiValidator([
  RequiredValidator(errorText: 'โปรดระบุเลขบัญชีธนาคาร'),
  MinLengthValidator(10, errorText: 'เลขบัญชีธนาคารต้องมีอย่างน้อย 10 หลัก'),
  MaxLengthValidator(15, errorText: 'เลขบัญชีธนาคารต้องมีไม่เกิน 15 หลัก'),
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'โปรดระบุอีเมล'),
  EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง')
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'โปรดระบุรหัสผ่าน'),
  MinLengthValidator(8, errorText: 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร'),
]);
