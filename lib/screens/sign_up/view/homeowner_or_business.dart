import 'package:divvy/screens/sign_up/sign_up.dart';
import 'package:divvy/screens/sign_up/view/contractor/select_business_type_screen.dart';

import 'package:flutter/material.dart';

class HomeownerOrBusinessScreen extends StatelessWidget {
  const HomeownerOrBusinessScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const HomeownerOrBusinessScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
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
              onPressed: () =>
                  Navigator.of(context).push<void>(SignUpPage.route()),
            )
          ],
        ),
      ),
    );
  }
}
