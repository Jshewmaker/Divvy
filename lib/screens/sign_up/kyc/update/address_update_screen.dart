import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/account/create_sila_user_screen.dart';
import 'package:divvy/screens/screens/widgets/address_widget.dart';
import 'package:divvy/screens/screens/widgets/name_and_bday_widget.dart';
import 'package:divvy/screens/sign_up/kyc/sign_up/ssn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'bloc/update_sila_user.dart';

class AddressUpdateScreen extends StatefulWidget {
  final String message;

  const AddressUpdateScreen({Key key, this.message}) : super(key: key);

  @override
  _AddressUpdateScreenState createState() => _AddressUpdateScreenState(message);
}

class _AddressUpdateScreenState extends State<AddressUpdateScreen> {
  final String message;
  FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  //final TextEditingController _countryController = TextEditingController();
  final MaskedTextController _zipCodeController =
      MaskedTextController(mask: '00000');
  final GlobalKey<FormState> _formKey = GlobalKey();

  _AddressUpdateScreenState(this.message);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateSilaUserBloc, UpdateSilaUserState>(
        listener: (context, state) {
          if (state is UpdateUserInfoSuccess) {
            Navigator.pop(context, true);
          }
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: FittedBox(
                  fit: BoxFit.fitWidth, child: Text('Update Address')),
              actions: [
                TextButton(
                    child: Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.normal,
                          fontSize: 18),
                    ),
                    onPressed: () =>
                        BlocProvider.of<UpdateSilaUserBloc>(context)
                            .add(UpdateAddress(
                          streetAddress: _streetAddressController.text,
                          city: _cityController.text,
                          state: _stateController.text,
                          postalCode: _zipCodeController.text,
                          country: "US",
                        )))
              ],
            ),
            body: Column(
              children: [
                Center(child: Text(message)),
                AddressWidget(
                  streetAddressController: _streetAddressController,
                  cityController: _cityController,
                  stateController: _stateController,
                  //countryController: _countryController,
                  zipCodeController: _zipCodeController,
                  formKey: _formKey,
                ),
              ],
            )));
  }
}
