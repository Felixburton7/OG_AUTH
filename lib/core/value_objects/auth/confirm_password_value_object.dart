import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { invalid }

class ConfirmedPasswordValueObject
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPasswordValueObject.pure({this.password = ''})
      : super.pure('');
  const ConfirmedPasswordValueObject.dirty({
    required this.password,
    String value = '',
  }) : super.dirty(value);

  final String password;

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    return password == value ? null : ConfirmedPasswordValidationError.invalid;
  }
}

enum PasswordValidationError { invalid }

class PasswordValueObject extends FormzInput<String, PasswordValidationError> {
  const PasswordValueObject.pure() : super.pure('');
  const PasswordValueObject.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegex = RegExp(r'^.{6,}$'); // Minimum 6 characters

  @override
  PasswordValidationError? validator(String value) {
    return _passwordRegex.hasMatch(value)
        ? null
        : PasswordValidationError.invalid;
  }
}
