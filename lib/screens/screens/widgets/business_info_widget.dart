import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class BusinessInfoWidget extends StatefulWidget {
  final TextEditingController businessNameController;
  final TextEditingController aliasController;
  final TextEditingController websiteController;
  MaskedTextController einController = MaskedTextController(mask: '00-0000000');
  MaskedTextController confirmEinController =
      MaskedTextController(mask: '00-0000000');
  MaskedTextController phoneNumberController =
      MaskedTextController(mask: '000-000-0000');
  final GlobalKey<FormState> formKey;

  BusinessInfoWidget(
      {Key key,
      this.businessNameController,
      this.aliasController,
      this.websiteController,
      this.einController,
      this.confirmEinController,
      this.phoneNumberController,
      this.formKey})
      : super(key: key);

  @override
  _BusinessInfoWidgetState createState() => _BusinessInfoWidgetState();
}

class _BusinessInfoWidgetState extends State<BusinessInfoWidget> {
  MaskedTextController confirmEinController =
      MaskedTextController(mask: '00-0000000');
  @override
  Widget build(BuildContext context) {
    final _formKey = widget.formKey;
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                _nameInput(),
                const SizedBox(height: 8.0),
                _doingBusinessAsInput(),
                const SizedBox(height: 8.0),
                _websiteInput(),
                const SizedBox(height: 8.0),
                _einInput(),
                const SizedBox(height: 8.0),
                _confirmEin(),
                const SizedBox(height: 8.0),
                _phoneNumberInput(),
              ],
            ),
          )),
    );
  }

  Widget _nameInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Business Name';
        }
        return null;
      },
      controller: widget.businessNameController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Business Name',
      ),
    );
  }

  Widget _doingBusinessAsInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter \'Your Doing Business As\' Name';
        }
        return null;
      },
      controller: widget.aliasController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Doing Business As Name',
      ),
    );
  }

  Widget _websiteInput() {
    RegExp regex = RegExp(
        r"(https?:\/\/)?(www\.)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&\/=]*)|(https?:\/\/)?(www\.)?(?!ww)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&\/=]*)");
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Website';
        } else if (!regex.hasMatch(value)) {
          return 'Website is invalid. Please make sure your website has the the correct format';
        }

        return null;
      },
      controller: widget.websiteController,
      decoration: InputDecoration(
        prefixText: 'https://www.',
        border: UnderlineInputBorder(),
        labelText: 'Website',
      ),
      keyboardType: TextInputType.url,
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
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _einInput() {
    return TextFormField(
      validator: (value) {
        if (value.length != 10) {
          return 'Please Enter Valid EIN';
        }
        return null;
      },
      controller: widget.einController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'EIN',
        hintText: '12-1234567',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _confirmEin() {
    return TextFormField(
      controller: confirmEinController,
      validator: (val) {
        if (val.isEmpty) return "";
        if (val != widget.einController.text) return 'EINs Do Not Match';
        return null;
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Confirm EIN',
        hintText: '12-1234567',
      ),
      keyboardType: TextInputType.number,
    );
  }
}
