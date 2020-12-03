import 'package:divvy/screens/sign_up/view/contractor/admin/business_admin_signup_page_1.dart';
import 'package:flutter/material.dart';

class BusinessAdminTrasitionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Any person linked to a business must be verified individually using a their residential/home address and personal phone number. An individual should not be registered using business credentials, as this can cause problems with verifying them in their own KYC process. '),
              RaisedButton(
                child: Text('Continue to Admin Info'),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusinessAdminSignupPage1(),
                    ),
                  )
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
