import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/bloc/project/project_bloc.dart';
import 'package:divvy/bloc/project/project_event.dart';
import 'package:divvy/bloc/project/project_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectedProjectsScreen extends StatelessWidget {
  final UserModel user;

  void switchProject(String projectID) {
    FirebaseService firebaseService = FirebaseService();
    firebaseService
        .addDataToFirestoreDocument("users", {"project_id": projectID});
  }

  const ConnectedProjectsScreen({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FirebaseService firebaseService = FirebaseService();
    return Scaffold(
        appBar: AppBar(
          title: Text('Connected Projects'),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            child: BlocProvider(
              create: (context) =>
                  ProjectBloc(firebaseService: firebaseService),
              child: BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, state) {
                  if (state is ProjectInitial) {
                    BlocProvider.of<ProjectBloc>(context)
                        .add(ProjectListRequested(user.projectList));
                  }
                  if (state is ProjectListLoadSuccess) {
                    return ListView.builder(
                        itemCount: state.projects.length,
                        itemBuilder: (context, index) {
                          return _projectCard(state.projects[index], context);
                        });
                  } else
                    return Container();
                },
              ),
            ),
          ),
        ));
  }

  Widget _projectCard(Project project, BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          switchProject(project.projectID);
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Text(project.address,
                style: TextStyle(
                  color: Colors.teal[400],
                  fontSize: 30,
                )),
            Text("${project.homeownerName.split(" ")[1]} Project",
                style: TextStyle(
                  fontSize: 22,
                )),
            SizedBox(
              height: 20,
            ),
            Text(project.homeownerName),
          ]),
        ),
      ),
    );
  }
}
