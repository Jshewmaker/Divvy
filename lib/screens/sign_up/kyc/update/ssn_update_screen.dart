import 'package:divvy/screens/screens/widgets/ssn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'bloc/update_sila_user.dart';

class SSNUpdateScreen extends StatelessWidget {
  final String message;
  final MaskedTextController _ssnController =
      MaskedTextController(mask: '000-00-0000');
  final GlobalKey<FormState> _formKey = GlobalKey();

  SSNUpdateScreen({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: FittedBox(fit: BoxFit.fitWidth, child: Text('Update SSN')),
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
                    BlocProvider.of<UpdateSilaUserBloc>(context).add(UpdateSSN(
                      ssn: _ssnController.text.replaceAll("-", ""),
                    ))),
          ],
        ),
        body: BlocListener<UpdateSilaUserBloc, UpdateSilaUserState>(
            listener: (context, state) {
              if (state is UpdateUserInfoSuccess) {
                Navigator.pop(context, true);
              } else if (state is UpdateUserInfoFailure) {
                SnackBar snackBar =
                    SnackBar(content: Text('Update failed. Please try again'));
                Scaffold.of(context).showSnackBar(snackBar);
              }
            },
            child: Column(
              children: [
                Center(child: Text(message)),
                SSNWidget(
                  ssnController: _ssnController,
                  formKey: _formKey,
                ),
              ],
            )));
  }
}
