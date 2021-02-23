import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/blocs/update_phone/update_phone_bloc.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class UpdatePhoneScreen extends StatelessWidget {
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController();
    String value;

    return BlocProvider(
      create: (context) => UpdatePhoneBloc(silaRepository: silaRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('DivvySafe'),
        ),
        body: Center(
          child: BlocBuilder<UpdatePhoneBloc, UpdatePhoneState>(
            builder: (context, state) {
              if (state is UpdatePhoneInitial) {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'phone',
                            hintText: '123-456-7890',
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                        child: Text('update'),
                        onPressed: () async {
                          if (_textController.text.isNotEmpty) {
                            value = _textController.text.replaceAll("-", "");
                            BlocProvider.of<UpdatePhoneBloc>(context)
                                .add(UpdatePhoneRequest(phoneNumber: value));
                          }
                        })
                  ],
                );
              }
              if (state is UpdatePhoneLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is UpdatePhoneLoadSuccess) {
                final apiResponse = state.response;
                Map<String, String> firebaseData;
                FirebaseService _firebaseService = FirebaseService();
                firebaseData = {"phone": value};

                _firebaseService.addDataToFirestoreDocument(
                    'users', firebaseData);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(apiResponse.message),
                  ],
                );
              }
              if (state is UpdatePhoneLoadFailure) {
                return Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.red),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
