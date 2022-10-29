import 'package:form_field_validator/form_field_validator.dart';

final nameValidator = MultiValidator([
  RequiredValidator(errorText: 'Name is required'),
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email ID is required'),
  EmailValidator(errorText: 'Enter a valid Email ID')
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'Minimum 8 caracters')
]);
