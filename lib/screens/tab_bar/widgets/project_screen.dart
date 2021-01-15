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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                ProjectBloc(firebaseService: _firebaseService)),
        BlocProvider(
          create: (context) => LineItemBloc(firebaseService: _firebaseService),
        )
      ],
      child: Scaffold(
          body: Center(
              child: BlocListener<ProjectBloc, ProjectState>(
        listener: (context, state) {
          if (state is ProjectDoesNotExist) {
            SnackBar snackBar = SnackBar(
                content: Text('Project does not Exist. Please try again'));
            Scaffold.of(context).showSnackBar(snackBar);
          }
          if (state is ProjectDoesNotExist) {
            SnackBar snackBar = SnackBar(
                content: Text(
                    'Something went wrong loading project. Please try again'));
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
        },
        child:
            BlocBuilder<ProjectBloc, ProjectState>(builder: (context, state) {
          if (state is ProjectInitial) {
            BlocProvider.of<ProjectBloc>(context).add(CheckForProject(user));
            return Container();
          }
          if (state is CheckProjectInitial) {
            return Container();
          }
          if (state is ProjectLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal[300]),
              ),
            );
          }
          if (state is ProjectLoadSuccess) {
            return ProjectWidget();
          }
          return ConnectToProject();
        }),
      ))),
    );
  }
}
