import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/blocs/register/register.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class InvoiceScreen extends StatelessWidget {
  final String collection = "users";
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckKycBloc(silaRepository: silaRepository),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<CheckKycBloc, CheckKycState>(
            builder: (context, state) {
              if (state is CheckKycInitial) {
                BlocProvider.of<CheckKycBloc>(context)
                    .add(CheckKycRequest());
                return Container();
              }
              if (state is CheckKycLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is CheckKycLoadSuccess) {
                final apiResponse = state.response;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(apiResponse.message),
                  ],
                );
              }
              if (state is CheckKycLoadFailure) {
                return Text(
                  'Something went wrong with check_kyc!',
                  style: TextStyle(color: Colors.red),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
