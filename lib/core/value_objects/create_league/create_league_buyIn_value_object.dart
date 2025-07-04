import 'package:formz/formz.dart';

enum CreateLeagueBuyInValidationError {
  invalid,
  tooHigh,
}

class CreateLeagueBuyInValueObject
    extends FormzInput<String, CreateLeagueBuyInValidationError> {
  const CreateLeagueBuyInValueObject.pure() : super.pure('');
  const CreateLeagueBuyInValueObject.dirty([String value = ''])
      : super.dirty(value);

  static final RegExp _numericRegExp = RegExp(
      r'^\d+(\.\d{1,2})?$'); // Matches integers and decimals with up to two decimal places

  @override
  CreateLeagueBuyInValidationError? validator(String? value) {
    if (value == null || value.isEmpty || !_numericRegExp.hasMatch(value)) {
      return CreateLeagueBuyInValidationError.invalid;
    }
    final parsedValue = double.tryParse(value);
    if (parsedValue == null || parsedValue <= 0) {
      return CreateLeagueBuyInValidationError.invalid;
    }
    if (parsedValue > 1000) {
      return CreateLeagueBuyInValidationError.tooHigh;
    }
    return null;
  }
}
