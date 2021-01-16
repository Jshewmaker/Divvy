import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/bloc/line_items/line_item_bloc.dart';
import 'package:divvy/bloc/project/project_bloc.dart';
import 'package:divvy/bloc/project/project_event.dart';
import 'package:divvy/bloc/project/project_state.dart';
import 'package:divvy/screens/screens/connect_to_project.dart';
import 'package:divvy/screens/tab_bar/widgets/project_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ProjectScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProjectScreen());
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);
    return Scaffold(
      body: Center(
          child: (user.projectID == null)
              ? RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.teal[200],
                  child: Text('Connect Project'),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (contest) => ConnectToProject(user))),
                )
              : ProjectWidget(user)),
    );
  }
}
