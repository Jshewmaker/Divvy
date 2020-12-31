import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/sign_up/view/contractor/admin/business_admin_signup_page_2.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';

class BusinessAdminSignupPage1 extends StatefulWidget {
  BusinessAdminSignupPage1({Key key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

// ignore: must_be_immutable
class _SignUpFormState extends State<BusinessAdminSignupPage1> {
  FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _nameController = TextEditingController();
  final MaskedTextController _ssnController =
      MaskedTextController(mask: '000-00-0000');
  final MaskedTextController _confirmSsnController =
      MaskedTextController(mask: '000-00-0000');
  final TextEditingController _birthdayController = TextEditingController();
  final MaskedTextController _phoneNumberController =
      MaskedTextController(mask: '000-000-0000');
  final TextEditingController _emailController = TextEditingController();
  String yearDropDown = '1900';
  String monthDropDown = '1';
  String dayDropDown = '1';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Admin Personal Info'),
        actions: [
          TextButton(
              child: Text(
                'Next',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.normal,
                    fontSize: 18),
              ),
              onPressed: () => _signUpButton(context)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              _nameInput(),
              const SizedBox(height: 8.0),
              _emailInput(),
              const SizedBox(height: 8.0),
              _ssnInput(),
              const SizedBox(height: 8.0),
              _confirmSSN(),
              const SizedBox(height: 8.0),
              _birthdayInput(),
              const SizedBox(height: 8.0),
              _phoneNumberInput(),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Divvy must obtian, verify and record information that identifies each customer who opens an account with us. when you open an account with us, we will ask for your name, physical address and other information that assists us in verifying your identity. Additional information or documentation may be requested.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
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

  Widget _ssnInput() {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            validator: (value) {
              if (value.length != 11) {
                return 'Please Enter Valid Social Security Number';
              }
              return null;
            },
            controller: _ssnController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: "xxx-xx-xxxx",
              labelText: 'Social Security Number',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _confirmSSN() {
    return TextFormField(
      controller: _confirmSsnController,
      validator: (val) {
        if (val.isEmpty) return "";
        if (val != _ssnController.text) return 'SSNs Do Not Match';
        return null;
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Confirm SSN',
        hintText: 'xxx-xx-xxxx',
      ),
      keyboardType: TextInputType.number,
    );
  }

  // _showAlertDialog(BuildContext context) {
  //   // set up the button
  //   Widget okButton = FlatButton(
  //     child: Text("OK"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );

  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("My title"),
  //     content: Text(
  //         "We need your SSN to validate who you are. We do this for your protection to make sure no one can open an account in your name"),
  //     actions: [
  //       okButton,
  //     ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  // Widget _birthdayInput(context) {
  //   return TextFormField(
  //     validator: (value) {
  //       if (value.length != 10) {
  //         return 'Please Enter Birthday as YYYY-MM-DD';
  //       }
  //       return null;
  //     },
  //     onTap: () => _selectDate(context),
  //     controller: _birthdayController,
  //     decoration: InputDecoration(
  //       border: UnderlineInputBorder(),
  //       hintText: 'YYYY/MM/DD',
  //       labelText: 'Birthday',
  //     ),
  //     keyboardType: TextInputType.datetime,
  //   );
  // }

  Widget _birthdayInput() {
    var yearList =
        new List<String>.generate(103, (i) => (1899 + i + 1).toString());
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

  Widget _emailInput() {
    return TextFormField(
      validator: (value) {
        if (!value.contains('@')) {
          return 'Please Enter Valid Email Address.';
        }
        return null;
      },
      controller: _emailController,
      decoration: InputDecoration(
        hintText: "info@FrequencyPay.com",
        border: UnderlineInputBorder(),
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  // _selectDate(BuildContext context) async {
  //   DateTime _selectedDate;
  //   DateTime newSelectedDate = await showDatePicker(
  //       context: context,
  //       initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime(2040),
  //       builder: (BuildContext context, Widget child) {
  //         return Theme(
  //           data: ThemeData.light().copyWith(
  //             colorScheme: ColorScheme.light(
  //               primary: Colors.teal[200],
  //               onPrimary: Colors.white,
  //               surface: Colors.teal[200],
  //               onSurface: Colors.black,
  //             ),
  //             // dialogBackgroundColor: Colors.teal[500],
  //           ),
  //           child: child,
  //         );
  //       });

  //   if (newSelectedDate != null) {
  //     _selectedDate = newSelectedDate;
  //     _birthdayController
  //       ..text = DateFormat("yyyy-MM-dd").format(_selectedDate)
  //       ..selection = TextSelection.fromPosition(TextPosition(
  //           offset: _birthdayController.text.length,
  //           affinity: TextAffinity.upstream));
  //   }
  // }

  Widget _phoneNumberInput() {
    return TextFormField(
      validator: (value) {
        if (value.length != 12) {
          return 'Please Enter Valid Phone Number With Area Code.';
        }
        return null;
      },
      controller: _phoneNumberController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Phone Number',
        hintText: '(xxx)xxx-xxxx',
      ),
      keyboardType: TextInputType.phone,
    );
  }

  void _signUpButton(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _firebaseService.createBusinessAdminInFirestore(
          'users',
          UserModel(
            name: _nameController.text,
            email: _emailController.text,
            dateOfBirthYYYYMMDD: '$yearDropDown-$monthDropDown-$dayDropDown',
            identityValue: _ssnController.text,
            phone: _phoneNumberController.text,
            isHomeowner: false,
          ).toEntity().toDocumentAdminInfo());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessAdminSignupPage2(),
        ),
      );
    }
  }
}
