import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class AccountScreen extends StatelessWidget {
  final String collection = "users";
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestKYCBloc(silaRepository: silaRepository),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<RequestKYCBloc, RequestKYCState>(
            builder: (context, state) {
              if (state is RequestKYCInitial) {
                BlocProvider.of<RequestKYCBloc>(context)
                    .add(RequestKYCRequest());
                return Container();
              }
              if (state is RequestKYCLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is RequestKYCLoadSuccess) {
                final apiResponse = state.handle;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(apiResponse.message),
                  ],
                );
              }
              if (state is RequestKYCLoadFailure) {
                return Text(
                  'Something went wrong with KYC!',
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
