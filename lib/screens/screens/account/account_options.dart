import 'package:divvy/screens/screens/account/check_handle_screen.dart';
import 'package:divvy/screens/screens/account/kyc_screen.dart';
import 'package:divvy/screens/screens/account/plaid_link_screen.dart';
import 'package:divvy/screens/screens/account/update_user_info/update_address_screen.dart';
import 'package:divvy/screens/screens/account/update_user_info/update_email_screen.dart';
import 'package:divvy/screens/screens/account/update_user_info/update_entity_screen.dart';
import 'package:divvy/screens/screens/account/update_user_info/update_phone_screen.dart';
import 'package:divvy/screens/screens/kyb_screens/check_kyb_screen.dart';
import 'package:divvy/screens/screens/kyb_screens/get_entity_screen.dart';
import 'package:divvy/screens/screens/kyb_screens/link_business_member_screen.dart';
import 'package:divvy/screens/screens/kyb_screens/register_business_admin_screen.dart';
import 'package:divvy/screens/screens/kyb_screens/register_business_screen.dart';
import 'package:divvy/screens/screens/kyb_screens/request_kyb_screen.dart';
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
              child: Text('Request KYC'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (contest) => KycScreen())),
            ),
            RaisedButton(
              child: Text('Register Business'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => RegisterKYBScreen())),
            ),
            RaisedButton(
              child: Text('Register User for KYB'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contest) => RegisterBusinessAdminScreen())),
            ),
            RaisedButton(
              child: Text('Link Business Member'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contest) => LinkBusinessMemberScreen())),
            ),
            RaisedButton(
              child: Text('Request KYB'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => RequestKYBScreen())),
            ),
            RaisedButton(
              child: Text('Check KYB'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => CheckKYBScreen())),
            ),
            RaisedButton(
              child: Text('Get Entity'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => GetEntityScreen())),
            ),
            RaisedButton(
              child: Text('Link Plaid'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (contest) => PlaidLinkScreen())),
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
              child: Text('Update Address'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contest) => UpdateAddressScreen())),
            ),
            RaisedButton(
              child: Text('Update Personal Info'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contest) => UpdateEntityScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
