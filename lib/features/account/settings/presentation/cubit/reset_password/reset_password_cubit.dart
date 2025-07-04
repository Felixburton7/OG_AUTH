import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/auth/email_value_object.dart';
import 'package:panna_app/features/account/settings/domain/use_case/change_password_usecase.dart';

part 'reset_password_state.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._resetPasswordUseCase)
      : super(const ResetPasswordState());

  final ResetPasswordUseCase _resetPasswordUseCase;

  void emailChanged(String value) {
    final email = EmailValueObject.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email])
          ? FormzSubmissionStatus.initial
          : FormzSubmissionStatus.failure,
    ));
  }

  Future<void> submitForm() async {
    if (!Formz.validate([state.email])) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await _resetPasswordUseCase.execute(
      ResetPasswordUseCaseParams(email: state.email.value),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Failed to send reset password email.',
        ));
      },
      (_) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          email: const EmailValueObject.pure(),
        ));
      },
    );
  }
}
