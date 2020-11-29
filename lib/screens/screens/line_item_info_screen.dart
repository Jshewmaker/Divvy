import 'package:flutter/material.dart';

class LineItemInfoScreen extends StatelessWidget {
  LineItemInfoScreen(this.title);

  final String title;

  static const Color blueHighlight = const Color(0xFF3665FF);

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
                      text: title,
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[400],
                        fontSize: 24,
                      )),
                  TextSpan(
                      text: '\npool & spa services inc',
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
                          minLines: 10,
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
                            onPressed: () {},
                          ),
                          RaisedButton(
                            child: Text('Deny'),
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                            color: const Color(0xFFff0000),
                            textColor: Colors.white,
                            onPressed: () {},
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
