import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divvy/bloc/line_items/line_item_bloc.dart';
import 'package:divvy/screens/screens/account/line_item_approval/line_item_approval_screen.dart';
import 'package:divvy/bloc/line_items/line_item_event.dart';
import 'package:divvy/bloc/line_items/line_item_state.dart';
import 'package:divvy/bloc/project/project_bloc.dart';
import 'package:divvy/bloc/project/project_event.dart';
import 'package:divvy/bloc/project/project_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

class ProjectScreen extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  String projectID = 'YuDDy02bn2Gq3QzK6KNG';

  final FirebaseService _firebaseService = FirebaseService();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProjectScreen());
  }

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
        if (state is ProjectInitial) {
          BlocProvider.of<ProjectBloc>(context).add(ProjectInitialEvent());
          return Container();
        }
        if (state is ProjectLoadInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProjectNotConnected) {
          return Form(
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
                          BlocProvider.of<ProjectBloc>(context)
                              .add(ProjectRequested(
                            _textController.text.trim(),
                          ));
                        }
                      })
                ],
              ),
            ),
          );
        }
        if (state is ProjectLoadSuccess) {
          Project project = state.project;
          return BlocBuilder<LineItemBloc, LineItemState>(
              builder: (context, state) {
            if (state is LineItemInitial) {
              BlocProvider.of<LineItemBloc>(context).add(LineItemRequested(1));
              return Container();
            }
            if (state is LineItemLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is LineItemLoadSuccess) {
              final lineItems = state.lineItems;

              return ListView.builder(
                itemCount: lineItems.lineItems.length,
                itemBuilder: (context, index) {
                  LineItem lineItem = lineItems.lineItems[index];
                  return _CardWidget(
                    lineItem: lineItem,
                    project: project,
                  );
                },
              );
            }
            if (state is LineItemLoadFailure) {
              return Text(
                'Something went wrong with loading line items!',
                style: TextStyle(color: Colors.red),
              );
            }
            return Container();
          });
        }
        if (state is ProjectLoadFailure) {
          return Text(
            'Something went wrong with loading project!',
            style: TextStyle(color: Colors.red),
          );
        }
        return Container();
      }))),
    );
  }
}

class _NoProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Link Project'),
        onPressed: () {},
      ),
    );
  }
}

class _CardWidget extends StatelessWidget {
  final LineItem lineItem;
  final Project project;

  _CardWidget({
    Key key,
    this.lineItem,
    this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 130,
      width: double.maxFinite,
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 5,
        child: InkWell(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => LineItemInfoScreen(lineItem, project)))
              .then((value) => {
                    BlocProvider.of<LineItemBloc>(context)
                        .add(LineItemRequested(1))
                  }),
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(7),
              child: Stack(children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, right: 10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    lineItem.title,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    getDate(
                                        lineItem.generalContractorApprovalDate),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '\$' + lineItem.cost.toStringAsFixed(2),
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  Text(
                                    getStatus(),
                                    style: TextStyle(color: Colors.black45),
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
      ),
    );
  }

  String getStatus() {
    String status = "";
    if (lineItem.generalContractorApprovalDate != null) {
      if (lineItem.homeownerApprovalDate != null) {
        if (lineItem.datePaid != null) {
          status = "Paid";
        } else {
          status = "Payment Needed";
        }
      } else {
        status = "Approval Needed";
      }
    }

    return status;
  }

  String getDate(Timestamp date) {
    String newDate = "";
    if (date != null) {
      newDate = Jiffy(date.toDate()).format("MMMM do");
    }
    return newDate;
  }
}
