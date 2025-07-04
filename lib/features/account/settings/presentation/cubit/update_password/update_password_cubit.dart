import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/auth/confirm_password_value_object.dart';
import 'package:panna_app/features/account/settings/domain/use_case/update_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'update_password_state.dart';

@injectable
class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  UpdatePasswordCubit(this._updatePasswordUseCase)
      : super(const UpdatePasswordState());

  final UpdatePasswordUseCase _updatePasswordUseCase;

  void passwordChanged(String value) {
    final password = PasswordValueObject.dirty(value);
    final confirmedPassword = ConfirmedPasswordValueObject.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      isValid: Formz.validate([password, confirmedPassword]),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPasswordValueObject.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      isValid: Formz.validate([state.password, confirmedPassword]),
    ));
  }

  Future<void> submitForm() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await _updatePasswordUseCase.execute(
      UpdatePasswordUseCaseParams(password: state.password.value),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: failure.message ?? 'Failed to update password.',
        ));
      },
      (_) async {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
        // Sign out the temporary session after password reset
        await Supabase.instance.client.auth.signOut();
      },
    );
  }
}
