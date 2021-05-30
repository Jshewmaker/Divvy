import 'package:divvy/screens/screens/link_account_screen.dart';
import 'package:divvy/sila/blocs/wallet_screen/wallet_screen_bloc.dart';
import 'package:divvy/sila/blocs/wallet_screen/wallet_screen_event.dart';
import 'package:divvy/sila/plaid/plaid_bloc/plaid_bloc.dart';
import 'package:divvy/sila/plaid/plaid_link/newplaidlink.dart';
import 'package:divvy/sila/plaid/plaid_network/plaid_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class PlaidLinkScreen extends StatelessWidget {
  final PlaidLink plaidLink = PlaidLink();
  static const Color blueHighlight = const Color(0xFF3665FF);
  final PlaidRepository plaidRepository = PlaidRepository(
      plaidAPIClient: PlaidAPIClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlaidBloc>(
      create: (context) => PlaidBloc(plaidRepository: plaidRepository),
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                fontSize: 25.0,
                color: Colors.black45,
              ),

              children: <TextSpan>[
                new TextSpan(text: 'Welcome To '),
                new TextSpan(
                    text: 'DivvySafe!',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, color: blueHighlight)),
              ],
            ),
          ),
        ),
        body: Center(
          child: BlocBuilder<PlaidBloc, PlaidState>(
            builder: (context, plaidState) {
              if (plaidState is PlaidInitial) {
                return Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(15),
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              text:
                                  'We use Plaid to verify you are who you say you are and to fund your project! None of your bank account information is ever shared with DivvySafe or Pliad.'
                                  'DivvySafe does not have access to any of the funds in your bank account at any time. Once you have connected your bank accuont to DivvySafe you will be able to add the funds needed to start your home renovation project!'),
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    RaisedButton(
                      shape: (RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                      color: const Color(0xFF1E90FF),
                      child: Text(
                        "Connect Bank Account To DivvySafe",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      textColor: Colors.white,
                      onPressed: () => plaidLink.launch(context, (result) {
                        if (result.token != null) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (contest) => LinkAccountScreen(
                                        token: result.token,
                                        accountID: result.accountId,
                                      )))
                              .then((value) => {
                                    BlocProvider.of<WalletScreenBloc>(context)
                                        .add(WalletScreenCheck(initial: true))
                                  });
                        }
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40),
                    )
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
