import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/blocs/update_entity/update_entity.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class UpdateEntityScreen extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));
  bool _validate = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateEntityBloc(silaRepository: silaRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('DivvySafe'),
        ),
        body: Center(
          child: BlocBuilder<UpdateEntityBloc, UpdateEntityState>(
            builder: (context, state) {
              if (state is UpdateEntityInitial) {
                return ListView(
                  children: [
                    _firstNameInput(),
                    const SizedBox(height: 8.0),
                    _lastNameInput(),
                    const SizedBox(height: 8.0),
                    _birthdateInput(),
                    RaisedButton(
                        child: Text('update'),
                        onPressed: () async {
                          Map<String, String> entity = {
                            "first_name": _firstNameController.text,
                            "last_name": _lastNameController.text,
                            "entity_name": _firstNameController.text +
                                " " +
                                _lastNameController.text,
                            "birthdate": _birthdateController.text,
                          };
                          BlocProvider.of<UpdateEntityBloc>(context)
                              .add(UpdateEntityRequest(entity: entity));
                        })
                  ],
                );
              }
              if (state is UpdateEntityLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is UpdateEntityLoadSuccess) {
                final apiResponse = state.response;
                FirebaseService _firebaseService = FirebaseService();

                Map<String, String> entityFirebase = {
                  "name":
                      "$_firstNameController.text $_lastNameController.text",
                  "birthdate": _birthdateController.text,
                };
                _firebaseService.addDataToFirestoreDocument(
                    'users', entityFirebase);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(apiResponse.message),
                  ],
                );
              }
              if (state is UpdateEntityLoadFailure) {
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

  Widget _firstNameInput() {
    return TextField(
      controller: _firstNameController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'First Name',
        errorText: _validate ? 'First Name Required' : null,
      ),
      keyboardType: TextInputType.streetAddress,
    );
  }

  Widget _lastNameInput() {
    return TextField(
      controller: _lastNameController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Last Name',
        errorText: _validate ? 'Last Name Required' : null,
      ),
    );
  }

  Widget _birthdateInput() {
    return TextField(
      controller: _birthdateController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Birthdate',
        hintText: 'YYYY-MM-DD',
        errorText: _validate ? 'Birthdate Required' : null,
      ),
    );
  }
}
