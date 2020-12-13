import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divvy/bloc/line_items/line_item_bloc.dart';
import 'package:divvy/bloc/line_items/line_item_state.dart';
import 'package:divvy/bloc/project/project_bloc.dart';
import 'package:divvy/bloc/project/project_state.dart';
import 'package:authentication_repository/src/models/project_line_items/messages.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

class Messages extends StatelessWidget {
  Messages(
    this.lineItem,
    this.project,
    this.user,
  );

  final LineItem lineItem;
  final Project project;
  final UserModel user;

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                ProjectBloc(firebaseService: _firebaseService)),
        BlocProvider(
          create: (context) => LineItemBloc(firebaseService: _firebaseService),
        )
      ],
      child: Scaffold(body: Center(child:
          BlocBuilder<ProjectBloc, ProjectState>(builder: (context, state) {
        if (lineItem.messages == null) {
          return Container();
        } else {
          return BlocBuilder<LineItemBloc, LineItemState>(
              builder: (context, state) {
            final messages = lineItem.messages.messages;

            return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  Message message = messages[index];
                  return _CardWidget(
                    message: message.message,
                  );
                },
              );
            });
          });
        }
      }))),
    );
  }
}

class _CardWidget extends StatelessWidget {
  final String message;
  //final Project project;

  _CardWidget({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 130,
      width: double.maxFinite,
      child: Card(
        color: Colors.teal[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 5,
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Stack(children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: <Widget>[
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 5, right: 10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  message,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  String getDate(Timestamp date) {
    String newDate = "";
    if (date != null) {
      newDate = Jiffy(date.toDate()).format("MMMM do");
    }
    return newDate;
  }
}
