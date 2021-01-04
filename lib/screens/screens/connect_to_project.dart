import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/bloc/project/project_bloc.dart';
import 'package:divvy/bloc/project/project_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectToProject extends StatefulWidget {
  @override
  State<ConnectToProject> createState() => _ConnectToProjectState();
}

class _ConnectToProjectState extends State<ConnectToProject> {
  final TextEditingController _textController = TextEditingController();
  UserModel user;
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModelProvider>();
    return Scaffold(
      body: Form(
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  shape: (RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Project ID',
                        hintText: '1234567',
                      ),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                  child: Text('Connect To Project'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.blue[100],
                  onPressed: () async {
                    if (_textController.text.isNotEmpty) {
                      FirebaseService _firebaseService = FirebaseService();
                      _firebaseService.addUserDataToProject(
                          _textController.text.trim(), user.user);
                      BlocProvider.of<ProjectBloc>(context)
                          .add(ProjectInitialEvent());
                    }
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
