import 'package:panna_app/core/extensions/string_extensions.dart';
import 'package:formz/formz.dart';

enum CreateLeagueTitleValidationError {
  invalid,
}

class CreateLeagueTitleValueObject
    extends FormzInput<String, CreateLeagueTitleValidationError> {
  const CreateLeagueTitleValueObject.pure() : super.pure('');

  const CreateLeagueTitleValueObject.dirty([
    super.value = '',
  ]) : super.dirty();

  static final RegExp _createLeagueTitleRegExp = RegExp(
    r'^[a-zA-Z0-9\s]+$', // Adjust the regex as needed for title validation
  );

  @override
  CreateLeagueTitleValidationError? validator(String? value) {
    if (value.isNullOrEmpty) return CreateLeagueTitleValidationError.invalid;

    return _createLeagueTitleRegExp.hasMatch(value!)
        ? null
        : CreateLeagueTitleValidationError.invalid;
  }
}
