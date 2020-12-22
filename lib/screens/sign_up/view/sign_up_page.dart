import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/Screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/services.dart';
import 'package:formz/formz.dart';

// class SignUpPage extends StatelessWidget {
//   const SignUpPage({Key key}) : super(key: key);

//   static Route route() {
//     return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Homeowner Sign Up'),
//         actions: [
//           TextButton(
//               child: Text(
//                 'Next',
//                 style: TextStyle(
//                     color: Colors.blue,
//                     fontWeight: FontWeight.normal,
//                     fontSize: 18),
//               ),
//               onPressed: () => _SignUpButton()),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: BlocProvider<SignUpCubit>(
//           create: (_) => SignUpCubit(
//             context.read<AuthenticationRepository>(),
//           ),
//           child: SignUpForm(),
//         ),
//       ),
//     );
//   }
// }

// ignore: must_be_immutable
class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   appBar: AppBar(
        //     title: const Text('Homeowner Sign Up'),
        //     actions: [
        //       _signUpButton(context),
        //     ],
        //   ),
        //   child:
        BlocProvider<SignUpCubit>(
      create: (_) => SignUpCubit(
        context.read<AuthenticationRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Homeowner Sign Up',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: [
            _signUpButton(context),
          ],
        ),
        body: BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  content: Text('Sign Up Failure'),
                ));
            }
          },
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _EmailInput(),
                  const SizedBox(height: 8.0),
                  _PasswordInput(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpButton(context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? Container()
            : TextButton(
                key: const Key('signUpForm_continue_raisedButton'),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: state.status.isValidated
                    ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                    : null,
              );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) {
            // email1 = email;
            context.read<SignUpCubit>().emailChanged(email);
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'info@frequencypay.com',
            labelText: 'email',
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }

  // get email => email1;
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'password',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}
