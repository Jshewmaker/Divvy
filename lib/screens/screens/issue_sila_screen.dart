import 'package:flutter/material.dart';

class IssueSilaScreen extends StatefulWidget {
  @override
  State<IssueSilaScreen> createState() => _IssueSilaScreenState();
}

class _IssueSilaScreenState extends State<IssueSilaScreen> {
  final TextEditingController _textController = TextEditingController();
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Project Safe Deposit')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            child: Container(
              child: Column(
                children: [
                  Form(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: TextFormField(
                                controller: _textController,
                                decoration: InputDecoration(
                                  prefix: Text('\$'),
                                  labelText: 'Amount',
                                  hintText: '1000',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                value: accepted,
                                activeColor: Colors.teal[200],
                                onChanged: (bool value) {
                                  setState(() {
                                    this.accepted = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                        "I understand I am about to add money to my Divvy Safe. Once I have added money to the Safe, the money is there until the job is done. I can not withdraw the money or change who the money is going to. Divvy NEVER has access to this money and neither does the contractor until I have approved that the work was done."),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        child: const Text('Deposit Money'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: const Color(0xFFa3c746),
                        onPressed: (accepted &&
                                _textController.text.trim() != '')
                            ? () {
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) => Alertdialog()));
                                // Alertdialog();
                                // showAlertDialog(context);
                                Navigator.pop(context, _textController.text);
                              }
                            : null,
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.teal),
      ),
      onPressed: () {
        if (_textController.text.isNotEmpty) _textController.text;
        Navigator.pop(
          context,
        );
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("WAIT"),
      content: Text("You are going to add \$" +
          _textController.text +
          " to the Escrow, is this correct?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class Alertdialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {},
        ),
        FlatButton(
          child: Text("Continue"),
          onPressed: () {},
        ),
      ],
    );
  }
}
