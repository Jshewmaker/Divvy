import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/account/request_kyc_screen.dart';
import 'package:divvy/screens/screens/kyb_screens/get_business_roles_screen.dart';
import 'package:divvy/sila/blocs/kyb_blocs/register_business_role.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';

class RegisterBusinessAdminScreen extends StatelessWidget {
  const RegisterBusinessAdminScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const RegisterBusinessAdminScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homeowner Sign Up')),
      body: SignUpForm(),
    );
  }
}

// ignore: must_be_immutable
class SignUpForm extends StatelessWidget {
  final SilaBusinessRepository _silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));
  String handle;
  UserModel user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBusinessRoleCubit(_silaBusinessRepository),
      child: BlocBuilder<RegisterBusinessRoleCubit, RegisterBusinessRoleState>(
        builder: (context, state) {
          if (state is RegisterBusinessRoleInitial) {
            return RegisterBusinessRoleEmpty();
          } else if (state is RegisterBusinessRoleLoadInProgress) {
            return const RegisterBusinessRoleLoading();
          } else if (state is RegisterBusinessRoleLoadSuccess) {
            return RegisterBusinessRolePopulated(response: state.response);
          } else {
            return const RegisterBusinessRoleError();
          }
        },
      ),
    );
  }
}

class RegisterBusinessRolePopulated extends StatelessWidget {
  RegisterBusinessRolePopulated({Key key, @required this.response})
      : super(key: key);

  final RegisterResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(response.message),
          RaisedButton(
            child: Text('Check KYC'),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (contest) => RequestKYCScreen())),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class RegisterBusinessRoleEmpty extends StatelessWidget {
  RegisterBusinessRoleEmpty({Key key}) : super(key: key);
  UserModel user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
    return Scaffold(
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: ListView(
          children: [
            _nameInput(),
            const SizedBox(height: 8.0),
            _emailInput(),
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
            RaisedButton(
              child: Text('Register'),
              onPressed: () async {
                if (_countryController.text.isNotEmpty) {
                  context
                      .read<RegisterBusinessRoleCubit>()
                      .registerBusinessRole(UserModel(
                        name: _nameController.text,
                        dateOfBirthYYYYMMDD: _birthdayController.text,
                        identityValue: _ssnController.text,
                        streetAddress: _streetAddressController.text,
                        city: _cityController.text,
                        state: _stateController.text,
                        country: _countryController.text,
                        postalCode: _postalCodeController.text,
                        phone: _phoneNumberController.text,
                        email: _emailController.text,
                      ));
                }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (contest) => GetBusinessRolesScreen()));
              },
            )
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

  Widget _emailInput() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: "@gmail.com",
        border: UnderlineInputBorder(),
        labelText: 'Email',
        errorText: _validate ? 'Email Required' : null,
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

  // Widget _signUpButton() {
  //   return RaisedButton(child: Text('Register'),onPressed: () => context.bloc<RegisterBusinessRoleCubit>.r,);
  // }
}

class RegisterBusinessRoleLoading extends StatelessWidget {
  const RegisterBusinessRoleLoading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Process Loading.'),
      ),
    );
  }
}

class RegisterBusinessRoleError extends StatelessWidget {
  const RegisterBusinessRoleError({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '🙈',
          style: TextStyle(fontSize: 64),
        ),
        Text(
          'Something went wrong!',
          style: theme.textTheme.headline5,
        ),
      ],
    );
  }
}
