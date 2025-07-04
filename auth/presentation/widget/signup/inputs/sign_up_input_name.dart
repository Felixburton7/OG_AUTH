// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:panna_app/core/widgets/textfields/base_text_field.dart';
// import 'package:panna_app/features/auth/presentation/bloc/signup/signup_cubit.dart';

// class SignUpNameInput extends StatelessWidget {
//   const SignUpNameInput({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SignUpCubit, SignUpState>(
//       buildWhen: (previous, current) => previous.name != current.name,
//       builder: (context, state) {
//         return BaseTextField(
//           labelText: "Name",
//           onChanged: (name) => context.read<SignUpCubit>().nameChanged(name),
//           textInputAction: TextInputAction.next,
//           errorText: state.name.displayError != null ? "Invalid name" : null,
//           keyboardType: TextInputType.text,
//           obscureText: false,
//         );
//       },
//     );
//   }
// }
