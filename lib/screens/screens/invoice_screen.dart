import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatelessWidget {
  InvoiceScreen(this._lineItem, this._generalContractorSilaHandle,
      this._homeownerSilaHandle);
  final LineItem _lineItem;
  final String _generalContractorSilaHandle;
  final String _homeownerSilaHandle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              _lineItem.title,
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              NumberFormat.currency(symbol: '\$').format(_lineItem.cost),
              style: TextStyle(
                  color: Colors.teal[400],
                  fontSize: 48,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              DateFormat('MM - dd - yyyy').format(_lineItem.datePaid.toDate()),
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              _homeownerSilaHandle.substring(6),
              style: TextStyle(fontSize: 22),
            ),
            Text(
              ' to ',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _generalContractorSilaHandle.substring(6),
              style: TextStyle(fontSize: 22),
            )
          ],
        ),
      ),
    );
  }
}
