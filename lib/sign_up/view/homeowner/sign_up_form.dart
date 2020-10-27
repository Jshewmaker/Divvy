import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:divvy/sign_up/sign_up.dart';
import 'package:formz/formz.dart';

// ignore: must_be_immutable
class SignUpForm extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ssnController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Sign Up Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: ListView(
          children: [
            _nameInput(),
            const SizedBox(height: 8.0),
            _EmailInput(),
            const SizedBox(height: 8.0),
            _ssnInput(),
            const SizedBox(height: 8.0),
            _birthdayInput(),
            const SizedBox(height: 8.0),
            _streetAddressInput(),
            const SizedBox(height: 8.0),
            _cityInput(),
            const SizedBox(height: 8.0),
            _stateInput(),
            const SizedBox(height: 8.0),
            _countryInput(),
            const SizedBox(height: 8.0),
            _postalCodeInput(),
            const SizedBox(height: 8.0),
            _phoneNumberInput(),
            const SizedBox(height: 8.0),
            _PasswordInput(),
            const SizedBox(height: 8.0),
            _signUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _nameInput() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: "Jane Doe",
        border: UnderlineInputBorder(),
        labelText: 'Full Name',
        errorText: _validate ? 'Name Required' : null,
      ),
    );
  }

  Widget _ssnInput() {
    return TextField(
      controller: _ssnController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: "xxx-xx-xxxx",
        labelText: 'Social Security Number',
        errorText: _validate ? 'SSN Required' : null,
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _birthdayInput() {
    return TextField(
      controller: _birthdayController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'YYYY/MM/DD',
        labelText: 'Birthday',
        errorText: _validate ? 'Birtday Required' : null,
      ),
      keyboardType: TextInputType.datetime,
    );
  }

  Widget _streetAddressInput() {
    return TextField(
      controller: _streetAddressController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Street Address',
        hintText: '111 River Lane',
        errorText: _validate ? 'Street Required' : null,
      ),
      keyboardType: TextInputType.streetAddress,
    );
  }

  Widget _cityInput() {
    return TextField(
      controller: _cityController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'City',
        hintText: 'Dallas',
        errorText: _validate ? 'City Required' : null,
      ),
    );
  }

  Widget _stateInput() {
    return TextField(
      controller: _stateController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'State',
        hintText: 'TX',
        errorText: _validate ? 'State Required' : null,
      ),
    );
  }

  Widget _countryInput() {
    return TextField(
      controller: _countryController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Country',
        hintText: 'US',
        errorText: _validate ? 'Country Required' : null,
      ),
    );
  }

  Widget _postalCodeInput() {
    return TextField(
      controller: _postalCodeController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Zip Code',
        hintText: '75001',
        errorText: _validate ? 'Zip Code Required' : null,
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _phoneNumberInput() {
    return TextField(
      controller: _phoneNumberController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Phone Number',
        hintText: '(xxx)xxx-xxxx',
        errorText: _validate ? 'Phone Number Required' : null,
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _signUpButton() {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                child: const Text('SIGN UP'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.orangeAccent,
                onPressed: state.status.isValidated
                    ? () => context
                        .bloc<SignUpCubit>()
                        .signUpFormSubmitted(UserModel(
                          name: "divvy-" + _nameController.text,
                          dateOfBirthYYYYMMDD: _birthdayController.text,
                          identityValue: _ssnController.text,
                          streetAddress: _streetAddressController.text,
                          city: _cityController.text,
                          state: _stateController.text,
                          country: _countryController.text,
                          postalCode: _postalCodeController.text,
                          phone: _phoneNumberController.text,
                        ))
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
            context.bloc<SignUpCubit>().emailChanged(email);
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
              context.bloc<SignUpCubit>().passwordChanged(password),
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
