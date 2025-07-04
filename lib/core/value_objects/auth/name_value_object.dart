import 'package:panna_app/core/extensions/string_extensions.dart';
import 'package:formz/formz.dart';

enum NameValidationError {
  invalid,
}

class NameValueObject extends FormzInput<String, NameValidationError> {
  const NameValueObject.pure() : super.pure('');

  const NameValueObject.dirty([
    String value = '',
  ]) : super.dirty(value);

  static final RegExp _nameRegExp = RegExp(
    r'^[a-zA-Z]+$',
  );

  @override
  NameValidationError? validator(String? value) {
    if (value.isNullOrEmpty) return NameValidationError.invalid;

    return _nameRegExp.hasMatch(value!) ? null : NameValidationError.invalid;
  }
}
