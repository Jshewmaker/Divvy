import 'package:divvy/sila/blocs/update_email/update_email.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class UpdateEmailScreen extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateEmailBloc(silaRepository: silaRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Divvy'),
        ),
        body: Center(
          child: BlocBuilder<UpdateEmailBloc, UpdateEmailState>(
            builder: (context, state) {
              if (state is UpdateEmailInitial) {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'email',
                            hintText: '@gmail.com',
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                        child: Text('update'),
                        onPressed: () async {
                          if (_textController.text.isNotEmpty) {
                            BlocProvider.of<UpdateEmailBloc>(context).add(
                                UpdateEmailRequest(
                                    email: _textController.text));
                          }
                        })
                  ],
                );
              }
              if (state is UpdateEmailLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is UpdateEmailLoadSuccess) {
                final apiResponse = state.response;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(apiResponse.message),
                  ],
                );
              }
              if (state is UpdateEmailLoadFailure) {
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
