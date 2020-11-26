import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class IssueSilaScreen extends StatelessWidget {
  final String collection = "users";
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IssueSilaBloc(silaRepository: silaRepository),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Center(
                child: BlocBuilder<IssueSilaBloc, IssueSilaState>(
                  builder: (context, state) {
                    if (state is IssueSilaInitial) {
                      return Column(
                        children: [
                          TextField(
                            controller: _amountController,
                          ),
                          RaisedButton(
                              child: Text('Add Funds'),
                              onPressed: () async {
                                showAlertDialog(context);
                              }),
                        ],
                      );
                    }
                    if (state is IssueSilaLoadInProgress) {
                      return Center(
                          child: Column(
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ));
                    }
                    if (state is IssueSilaLoadSuccess) {
                      final apiResponse = state.response;
                      Navigator.pop(context);
                      // return Center(
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Text(apiResponse.message),
                      //     ],
                      //   ),
                      // );
                    }
                    if (state is IssueSilaLoadFailure) {
                      return Text(
                        'Something went wrong with issue_sila!',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
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
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.teal),
      ),
      onPressed: () {
        if (_amountController.text.isNotEmpty)
          BlocProvider.of<IssueSilaBloc>(context).add(
              IssueSilaRequest(amount: double.parse(_amountController.text)));
        Navigator.pop(context);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("WAIT"),
      content: Text("You are going to add \$" +
          _amountController.text +
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
