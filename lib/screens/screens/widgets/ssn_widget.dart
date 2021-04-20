import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class SSNWidget extends StatefulWidget {
  MaskedTextController ssnController =
      MaskedTextController(mask: '000-00-0000');
  final GlobalKey<FormState> formKey;

  SSNWidget({Key key, this.ssnController, this.formKey}) : super(key: key);

  @override
  _SSNWidgetState createState() => _SSNWidgetState();
}

class _SSNWidgetState extends State<SSNWidget> {
  String stateDropdownValue = 'AL';

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
            _ssnInput(),
            const SizedBox(height: 30.0),
          ],
        ),
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
            controller: widget.ssnController,
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
}
