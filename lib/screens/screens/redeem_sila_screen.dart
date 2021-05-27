import 'package:divvy/sila/blocs/redeem_sila/redeem_sila.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:divvy/sila/blocs/get_bank_accounts/get_bank_accounts_bloc.dart';
import 'package:divvy/sila/blocs/get_bank_accounts/get_bank_accounts_event.dart';
import 'package:divvy/sila/blocs/get_bank_accounts/get_bank_accounts_state.dart';
import 'package:divvy/sila/models/bank_accounts_entity.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// class ConnectToProject extends StatefulWidget {
//   ConnectToProject(this._user);

//   final UserModel _user;

//   @override
//   State<ConnectToProject> createState() => _ConnectToProjectState(_user);
// }

// class _ConnectToProjectState extends State<ConnectToProject> {
//   _ConnectToProjectState(
//     this.user,
//   );

//   final UserModel user;

class RedeemSilaScreen extends StatefulWidget {
  final double amount;

  RedeemSilaScreen(this.amount);

  @override
  State<RedeemSilaScreen> createState() => _RedeemSilaScreenState();
}

class _RedeemSilaScreenState extends State<RedeemSilaScreen> {
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));
  bool accepted = false;
  String selectedBankAccount;
  final currencyFormatter = NumberFormat.currency(symbol: "\$");

  @override
  Widget build(BuildContext context) {
    final amountFormatted = currencyFormatter.format(widget.amount);

    return BlocProvider(
      create: (context) => GetBankAccountsBloc(silaRepository: silaRepository),
      child: Scaffold(
        appBar: AppBar(title: Text('Withdraw Funds')),
        body: Center(
          child: BlocBuilder<GetBankAccountsBloc, GetBankAccountsState>(
            builder: (context, state) {
              if (state is GetBankAccountsInitial) {
                BlocProvider.of<GetBankAccountsBloc>(context)
                    .add(GetBankAccountsRequest());
                return Container();
              }
              if (state is GetBankAccountsLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is GetBankAccountsLoadSuccess) {
                final apiResponse = state.response;
                if (apiResponse.bankAccounts.length == 0) {
                  return NoAccounts();
                }

                return Center(
                    child: Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Container(
                          child: Column(
                            children: [
                              Form(
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(amountFormatted),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Account:",
                                        style: TextStyle(fontSize: 15),
                                      )),
                                  DropdownButton<String>(
                                    isDense: true,
                                    isExpanded: true,
                                    hint: new Text("Select Account"),
                                    value: selectedBankAccount,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        selectedBankAccount = newValue;
                                      });
                                    },
                                    items: apiResponse.bankAccounts
                                        .map((BankAccountEntity map) {
                                      return new DropdownMenuItem<String>(
                                        value: map.accountName,
                                        child: Text(map.accountName,
                                            style: new TextStyle(
                                              color: Colors.black,
                                            )),
                                      );
                                    }).toList(),
                                  ),
                                  RaisedButton(
                                    child: const Text('Withdraw Funds'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    color: const Color(0xFFa3c746),
                                    onPressed: (widget.amount != 0.0 &&
                                            selectedBankAccount != null)
                                        ? () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RedeemSilaWidget(
                                                          account:
                                                              selectedBankAccount,
                                                          amount: widget.amount
                                                              .toInt(),
                                                        )));

                                            Navigator.pop(context,
                                                'Transfer requested. The funds can take up to 72 hours to deposit into your bank account.');
                                          }
                                        : null,
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
              }
              if (state is GetBankAccountsLoadFailure) {
                return Text(
                  'Something went wrong with getting your accounts!',
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

class NoAccounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text(
        'No Accounts Linked',
        style: TextStyle(color: Colors.grey[400]),
      ),
    ));
  }
}

class RedeemSilaWidget extends StatelessWidget {
  RedeemSilaWidget({Key key, @required this.account, @required this.amount})
      : super(key: key);
  final int amount;
  final String account;
  final SilaRepository _silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RedeemSilaBloc(silaRepository: _silaRepository),
      child: Scaffold(
        body: Center(
          child: BlocListener<RedeemSilaBloc, RedeemSilaState>(
            listener: (context, state) {
              if (state is RedeemSilaLoadSuccess) {
                Navigator.pop(context,
                    'Transfer requested. The funds can take up to 72 hours to deposit into your bank account.');
              }
              if (state is RedeemSilaLoadFailure) {
                Navigator.pop(context, 'Request failed. Please try again.');
              }
            },
            child: BlocBuilder<RedeemSilaBloc, RedeemSilaState>(
              builder: (context, state) {
                if (state is RedeemSilaInitial) {
                  BlocProvider.of<RedeemSilaBloc>(context)
                      .add(RedeemSilaRequest(account: account, amount: amount));
                  return const EmptyWidget();
                } else if (state is RedeemSilaLoadInProgress) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(''),
      ),
    );
  }
}
