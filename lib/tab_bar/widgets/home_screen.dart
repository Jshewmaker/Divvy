import 'package:divvy/sila/plaid/plaid_bloc/plaid_bloc.dart';
import 'package:divvy/sila/plaid/plaid_link/newplaidlink.dart';
import 'package:divvy/sila/plaid/plaid_network/plaid_network.dart';
import 'package:divvy/tab_bar/widgets/link_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class PlaidLinkSplashScreen extends StatelessWidget {
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
          backgroundColor: Colors.white,
          elevation: 0,
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
                    text: 'FrequencyPay!',
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
                                  'We use Plaid to help track your expenses and and '
                                  'get you in tune with your finances. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi eget posuere dolor. Mauris imperdiet ac arcu sed accumsan. Nam congue sapien a feugiat facilisis. '),
                        )),
                    Expanded(
                        child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.blue,
                            child: Text("Launch Plaid"),
                            textColor: Colors.white,
                            onPressed: () =>
                                plaidLink.launch(context, (result) {
                              if (result.token != null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (contest) => LinkAccountScreen(
                                        token: result.token)));
                              }
                            }),
                          ),
                        ],
                      ),
                    )),
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
