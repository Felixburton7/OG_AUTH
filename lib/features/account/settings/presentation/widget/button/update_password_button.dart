import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/update_password/update_password_cubit.dart';

class UpdatePasswordButton extends StatelessWidget {
  const UpdatePasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdatePasswordCubit, UpdatePasswordState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully')),
          );
          // Navigate to login page after password update
          context.push(Routes.login.path);
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(state.errorMessage ?? 'Failed to update password')),
          );
        }
      },
      builder: (context, state) {
        if (state.status.isInProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        return ElevatedButton(
          onPressed: state.isValid
              ? () => context.read<UpdatePasswordCubit>().submitForm()
              : null,
          child: const Text('Update Password'),
        );
      },
    );
  }
}
