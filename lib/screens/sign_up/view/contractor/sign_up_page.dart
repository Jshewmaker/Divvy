import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/sign_up/sign_up.dart';
import 'package:divvy/screens/sign_up/view/contractor/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractorSignUpPage extends StatelessWidget {
  ContractorSignUpPage(this._businessType, this._naicsCode);

  String _businessType;
  int _naicsCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contractor Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(
            context.repository<AuthenticationRepository>(),
          ),
          child: ContractorSignUpForm(_businessType, _naicsCode),
        ),
      ),
    );
  }
}
