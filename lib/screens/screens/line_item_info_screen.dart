import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LineItemInfoScreen extends StatelessWidget {
  LineItemInfoScreen(this.lineItem);

  final LineItem lineItem;

  static const Color blueHighlight = const Color(0xFF3665FF);

  final TextEditingController _controller = TextEditingController();

  FirebaseService _firebaseService = FirebaseService();

  void approve() {
    Timestamp value = Timestamp.now();
    Map<String, Timestamp> firebaseData;

    firebaseData = {"homeowner_approval_date": value};

    _firebaseService.addDataToFirestoreDocument('projects', firebaseData);
  }

  void deny() {
    Map<String, Timestamp> firebaseData;
    firebaseData = {
      "general_contractor_approval_date": null,
    };
    _firebaseService.addDataToFirestoreDocument('projects', firebaseData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: RichText(
              text: new TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                children: <TextSpan>[
                  new TextSpan(
                      text: lineItem.title,
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[400],
                        fontSize: 24,
                      )),
                  TextSpan(
                      text: lineItem
                          .subContractor, // '\npool & spa services inc',
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        height: 300,
                        width: double.maxFinite,
                        child: Card(
                          color: Colors.teal[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          elevation: 5,
                          child: Center(
                            child: Text('Picture Placeholder'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 15,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: 'Comments',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => _controller.clear(),
                              icon: Icon(Icons.send, color: Colors.black45),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RaisedButton(
                            child: Text('Approve'),
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                            color: const Color(0xFF1E90FF),
                            textColor: Colors.white,
                            onPressed: () {
                              approve();
                            },
                          ),
                          RaisedButton(
                            child: Text('Deny'),
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                            color: const Color(0xFFff0000),
                            textColor: Colors.white,
                            onPressed: () {
                              deny();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
