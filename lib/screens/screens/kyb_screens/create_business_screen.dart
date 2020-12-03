import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/tab_bar_container.dart';
import 'package:divvy/sila/blocs/kyb_blocs/create_business_cubit.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CreateSilaBusinessScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreateSilaBusinessScreen());
  }

  final SilaBusinessRepository silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateSilaBusinessCubit(silaBusinessRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Divvy'),
        ),
        body: Center(
          child: BlocListener<CreateSilaBusinessCubit, CreateSilaBusinessState>(
            listener: (context, state) {
              if (state is CreateSilaBusinessSuccess) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (contest) => HomeScreen()));
              }
            },
            child:
                BlocBuilder<CreateSilaBusinessCubit, CreateSilaBusinessState>(
                    builder: (context, state) {
              if (state is GetUserDataForProvider) {
                var userprovider = context.repository<UserModelProvider>();
                userprovider.add(state.user);
              }
              if (state is CreateSilaBusinessInitial) {
                BlocProvider.of<CreateSilaBusinessCubit>(context)
                    .createBusinesss();
              }

              if (state is CertifyBusinessFailure) {
                return Text(
                  "Certify Business Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              if (state is CertifyBeneficialOwnerFailure) {
                return Text(
                  "Certify Beneficial Owner Failure" +
                      state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              if (state is GetEntityFailure) {
                return Text(
                  "Get Entity Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              if (state is CheckKybFailure) {
                return Text(
                  "Check Kyb Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              if (state is RequestKYBFailure) {
                return Text(
                  "Request KYB Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              if (state is LinkBusinessMembersFailure) {
                return Text(
                  "Link Business Members Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              if (state is GetBusinessRolesFailure) {
                return Text(
                  "Get Business Roles Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              if (state is RegisterBusinessFailure) {
                return Text(
                  "Register Business Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              if (state is RegisterBusinessRoleLoadFailure) {
                return Text(
                  "Register Business Role Failure" + state.exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              }

              if (state is CheckKybNotPassed) {
                return Text(
                  "Register Business Role Failure" + state.response,
                  style: TextStyle(color: Colors.red),
                );
              }

              return Center(child: CircularProgressIndicator());
            }),
          ),
        ),
      ),
    );
  }
}
