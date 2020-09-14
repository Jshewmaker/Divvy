import 'package:divvy/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.bloc<AuthenticationBloc>().state.user;
    return Scaffold(
      body: Center(
        child: Text("Project Screen"),
      ),
    );
  }
}
