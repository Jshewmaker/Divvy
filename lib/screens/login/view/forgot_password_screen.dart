import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  shape: (RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _emailTextController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'email',
                        hintText: 'info@DivvySafe.com',
                      ),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                  child: Text('Reset Password'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.blue[100],
                  onPressed: () async {
                    if (_emailTextController.text.isNotEmpty) {
                      String errorMessage1;
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: _emailTextController.text);
                        Navigator.pop(context);
                      } catch (error) {
                        errorMessage1 = errorMessage(error);
                        Toast.show(errorMessage1, context, duration: 3);
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  String errorMessage(error) {
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        return "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        return "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        return "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        return "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        return "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Signing in with Email and Password is not enabled.";
        break;
      default:
        return "An undefined Error happened.";
    }
  }
}
