import 'package:divvy/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:divvy/screens/sign_up/view/contractor/select_business_type_screen.dart';
import 'package:divvy/screens/sign_up/view/homeowner/sila_info/user_info_input_screen.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeownerOrBusinessScreen extends StatelessWidget {
  const HomeownerOrBusinessScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const HomeownerOrBusinessScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested());
            Navigator.of(context).pop();
          },
        ),
        title: Text('Welcome',
            style: GoogleFonts.bigShouldersDisplay(
                textStyle: TextStyle(fontSize: 32))),
        actions: [
          TextButton(
            key: const Key('homePage_logout_iconButton'),
            child: Text(
              'Sign Out',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested()),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            RichText(
              text: new TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: new TextStyle(
                  fontSize: 36.0,
                  color: Colors.black45,
                ),
                children: <TextSpan>[
                  new TextSpan(text: 'Welcome To '),
                  new TextSpan(
                      text: 'DivvySafe!',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3665FF))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80.0, right: 80.0, top: 10),
              child: Text(
                'To get you started we first need to know who you are:',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text('Contractor'),
                  shape: (RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                  color: const Color(0xFFa3c746),
                  textColor: Colors.white,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectBusinessTypeScreen())),
                ),
                const SizedBox(
                  height: 8.0,
                  width: 40.0,
                ),
                RaisedButton(
                  child: Text('Homeowner'),
                  shape: (RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                  color: const Color(0xFF1E90FF),
                  textColor: Colors.white,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserInfoInputScreen(
                            accountType: 'homeowner',
                          ))),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
