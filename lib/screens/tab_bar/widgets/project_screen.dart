import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/bloc/line_items/line_item_bloc.dart';
import 'package:divvy/bloc/line_items/line_item_event.dart';
import 'package:divvy/bloc/line_items/line_item_state.dart';
import 'package:divvy/bloc/project/project_bloc.dart';
import 'package:divvy/bloc/project/project_event.dart';
import 'package:divvy/bloc/project/project_state.dart';
import 'package:divvy/screens/screens/account/line_item_approval/line_item_info_screen.dart';
import 'package:divvy/screens/screens/connect_to_project.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

class ProjectScreen extends StatelessWidget {
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
            BlocProvider.of<ProjectBloc>(context).add(CheckForProject());
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
            Project project = state.project;
            BlocProvider.of<LineItemBloc>(context).add(LineItemRequested(1));
            return BlocListener<LineItemBloc, LineItemState>(
              listener: (context, state) {
                if (state is LineItemLoadFailure) {
                  final snackBar = SnackBar(
                      content: Text(
                          'Something went wrong with loading line items!'));
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              },
              child: BlocBuilder<LineItemBloc, LineItemState>(
                  builder: (context, state) {
                if (state is LineItemInitial) {
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.teal[300]),
                  ));
                }
                if (state is LineItemLoadInProgress) {
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.teal[300]),
                  ));
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
                return ConnectToProject();
              }),
            );
          }
          return ConnectToProject();
        }),
      ))),
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

  Color _cardColor() {
    if (lineItem.generalContractorApprovalDate != null) {
      if (lineItem.homeownerApprovalDate != null) {
        if (lineItem.datePaid != null) {
          return Colors.teal[100];
          //status = Paid
        } else {
          return Colors.teal[200];
          //status = Payment Needed
        }
      } else {
        return Colors.amber[400];
        //status = Approval Needed
      }
    } else {
      return Colors.teal[200];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 130,
      width: double.maxFinite,
      child: Card(
        color: _cardColor(),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  lineItem.title,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Text(
                                getDate(lineItem.expectedFinishDate),
                                style: TextStyle(color: Colors.grey[100]),
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

  String getDate(DateTime date) {
    String newDate = "";
    if (date != null) {
      newDate = Jiffy(date).format("MMMM do");
    }
    return newDate;
  }
}
