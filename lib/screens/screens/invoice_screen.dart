import 'dart:ui';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/blocs/transfer_sila/transfer_sila.dart';
import 'package:divvy/sila/blocs/transfer_sila/transfer_sila_bloc.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class InvoiceScreen extends StatelessWidget {
  InvoiceScreen(this._lineItem, this._project, this._user);
  final LineItem _lineItem;
  final Project _project;
  final UserModel _user;
  final FirebaseService _firebaseService = FirebaseService();

  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  void approve(String projectID, String lineID) {
    int value = DateTime.now().millisecondsSinceEpoch;
    Map<String, int> firebaseData;

    firebaseData = {
      "homeowner_approval_date": value,
      "date_paid": value,
    };
    _firebaseService.addDataToProjectDocument(firebaseData, projectID, lineID);
  }

  @override
  Widget build(BuildContext context) {
    final cost = NumberFormat.currency(symbol: '\$').format(_lineItem.cost);

    return BlocProvider(
        create: (context) => TransferSilaBloc(silaRepository: silaRepository),
        child: MultiBlocListener(
            listeners: [
              BlocListener<TransferSilaBloc, TransferSilaState>(
                listener: (context, state) {
                  if (state is TransferSilaLoadFailure) {
                    Toast.show(state.exception.toString(), context,
                        duration: 4, gravity: Toast.BOTTOM);
                  }
                  if (state is TransferSilaLoadSuccess) {
                    approve(_user.projectID, _lineItem.id);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
              ),
            ],
            child: Scaffold(
              appBar: AppBar(
                title: Text('Invoice'),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _Header(_lineItem),
                                _Table(_lineItem),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  thickness: 3,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _PaymentInfoCard(_project, _lineItem.cost),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'I authorize Divvy to debit my Divvy Digital Safe and send money to the Contractor in my agreement. Once the funds have been sent Divvy can not refund you or dictate what the funds are used for',
                                  style: TextStyle(color: Colors.grey[400]),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: _lineItem.homeownerApprovalDate == null,
                    child: _ApproveButton(
                        _lineItem, _user, _project.generalContractorSilaHandle),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )));
  }
}

class _Header extends StatelessWidget {
  _Header(this._lineItem);

  final LineItem _lineItem;

  @override
  Widget build(BuildContext context) {
    final cost = NumberFormat.currency(symbol: '\$').format(_lineItem.cost);
    return Column(
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
      ],
    );
  }
}

class _Table extends StatelessWidget {
  _Table(this._lineItem);

  final LineItem _lineItem;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Table(
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
              DateFormat.yMMMMd('en_US').format(_lineItem.expectedFinishDate),
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
              DateFormat.yMMMMd('en_US')
                  .format(_lineItem.generalContractorApprovalDate),
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
    );
  }

  String paidDate() {
    if (_lineItem.homeownerApprovalDate == null) {
      DateTime date = DateTime.now();
      return DateFormat.yMMMMd('en_US').format(date);
    } else {
      return DateFormat.yMMMMd('en_US').format(_lineItem.homeownerApprovalDate);
    }
  }
}

class _PaymentInfoCard extends StatelessWidget {
  _PaymentInfoCard(this._project, this._cost);
  final Project _project;
  final double _cost;
  @override
  Widget build(BuildContext context) {
    final cost = NumberFormat.currency(symbol: '\$').format(_cost);
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: 200,
      width: double.maxFinite,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                _project.homeownerName,
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              Text(
                ' to ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                _project.generalContractorName,
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApproveButton extends StatelessWidget {
  _ApproveButton(this._lineItem, this.user, this.generalContractorSilaHandle);

  final LineItem _lineItem;
  final UserModel user;
  final String generalContractorSilaHandle;

  @override
  Widget build(BuildContext context) {
    final cost = NumberFormat.currency(symbol: '\$').format(_lineItem.cost);
    bool isEnabled = (_lineItem.generalContractorApprovalDate != null &&
            _lineItem.homeownerApprovalDate == null)
        ? true
        : false;
    return BlocBuilder<TransferSilaBloc, TransferSilaState>(
      //buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return RaisedButton(
          child: Text(
            'Send Payment of $cost',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          shape:
              (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          color: const Color(0xFF1E90FF),
          textColor: Colors.white,
          onPressed: isEnabled
              ? () {
                  BlocProvider.of<TransferSilaBloc>(context).add(
                      TransferSilaRequest(
                          sender: user,
                          amount: _lineItem.cost,
                          receiverHandle: generalContractorSilaHandle,
                          transferMessage:
                              _lineItem.id + '-' + _lineItem.title));
                }
              : null,
        );
      },
    );
  }
}
