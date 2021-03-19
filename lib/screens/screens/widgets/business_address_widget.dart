import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class BusinessAddressWidget extends StatefulWidget {
  final TextEditingController streetAddressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  TextEditingController countryController = TextEditingController(text: 'US');
  MaskedTextController postalCodeController =
      MaskedTextController(mask: '00000');
  final GlobalKey<FormState> formKey;

  BusinessAddressWidget(
      {Key key,
      this.streetAddressController,
      this.cityController,
      this.stateController,
      this.countryController,
      this.postalCodeController,
      this.formKey})
      : super(key: key);

  @override
  _BusinessAddressWidgetState createState() => _BusinessAddressWidgetState();
}

class _BusinessAddressWidgetState extends State<BusinessAddressWidget> {
  String stateDropdownValue = 'AL';

  @override
  Widget build(BuildContext context) {
    final _formKey = widget.formKey;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            _streetAddressInput(),
            const SizedBox(height: 8.0),
            _cityInput(),
            const SizedBox(height: 8.0),
            _stateInput(),
            const SizedBox(height: 8.0),
            _countryInput(),
            const SizedBox(height: 8.0),
            _postalCodeInput(),
          ],
        ),
      ),
    );
  }

  Widget _streetAddressInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Valid Address';
        }
        return null;
      },
      controller: widget.streetAddressController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Street Address',
        hintText: '123 River Lane',
      ),
      keyboardType: TextInputType.streetAddress,
    );
  }

  Widget _cityInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter City';
        }
        return null;
      },
      controller: widget.cityController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'City',
        hintText: 'Dallas',
      ),
    );
  }

  Widget _stateInput() {
    return DropdownButton<String>(
      value: stateDropdownValue,
      underline: Container(
        height: 1.5,
        color: Colors.grey[400],
      ),
      onChanged: (String newValue) {
        setState(() {
          stateDropdownValue = newValue;
        });
      },
      items: <String>[
        'AL',
        'AK',
        'AZ',
        'AR',
        'CA',
        'CO',
        'CT',
        'DE',
        'FL',
        'GA',
        'HI',
        'ID',
        'IL',
        'IN',
        'IA',
        'KS',
        'KY',
        'LA',
        'ME',
        'MD',
        'MA',
        'MI',
        'MN',
        'MS',
        'MO',
        'MT',
        'NE',
        'NV',
        'NH',
        'NJ',
        'NM',
        'NY',
        'NC',
        'ND',
        'OH',
        'OK',
        'OR',
        'PA',
        'RI',
        'SC',
        'SD',
        'TN',
        'TX',
        'UT',
        'VT',
        'VA',
        'WA',
        'WV',
        'WI',
        'WY',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _countryInput() {
    return TextField(
      enabled: false,
      controller: widget.countryController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Country',
        hintText: 'US',
      ),
    );
  }

  Widget _postalCodeInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty || value.length != 5) {
          return 'Please Enter Zip Code.';
        }
        return null;
      },
      controller: widget.postalCodeController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Zip Code',
        hintText: '75001',
      ),
      keyboardType: TextInputType.number,
    );
  }
}
