import 'package:divvy/sila/blocs/get_transactions/get_transactions.dart';
import 'package:divvy/sila/models/get_transactions_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class InvoiceScreen extends StatelessWidget {
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

                return PopulatedWidget(transactions: apiResponse);
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

class PopulatedWidget extends StatelessWidget {
  final GetTransactionsResponse transactions;

  PopulatedWidget({Key key, @required this.transactions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
      itemCount: transactions.transactions.length,
      separatorBuilder: (BuildContext context, int index) => Divider(height: 3),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(transactions.transactions[index].status),
          title: Text(DateFormat('MM-dd-yyyy').format(
              DateTime.parse(transactions.transactions[index].lastUpdate))),
          trailing: Text("\$" +
              ((transactions.transactions[index].silaAmount) / 100).toString()),
        );
      },
    ));
  }
}
