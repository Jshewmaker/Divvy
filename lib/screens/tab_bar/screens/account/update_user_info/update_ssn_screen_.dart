import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/blocs/update_ssn/update_ssn_bloc.dart';
import 'package:divvy/sila/blocs/update_ssn/update_ssn_event.dart';
import 'package:divvy/sila/blocs/update_ssn/update_ssn_state.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class UpdateSsnScreen extends StatelessWidget {
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController();
    String value;

    return BlocProvider(
      create: (context) => UpdateSsnBloc(silaRepository: silaRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Divvy'),
        ),
        body: Center(
          child: BlocBuilder<UpdateSsnBloc, UpdateSsnState>(
            builder: (context, state) {
              if (state is UpdateSsnInitial) {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'ssn',
                            hintText: '124-56-789',
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                        child: Text('update'),
                        onPressed: () async {
                          if (_textController.text.isNotEmpty) {
                            value = _textController.text.replaceAll("-", "");
                            BlocProvider.of<UpdateSsnBloc>(context)
                                .add(UpdateSsnRequest(ssn: value));
                          }
                        })
                  ],
                );
              }
              if (state is UpdateSsnLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is UpdateSsnLoadSuccess) {
                final apiResponse = state.response;
                Map<String, String> firebaseData;
                FirebaseService _firebaseService = FirebaseService();
                firebaseData = {"ssn": value};

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
              if (state is UpdateSsnLoadFailure) {
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
