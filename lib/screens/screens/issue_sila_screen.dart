import 'package:divvy/sila/blocs/get_bank_accounts/get_bank_accounts_bloc.dart';
import 'package:divvy/sila/blocs/get_bank_accounts/get_bank_accounts_event.dart';
import 'package:divvy/sila/blocs/get_bank_accounts/get_bank_accounts_state.dart';
import 'package:divvy/sila/models/bank_accounts_entity.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class IssueSilaScreen extends StatefulWidget {
  @override
  State<IssueSilaScreen> createState() => _IssueSilaScreenState();
}

class _IssueSilaScreenState extends State<IssueSilaScreen> {
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));
  final TextEditingController _textController = TextEditingController();
  bool accepted = false;
  String selectedBankAccount;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetBankAccountsBloc(silaRepository: silaRepository),
      child: Scaffold(
        appBar: AppBar(title: Text('Project Safe Deposit')),
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
                                        child: TextFormField(
                                          controller: _textController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d+\.?\d{0,2}'))
                                          ],
                                          decoration: InputDecoration(
                                            prefix: Text('\$'),
                                            labelText: 'Amount',
                                            hintText: '1000.00',
                                          ),
                                        ),
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
                                  Container(
                                    margin: const EdgeInsets.only(top: 30),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[300]),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Checkbox(
                                            value: accepted,
                                            activeColor: Colors.teal[200],
                                            onChanged: (bool value) {
                                              setState(() {
                                                this.accepted = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Text(
                                                    "I understand I am about to add money to my DivvySafe. Once I have added money to the Safe, the money is there until the job is done. I can not withdraw the money or change who the money is going to. DivvySafe NEVER has access to this money and neither does the contractor until I have approved that the work was done."),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RaisedButton(
                                    child: const Text('Deposit Money'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    color: const Color(0xFFa3c746),
                                    onPressed: (accepted &&
                                            _textController.text.trim() != '' &&
                                            selectedBankAccount != null)
                                        ? () {
                                            // Navigator.push(context,
                                            //     MaterialPageRoute(builder: (context) => Alertdialog()));
                                            // Alertdialog();
                                            // showAlertDialog(context);
                                            final bankAccountAndAmount = [];
                                            bankAccountAndAmount
                                                .add(_textController.text);
                                            bankAccountAndAmount
                                                .add(selectedBankAccount);
                                            Navigator.pop(
                                                context, bankAccountAndAmount);
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.teal),
      ),
      onPressed: () {
        if (_textController.text.isNotEmpty) _textController.text;
        Navigator.pop(
          context,
        );
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("WAIT"),
      content: Text("You are going to add \$" +
          _textController.text +
          " to the Escrow, is this correct?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class Alertdialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {},
        ),
        FlatButton(
          child: Text("Continue"),
          onPressed: () {},
        ),
      ],
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
