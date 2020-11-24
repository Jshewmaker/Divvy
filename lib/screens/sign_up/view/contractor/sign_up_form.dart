import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

// ignore: must_be_immutable
class ContractorSignUpForm extends StatelessWidget {
  ContractorSignUpForm(this._businessType, this._naicsCode);

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _einController = TextEditingController();
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String _businessType;
  int _naicsCode;

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
            _EmailInput(),
            const SizedBox(height: 8.0),
            _nameInput(),
            const SizedBox(height: 8.0),
            _doingBusinessAsInput(),
            const SizedBox(height: 8.0),
            _websiteInput(),
            const SizedBox(height: 8.0),
            _einInput(),
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
      controller: _businessNameController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Business Name',
        errorText: _validate ? 'Name Required' : null,
      ),
    );
  }

  Widget _doingBusinessAsInput() {
    return TextField(
      controller: _aliasController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Doing Business As Name',
        errorText: _validate ? 'Name Required' : null,
      ),
    );
  }

  Widget _websiteInput() {
    return TextField(
      controller: _websiteController,
      decoration: InputDecoration(
        prefixText: 'https://',
        border: UnderlineInputBorder(),
        labelText: 'Website',
        errorText: _validate ? 'Website Required' : null,
      ),
      keyboardType: TextInputType.url,
    );
  }

  Widget _einInput() {
    return TextField(
      controller: _einController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'EIN',
        hintText: '12-1234567',
        errorText: _validate ? 'EIN Required' : null,
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _streetAddressInput() {
    return TextField(
      controller: _streetAddressController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Street Address',
        errorText: _validate ? 'Street Address Required' : null,
      ),
    );
  }

  Widget _cityInput() {
    return TextField(
      controller: _cityController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'City',
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
                child: const Text('CONTINUE'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.orangeAccent,
                onPressed: state.status.isValidated
                    ? () => context
                        .bloc<SignUpCubit>()
                        .signUpFormSubmitted(UserModel(
                          name: _businessNameController.text,
                          website: "https://" + _websiteController.text,
                          identityValue: _einController.text,
                          doingBusinessAsName: _aliasController.text,
                          streetAddress: _streetAddressController.text,
                          city: _cityController.text,
                          state: _stateController.text,
                          country: _countryController.text,
                          postalCode: _postalCodeController.text,
                          phone: _phoneNumberController.text,
                          email: _emailController.text,
                          businessType: _businessType,
                          naicsCode: _naicsCode,
                          isHomeowner: false,
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
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('contractor_signUpForm_passwordInput_textField'),
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
