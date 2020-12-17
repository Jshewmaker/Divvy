import 'dart:ui';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatelessWidget {
  InvoiceScreen(this._lineItem, this._project);
  final LineItem _lineItem;
  final Project _project;
  @override
  Widget build(BuildContext context) {
    final cost = NumberFormat.currency(symbol: '\$').format(_lineItem.cost);
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  _lineItem.title,
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                cost,
                style: TextStyle(
                    color: Colors.teal[400],
                    fontSize: 48,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 3,
              ),
              SizedBox(
                height: 20,
              ),
              Table(
                columnWidths: {1: FractionColumnWidth(.35)},
                children: [
                  TableRow(children: [
                    Text(
                      'Expected Finish Date: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        DateFormat.yMMMMd('en_US')
                            .format(_lineItem.expectFinishedDate.toDate()),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
                  TableRow(children: [
                    Text(
                      'Work Submission Date: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        DateFormat.yMMMMd('en_US').format(
                            _lineItem.generalContractorApprovalDate.toDate()),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
                  TableRow(children: [
                    Text(
                      'Payment & Approval Date: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        paidDate(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ])
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 3,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                height: 200,
                width: double.maxFinite,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  color: Colors.teal[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            'Payment of $cost from ',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          _project.homeownerSilaHandle.substring(6),
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                        Text(
                          ' to ',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          _project.generalContractorSilaHandle.substring(6),
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _lineItem.homeownerApprovalDate == null,
                child: RaisedButton(
                  color: const Color(0xFF1E90FF),
                  shape: (RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                  child: Text(
                    'Send Payment of $cost',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String paidDate() {
    if (_lineItem.datePaid == null) {
      Timestamp date = Timestamp.now();
      return DateFormat.yMMMMd('en_US').format(date.toDate());
    } else {
      return DateFormat.yMMMMd('en_US').format(_lineItem.datePaid.toDate());
    }
  }
}
