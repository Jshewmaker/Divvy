import 'package:divvy/screens/invoice_helper.dart';
import 'package:divvy/screens/screens/invoice_screen.dart';
import 'package:divvy/sila/blocs/get_transactions/get_transactions.dart';
import 'package:divvy/sila/models/get_transactions_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TransactionsScreen extends StatelessWidget {
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
        var color = cardColor(transactions.transactions[index].transactionType);
        return _Card(transactions, index, color);
      },
    ));
  }

  Color cardColor(String transactionType) {
    if (transactionType == 'transfer')
      return Colors.blue;
    else if (transactionType == 'issue')
      return Colors.teal;
    else if (transactionType == 'redeem')
      return Colors.green;
    else
      return Colors.black;
  }
}

class _Card extends StatelessWidget {
  _Card(this._transactions, this.index, this._color);
  final GetTransactionsResponse _transactions;
  final int index;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    var lineItemID = getLineItem(_transactions.transactions[index].descriptor);
    return ListTile(
      onTap: () => {
        if (_transactions.transactions[index].transactionType == 'transfer')
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InvoiceHelperScreen(lineItemID)))
      },
      leading: Text(
        DateFormat('MM-dd-yyyy').format(
                DateTime.parse(_transactions.transactions[index].lastUpdate)) +
            '\n${_transactions.transactions[index].status}',
        style: TextStyle(color: _color),
      ),
      title: Text(
        getTransactionName(_transactions.transactions[index]),
        style: TextStyle(color: _color),
      ),
      trailing: Text(
        NumberFormat.currency(symbol: '\$')
            .format(_transactions.transactions[index].silaAmount / 100),
        style: TextStyle(color: _color),
      ),
    );

    // Container(
    //   height: 50,
    //   child: Card(
    //     elevation: 0,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         Text(
    //           DateFormat('MM-dd-yyyy').format(
    //               DateTime.parse(_transactions.transactions[index].lastUpdate)),
    //           style: TextStyle(color: _color),
    //         ),
    //         Text(
    //           _transactions.transactions[index].status,
    //           style: TextStyle(color: _color),
    //         ),
    //         Text(
    //           NumberFormat.currency(symbol: '\$')
    //               .format(_transactions.transactions[index].silaAmount / 100),
    //           style: TextStyle(color: _color),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  String getLineItem(String lineItemID) {
    if (lineItemID.contains('-')) {
      var splitTrans = lineItemID.split('-');

      // if (splitTrans.length == 1) {
      //   return splitTrans[0];
      // }
      return splitTrans[0];
    }
    return lineItemID;
  }

  String getTransactionName(Transactions transaction) {
    if (transaction.transactionType == 'redeem') {
      return 'Transfered Funds To Bank';
    }
    if (transaction.transactionType == 'issue') {
      return 'Deposit into Divvy Digital Wallet';
    }
    if (transaction.transactionType == 'transfer') {
      if (transaction.descriptor.contains('-')) {
        var splitTrans = transaction.descriptor.split('-');

        if (splitTrans.length == 1) {
          return "";
        }
        return 'Payment for ${splitTrans[1]}';
      }
    }

    return "";
  }
}
