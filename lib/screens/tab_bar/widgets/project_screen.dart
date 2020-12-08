import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divvy/bloc/line_items/line_item_bloc.dart';
import 'package:divvy/bloc/line_items/line_item_event.dart';
import 'package:divvy/bloc/line_items/line_item_state.dart';

import 'package:divvy/screens/screens/line_item_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

class ProjectScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProjectScreen());
  }

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LineItemBloc(firebaseService: _firebaseService),
      child: Scaffold(body: Center(
        child:
            BlocBuilder<LineItemBloc, LineItemState>(builder: (context, state) {
          if (state is LineItemInitial) {
            BlocProvider.of<LineItemBloc>(context)
                .add(LineItemRequested('YuDDy02bn2Gq3QzK6KNG', 1));
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
                    title: lineItem.title,
                    generalContractorApprovalDate:
                        getDate(lineItem.generalContractorApprovalDate),
                    homeOwnerApprovalDate:
                        getDate(lineItem.homeownerApprovalDate),
                    datePaid: getDate(lineItem.datePaid),
                    price: '\$' + lineItem.cost.toStringAsFixed(2));
              },
            );
          }
          if (state is LineItemLoadFailure) {
            return Text(
              'Something went wrong!',
              style: TextStyle(color: Colors.red),
            );
          }
          return Container();
        }),
      )),
    );
  }

  Future<LineItemListModel> getProjectLineItems() {
    FirebaseService _firebaseService = FirebaseService();
    return _firebaseService.getPhaseLineItems(1, 'YuDDy02bn2Gq3QzK6KNG');
  }

  String getDate(Timestamp date) {
    String newDate = "";
    if (date != null) {
      newDate = Jiffy(date.toDate()).format("MMMM do");
    }
    return newDate;
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
  final String title;
  final String price;
  final String generalContractorApprovalDate;
  final String homeOwnerApprovalDate;
  final String datePaid;

  _CardWidget(
      {Key key,
      this.title,
      this.generalContractorApprovalDate,
      this.homeOwnerApprovalDate,
      this.datePaid,
      this.price})
      : super(key: key);

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
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LineItemInfoScreen(title))),
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
                                    title,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    generalContractorApprovalDate,
                                    style: TextStyle(color: Colors.grey[100]),
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
                                    price,
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
    if (generalContractorApprovalDate != "") {
      if (homeOwnerApprovalDate != "") {
        if (datePaid != "") {
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
}
