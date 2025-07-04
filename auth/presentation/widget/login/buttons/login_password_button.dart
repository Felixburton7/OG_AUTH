// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:panna_app/core/constants/colors.dart';
// import 'package:panna_app/core/extensions/build_context_extensions.dart';
// import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
// import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';

// class LoginButtonPassword extends StatelessWidget {
//   const LoginButtonPassword({
//     super.key,
//     required this.isEnabled,
//   });

//   final bool isEnabled;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginCubit, LoginState>(
//       builder: (context, state) {
//         return Container(
//           decoration: BoxDecoration(
//             color: isEnabled
//                 ? Theme.of(context).colorScheme.primary
//                 : Theme.of(context).canvasColor,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: ElevatedButton(
//             onPressed: isEnabled
//                 ? () {
//                     context.closeKeyboard();
//                     context.read<LoginCubit>().submitPasswordForm();
//                     context.read<ProfileCubit>().fetchProfile();
//                   }
//                 : null,
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text(
//               'Log in',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';

class LoginButtonPassword extends StatelessWidget {
  const LoginButtonPassword({
    super.key,
    required this.isEnabled,
  });

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: isEnabled
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton(
            onPressed: isEnabled
                ? () {
                    context.closeKeyboard();
                    context.read<LoginCubit>().submitPasswordForm();
                    // Removed ProfileCubit fetch to prevent potential state conflicts
                  }
                : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: state.status == FormzSubmissionStatus.inProgress
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Log in',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }
}
