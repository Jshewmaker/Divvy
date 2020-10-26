import 'package:divvy/tab_bar/screens/account/check_handle_screen.dart';
import 'package:divvy/tab_bar/screens/account/update_user_info/update_email_screen.dart';
import 'package:divvy/tab_bar/screens/account/update_user_info/update_phone_screen.dart';
import 'package:divvy/tab_bar/screens/issue_sila_screen.dart';
import 'package:divvy/tab_bar/screens/transaction_screen.dart';
import 'package:flutter/material.dart';

class AccountOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Divvy'),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              child: Text('Register Handle'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contest) => RegisterHandleScreen())),
            ),
            RaisedButton(
              child: Text('Update Email'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UpdateEmailScreen())),
            ),
            RaisedButton(
              child: Text('Update Phone'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => UpdatePhoneScreen())),
            ),
            RaisedButton(
              child: Text('Update SSN'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => IssueSilaScreen())),
            ),
            RaisedButton(
              child: Text('Update Address'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => TransactionScreen())),
            ),
            RaisedButton(
              child: Text('Update Personal Info'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => TransactionScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
