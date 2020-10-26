import 'package:divvy/tab_bar/screens/account/account_options.dart';
import 'package:divvy/tab_bar/screens/account/check_handle_screen.dart';
import 'package:divvy/tab_bar/screens/get_wallet_info_screen.dart';
import 'package:divvy/tab_bar/screens/issue_sila_screen.dart';
import 'package:divvy/tab_bar/screens/transaction_screen.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              child: Text('Account'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contest) => AccountOptionsScreen())),
            ),
            RaisedButton(
              child: Text('Select Username'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contest) => RegisterHandleScreen())),
            ),
            RaisedButton(
              child: Text('get balance'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contest) => GetWalletInfoScreen())),
            ),
            RaisedButton(
              child: Text('Issue Sila'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => IssueSilaScreen())),
            ),
            RaisedButton(
              child: Text('Get Transactions'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => TransactionScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
