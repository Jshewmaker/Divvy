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
                'Administrator Signup',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E90FF)),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'On the following screens, you will signup an administrator for the business.  Any person linked to a business must be verified individually using  their residential/home address and phone number. An individual should not be registered using business credentials, as this can cause problems with verifying them in their own KYC process. This person will hold all access to the business account and have access to funds and project data.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                child: Text('Continue to Admin Info'),
                shape: (RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                color: const Color(0xFF1E90FF),
                textColor: Colors.white,
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
