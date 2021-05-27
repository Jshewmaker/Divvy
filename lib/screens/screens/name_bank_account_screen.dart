import 'package:divvy/screens/screens/link_account_screen.dart';
import 'package:flutter/material.dart';

// Define a custom Form widget.
class NameBankAccountScreen extends StatefulWidget {
  NameBankAccountScreen(this.accountID, this.token);
  final String accountID;
  final String token;

  @override
  _NameBankAccountScreenState createState() => _NameBankAccountScreenState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _NameBankAccountScreenState extends State<NameBankAccountScreen> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final textEditingController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name Bank Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
            ),
            RaisedButton(
                child: Text('Add Bank Account'),
                shape: (RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                color: const Color(0xFF1E90FF),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LinkAccountScreen(
                              token: widget.token,
                              accountID: widget.accountID,
                              accountName: textEditingController.text)));
                })
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   // When the user presses the button, show an alert dialog containing
      //   // the text that the user has entered into the text field.
      //   onPressed: () {
      //     Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => LinkAccountScreen(
      //                 token: widget.token,
      //                 accountID: widget.accountID,
      //                 accountName: textEditingController.text)));
      //   },

      //   child: Icon(Icons.add),
      // ),
    );
  }
}
