import 'package:divvy/sila/blocs/check_handle_bloc.dart';
import 'package:divvy/sila/blocs/check_handle_event.dart';
import 'package:divvy/sila/blocs/check_handle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectScreen extends StatefulWidget {
  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: BlocBuilder<CheckHandleBloc, CheckHandleState>(
          builder: (context, state) {
            if (state is CheckHandleInitial) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Username',
                          hintText: 'Divvy',
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                      child: Text('Search'),
                      onPressed: () async {
                        if (_textController.text.isNotEmpty) {
                          BlocProvider.of<CheckHandleBloc>(context).add(
                              CheckHandleRequest(handle: _textController.text));
                        }
                      })
                ],
              );
            }
            if (state is CheckHandleLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is CheckHandleLoadSuccess) {
              final apiResponse = state.checkHandle;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(apiResponse.message),
                  RaisedButton(child: Text('Continue')),
                ],
              );
            }
            if (state is CheckHandleLoadFailure) {
              return Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
