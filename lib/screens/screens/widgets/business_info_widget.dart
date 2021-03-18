import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class BusinessInfoWidget extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  MaskedTextController phoneNumberController =
      MaskedTextController(mask: '000-000-0000');
  TextEditingController birthdayController;
  final GlobalKey<FormState> formKey;

  BusinessInfoWidget(
      {Key key,
      this.firstNameController,
      this.lastNameController,
      this.phoneNumberController,
      this.birthdayController,
      this.formKey})
      : super(key: key);

  @override
  _BusinessInfoWidgetState createState() => _BusinessInfoWidgetState();
}

class _BusinessInfoWidgetState extends State<BusinessInfoWidget> {
  String yearDropDown = '1950';
  String monthDropDown = '1';
  String dayDropDown = '1';

  @override
  Widget build(BuildContext context) {
    final _formKey = widget.formKey;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            _firstNameInput(),
            const SizedBox(height: 8.0),
            _lastNameInput(),
            // _ssnInput(context),
            const SizedBox(height: 8.0),
            // _confirmSsn(),
            // const SizedBox(height: 8.0),
            _birthdayInput(),
            const SizedBox(height: 8.0),
            Text(
              'MM      DD     YYYY',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            _phoneNumberInput(),
            const SizedBox(height: 30.0),
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Text(
            //     'DivvySafe must obtian, verify and record information that identifies each customer who opens an account with us. when you open an account with us, we will ask for your name, physical address and other information that assists us in verifying your identity. Additional information or documentation may be requested.',
            //     style: TextStyle(color: Colors.grey),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _firstNameInput() {
    return TextFormField(
      controller: widget.firstNameController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter First Name.';
        }
        return null;
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'First Name',
      ),
    );
  }

  Widget _lastNameInput() {
    return TextFormField(
      controller: widget.lastNameController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Last Name.';
        }
        return null;
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Last Name',
      ),
    );
  }

  Widget _phoneNumberInput() {
    return TextFormField(
      validator: (value) {
        if (value.length != 12) {
          return 'Please Enter Valid Phone Number With Area Code.';
        }
        return null;
      },
      controller: widget.phoneNumberController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Phone Number',
        hintText: '(xxx)xxx-xxxx',
      ),
      keyboardType: TextInputType.phone,
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
          monthList,
        ),
        customDropDown(
          dayList,
        ),
        customDropDown(
          yearList,
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
          widget.birthdayController.text =
              '$yearDropDown-$monthDropDown-$dayDropDown';
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
