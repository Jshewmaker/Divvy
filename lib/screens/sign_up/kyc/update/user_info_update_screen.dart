import 'package:divvy/screens/screens/widgets/name_and_bday_widget.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;

import 'bloc/update_sila_user.dart';

class UserInfoUpdateScreen extends StatefulWidget {
  final String message;
  UserInfoUpdateScreen({Key key, this.message}) : super(key: key);

  @override
  _UserUpdateState createState() => _UserUpdateState(message);
}

// ignore: must_be_immutable
class _UserUpdateState extends State<UserInfoUpdateScreen> {
  final String message;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final MaskedTextController _phoneNumberController =
      MaskedTextController(mask: '000-000-0000');
  TextEditingController _birthdayController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  _UserUpdateState(this.message);

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
                fit: BoxFit.fitWidth, child: Text('Update Personal Info')),
            actions: [
              TextButton(
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.normal,
                      fontSize: 18),
                ),
                onPressed: () => {
                  BlocProvider.of<UpdateSilaUserBloc>(context)
                      .add(UpdateUserInfo(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    birthday: _birthdayController.text,
                    phone: _phoneNumberController.text,
                  )),
                },
              )
            ],
          ),
          body: Column(
            children: [
              Center(child: Text(message)),
              NameAndBdayWidget(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                phoneNumberController: _phoneNumberController,
                birthdayController: _birthdayController,
                formKey: _formKey,
              ),
            ],
          )),
    );
  }
}
