import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/update_password/update_password_cubit.dart';
import 'package:panna_app/features/account/settings/presentation/widget/form/update_password_form.dart';

class UpdatePasswordPage extends StatelessWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UpdatePasswordCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update Password'),
        ),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: UpdatePasswordForm(),
          ),
        ),
      ),
    );
  }
}
