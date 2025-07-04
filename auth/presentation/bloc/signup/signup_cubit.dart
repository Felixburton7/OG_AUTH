import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/auth/email_value_object.dart';
import 'package:panna_app/core/value_objects/auth/name_value_object.dart';
import 'package:panna_app/core/value_objects/auth/password_value_object.dart';
import 'package:panna_app/features/auth/domain/use_case/user_sign_up_password_email.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'signup_state.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._signUpWithPasswordUseCase) : super(const SignUpState());

  final SignUpWithPasswordUseCase _signUpWithPasswordUseCase;

  // void nameChanged(String value) {
  //   final name = NameValueObject.dirty(value);
  //   emit(state.copyWith(
  //     name: name,
  //     isValid: Formz.validate([name, state.email, state.password]),
  //   ));
  // }

  void emailChanged(String value) {
    final email = EmailValueObject.dirty(value);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([state.password, email]),
    ));
  }

  void passwordChanged(String value) {
    final password = PasswordValueObject.dirty(value);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password]),
    ));
  }

  void moveToPasswordStep() {
    emit(state.copyWith(isEmailStep: false));
  }

  void moveToEmailStep() {
    emit(state.copyWith(isEmailStep: true));
  }

  void submitForm() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _signUpWithPasswordUseCase.execute(
        SignUpWithPasswordParams(
          // name: state.name.value,
          email: state.email.value,
          password: state.password.value,
        ),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage:
            e.message ?? 'An unexpected error occurred when signing up',
      ));
    }
  }
}
