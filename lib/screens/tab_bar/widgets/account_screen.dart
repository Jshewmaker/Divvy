import 'package:divvy/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:divvy/screens/screens/account/account_options.dart';
import 'package:divvy/screens/screens/account/plaid_link_screen.dart';
import 'package:divvy/screens/screens/bank_account_balance_screen.dart';
import 'package:divvy/screens/screens/connect_to_project.dart';
import 'package:divvy/screens/screens/issue_sila_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // RaisedButton(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(30.0),
            //   ),
            //   color: Colors.teal[200],
            //   child: Text('Account'),
            //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            //       builder: (contest) => AccountOptionsScreen())),
            // ),
            // RaisedButton(
            //   child: Text('Select Username'),
            //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            //       builder: (contest) => RegisterHandleScreen())),
            // ),
            // RaisedButton(
            //   child: Text('get balance'),
            //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            //       builder: (contest) => GetWalletInfoScreen())),
            // ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.teal[200],
              child: Text('Check Bank Account Balance'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contest) => BankAccountInfoScreen())),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.teal[200],
              child: Text('Connect Project'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => ConnectToProject())),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.teal[200],
              child: Text('Log Out'),
              onPressed: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
            ),
            // RaisedButton(
            //   child: Text('Issue Sila'),
            //   onPressed: () => Navigator.of(context).push(
            //       MaterialPageRoute(builder: (contest) => IssueSilaScreen())),
            // ),
            // RaisedButton(
            //   child: Text('Get Transactions'),
            //   onPressed: () => Navigator.of(context).push(
            //       MaterialPageRoute(builder: (contest) => TransactionScreen())),
            // ),
            // RaisedButton(
            //   child: Text('Link Plaid'),
            //   onPressed: () => Navigator.of(context).push(
            //       MaterialPageRoute(builder: (contest) => PlaidLinkScreen())),
            // ),
          ],
        ),
      ),
    );
  }
}
