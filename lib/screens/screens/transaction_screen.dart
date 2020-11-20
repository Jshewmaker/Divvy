import 'package:divvy/sila/blocs/get_transactions/get_transactions.dart';
import 'package:divvy/sila/blocs/get_transactions/get_transactions_bloc.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class TransactionScreen extends StatelessWidget {
  final String collection = "users";
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetTransactionsBloc(silaRepository: silaRepository),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<GetTransactionsBloc, GetTransactionsState>(
            builder: (context, state) {
              if (state is GetEntityInitial) {
                BlocProvider.of<GetTransactionsBloc>(context)
                    .add(GetTransactionsRequest());
                return Container();
              }
              if (state is GetTransactionsLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is GetTransactionsLoadSuccess) {
                final apiResponse = state.response;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(apiResponse.transactions[0].status),
                  ],
                );
              }
              if (state is GetTransactionsLoadFailure) {
                return Text(
                  'Something went wrong with /get_transactions!',
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