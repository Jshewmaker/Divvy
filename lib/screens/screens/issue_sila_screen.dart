import 'package:flutter/material.dart';

class IssueSilaScreen extends StatefulWidget {
  @override
  State<IssueSilaScreen> createState() => _IssueSilaScreenState();
}

class _IssueSilaScreenState extends State<IssueSilaScreen> {
  final TextEditingController _textController = TextEditingController();
  bool canSendMoney = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('amount'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
        child: Form(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(15),
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          text:
                              'You are about to add money to your Divvy Escrow. Once you have added money to the Escrow, the money is there until the job is done. You can not withdraw the money or change who the money is going to. Divvy NEVER has access to this money and neither does the contractor until you have approved that the work was done '))),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    shape: (RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                    color: Colors.white,
                    elevation: 3,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'cancel',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => canSendMoney = true),
                    child: Text(
                      'accept',
                      style: TextStyle(
                          color: Colors.teal[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Visibility(
                        visible: canSendMoney,
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
                  ),
                ],
              ),
              Visibility(
                visible: canSendMoney,
                child: RaisedButton(
                  child: const Text('Deposit Money'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: const Color(0xFFa3c746),
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Alertdialog()));
                    // Alertdialog();
                    // showAlertDialog(context);
                    Navigator.pop(context, _textController.text);
                  },
                ),
              )
            ],
          ),
        ),
      ),
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
