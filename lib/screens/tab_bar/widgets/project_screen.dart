import 'package:divvy/screens/screens/line_item_info_screen.dart';
import 'package:flutter/material.dart';

class ProjectScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProjectScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        _CardWidget(
            title: 'Dig Hole for Pool',
            date: 'November 20, 2020',
            price: '\$1000'),
        _CardWidget(
            title: 'Install Rebar', date: 'November 23, 2020', price: '\$1500'),
        _CardWidget(
            title: 'Plumbing & Electrical',
            date: 'November 24, 2020',
            price: '\$750'),
        _CardWidget(
            title: 'Pour Concrete', date: 'November 28, 2020', price: '\$3000'),
        _CardWidget(
            title: 'Tile & Decking',
            date: 'December 10, 2020',
            price: '\$1700'),
        _CardWidget(
            title: 'Interior Finishing',
            date: 'December 13, 2020',
            price: '\$1000'),
        _CardWidget(
            title: 'Pool Start-Up', date: 'November 17, 2020', price: '\$800'),
      ],
    ));
  }
}

class _CardWidget extends StatelessWidget {
  final String title;
  final String price;
  final String date;

  _CardWidget({Key key, this.title, this.date, this.price}) : super(key: key);

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
                          padding: const EdgeInsets.only(left: 10, top: 5),
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
                                    date,
                                    style: TextStyle(color: Colors.grey[100]),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    price,
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
}
