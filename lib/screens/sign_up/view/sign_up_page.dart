import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/Screens/sign_up/sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/services.dart';
import 'package:formz/formz.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignUpPage());
  }
}

// ignore: must_be_immutable
class _SignUpPageState extends State<SignUpPage> {
  bool accepted = false;

  // final TextEditingController _passwordValidatorController =
  //     TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (_) => SignUpCubit(
        context.read<AuthenticationRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
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
          child: Column(
            children: [
              Image.asset(
                'assets/divvy_full_logo.png',
                height: 120,
              ),
              Text(
                'Create Your Account!',
                style: TextStyle(fontSize: 24),
              ),
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        _EmailInput(),
                        const SizedBox(height: 8.0),
                        _PasswordInput(),

                        // const SizedBox(height: 8.0),
                        _ConfirmPasswordInput(),
                        Text(
                          'Passwords must be 8 characters in length and include numbers and letters.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                value: accepted,
                                activeColor: Colors.teal[200],
                                onChanged: (bool value) {
                                  setState(() {
                                    this.accepted = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    RichText(
                                      text: new TextSpan(
                                        children: [
                                          new TextSpan(
                                            text:
                                                'I have read and agree to the ',
                                            style: new TextStyle(
                                                color: Colors.black),
                                          ),
                                          new TextSpan(
                                            text:
                                                'Terms and Conditions and the Privacy Policy',
                                            style: new TextStyle(
                                                color: Colors.blue),
                                            recognizer:
                                                new TapGestureRecognizer()
                                                  ..onTap = () {
                                                    launch(
                                                        'https://www.divvysafe.com/terms-and-conditions');
                                                  },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                onPressed: (state.status.isValidated && accepted)
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

class _PasswordInput extends StatefulWidget {
  @override
  _PasswordInputState createState() => new _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Row(
          children: [
            Flexible(
              child: TextField(
                key: const Key('signUpForm_passwordInput_textField'),
                onChanged: (value) =>
                    context.read<SignUpCubit>().passwordChanged(value),
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'password',
                  helperText: '',
                  errorText: state.password.invalid ? 'invalid password' : null,
                ),
              ),
            ),
            new IconButton(
              onPressed: _toggle,
              icon:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            )
          ],
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatefulWidget {
  @override
  _ConfirmPasswordInputState createState() => new _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<_ConfirmPasswordInput> {
  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return Row(
          children: [
            Flexible(
              child: TextField(
                key: const Key('signUpForm_confirmedPasswordInput_textField'),
                onChanged: (confirmPassword) => context
                    .read<SignUpCubit>()
                    .confirmedPasswordChanged(confirmPassword),
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'confirm password',
                  helperText: '',
                  errorText: state.confirmedPassword.invalid
                      ? 'passwords do not match'
                      : null,
                ),
              ),
            ),
            new IconButton(
              onPressed: _toggle,
              icon:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            )
          ],
        );
      },
    );
  }
}
