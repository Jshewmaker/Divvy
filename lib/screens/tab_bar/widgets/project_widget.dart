import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/account/line_item_approval/line_item_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class ProjectWidget extends StatelessWidget {
  final UserModel user;
  final FirebaseService firebaseService = FirebaseService();

  ProjectWidget(
    this.user,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Project>(
        stream: firebaseService.streamRealtimeProject(user.projectID),
        builder: (BuildContext context, AsyncSnapshot<Project> project) {
          return StreamBuilder<LineItemListModel>(
            stream: firebaseService.streamRealtimeLineItems(user.projectID),
            builder: (BuildContext context,
                AsyncSnapshot<LineItemListModel> lineItemsList) {
              if (lineItemsList.hasError) {
                return Text('Something went wrong');
              }

              if (lineItemsList.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return new ListView(
                children: lineItemsList.data.lineItems.map((LineItem lineItem) {
                  return new _CardWidget(
                    lineItem: lineItem,
                    project: project.data,
                    user: user,
                  );
                }).toList(),
              );
            },
          );
        });
  }
}

class _CardWidget extends StatelessWidget {
  final LineItem lineItem;
  final Project project;
  final UserModel user;

  _CardWidget({
    Key key,
    this.lineItem,
    this.project,
    this.user,
  }) : super(key: key);

  Color _cardColor() {
    if (lineItem.dateDenied != null) {
      return Colors.red[400];
    } else if (lineItem.generalContractorApprovalDate != null) {
      if (lineItem.homeownerApprovalDate != null) {
        return Colors.teal[100];
      } else {
        return Colors.amber[400];
      }
    } else {
      return Colors.teal[200];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      width: double.maxFinite,
      child: Card(
        color: _cardColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 5,
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  LineItemInfoScreen(lineItem, project, user))),
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
                              left: 10, top: 5, right: 10, bottom: 5),
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

    if (lineItem.dateDenied != null) {
      status = "Denied";
    } else if (lineItem.generalContractorApprovalDate != null) {
      if (lineItem.homeownerApprovalDate != null) {
        status = "Paid";
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
