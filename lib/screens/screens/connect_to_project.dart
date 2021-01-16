import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/bloc/project/project_bloc.dart';
import 'package:divvy/bloc/project/project_event.dart';
import 'package:divvy/bloc/project/project_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ConnectToProject extends StatefulWidget {
  ConnectToProject(this._user);

  final UserModel _user;

  @override
  State<ConnectToProject> createState() => _ConnectToProjectState(_user);
}

class _ConnectToProjectState extends State<ConnectToProject> {
  _ConnectToProjectState(
    this.user,
  );

  final UserModel user;
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProjectBloc, ProjectState>(
        listener: (context, state) {
          if (state is ProjectLoadFailure) {
            SnackBar snackBar = SnackBar(
                content: Text('Project failed to connect. Please try again'));
            Scaffold.of(context).showSnackBar(snackBar);
          }
          if (state is ProjectDoesNotExist) {
            SnackBar snackBar = SnackBar(
                content: Text('Project does not exist. Please try again'));
            Scaffold.of(context).showSnackBar(snackBar);
          }
          if (state is HomeownerExists) {
            SnackBar snackBar = SnackBar(
                content: Text(
                    'A homeowner has already connected to this project. Please try another ID'));
            Scaffold.of(context).showSnackBar(snackBar);
          }
          if (state is GCExists) {
            SnackBar snackBar = SnackBar(
                content: Text(
                    'A contractor has already connected to this project. Please try another ID'));
            Scaffold.of(context).showSnackBar(snackBar);
          }
          if (state is ProjectLoadSuccess) {
            Navigator.pop(context);
          }
        },
        child: Form(
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
                        keyboardType: TextInputType.number,
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
                        BlocProvider.of<ProjectBloc>(context).add(
                            ProjectInitialEvent(_textController.text.trim()));
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
