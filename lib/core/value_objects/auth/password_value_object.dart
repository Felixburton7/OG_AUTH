import 'package:formz/formz.dart';

enum PasswordValidationError {
  invalid,
}

class PasswordValueObject extends FormzInput<String, PasswordValidationError> {
  const PasswordValueObject.pure() : super.pure('');
  const PasswordValueObject.dirty([String value = '']) : super.dirty(value);

  static final RegExp _passwordRegExp = RegExp(
    r'^.{8,}$', // At least 8 characters
  );

  @override
  PasswordValidationError? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : PasswordValidationError.invalid;
  }
}
