import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';

class NameDOBWidget extends StatefulWidget {
  NameDOBWidget({Key key}) : super(key: key);

  @override
  _NameDOBState createState() => _NameDOBState();
}

class _NameDOBState extends State<NameDOBWidget> {
  String yearDropDown = '1950';
  String monthDropDown = '1';
  String dayDropDown = '1';
  FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _nameController = TextEditingController();

  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            _nameInput(),
            const SizedBox(height: 8.0),
            _birthdayInput(),
            const SizedBox(height: 8.0),
            Text(
              'YYYY      MM     DD',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'DivvySafe must obtain, verify and record information that identifies each customer who opens an account with us. when you open an account with us, we will ask for your name, physical address and other information that assists us in verifying your identity. Additional information or documentation may be requested.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameInput() {
    return TextFormField(
      controller: _nameController,
      validator: (value) {
        if (value.isEmpty || !value.contains(' ')) {
          return 'Please Enter First And Last Name.';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Jane Doe",
        border: UnderlineInputBorder(),
        labelText: 'Full Name',
      ),
    );
  }

  Widget _birthdayInput() {
    var yearList =
        new List<String>.generate(103, (i) => (1949 + i + 1).toString());
    var monthList = new List<String>.generate(12, (i) => (i + 1).toString());

    var dayList = new List<String>.generate(31, (i) => (i + 1).toString());

    return Row(
      children: [
        customDropDown(
          yearList,
        ),
        customDropDown(
          monthList,
        ),
        customDropDown(
          dayList,
        )
      ],
    );
  }

  Widget customDropDown(
    List<String> list,
  ) {
    var startingValue;
    if (list.length > 32) {
      startingValue = yearDropDown;
    } else if (list.length > 12) {
      startingValue = dayDropDown;
    } else {
      startingValue = monthDropDown;
    }
    return DropdownButton<String>(
      value: startingValue,
      underline: Container(
        height: 1.5,
        color: Colors.grey[400],
      ),
      onChanged: (String newValue) {
        setState(() {
          FocusScope.of(context).requestFocus(new FocusNode());
          if (list.length > 32) {
            yearDropDown = newValue;
          } else if (list.length > 12) {
            dayDropDown = newValue;
          } else {
            monthDropDown = newValue;
          }
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      iconEnabledColor: Colors.white,
    );
  }
}
