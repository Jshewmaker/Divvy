import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sign_up/cubit/sign_up_cubit.dart';
import 'package:divvy/sign_up/view/contractor/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractorSignUpPage extends StatelessWidget {
  const ContractorSignUpPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const ContractorSignUpPage());
  }

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
          child: ContractorSignUpForm(),
        ),
      ),
    );
  }
}
