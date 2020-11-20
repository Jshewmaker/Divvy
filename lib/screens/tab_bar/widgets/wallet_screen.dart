import 'package:divvy/sila/models/models.dart';
import 'package:flutter/material.dart';

import 'package:divvy/sila/blocs/get_sila_balance/get_sila_balance.dart';
import 'package:divvy/sila/blocs/get_sila_balance/get_sila_balance_bloc.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class WalletScreen extends StatelessWidget {
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetSilaBalanceBloc(silaRepository: silaRepository),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<GetSilaBalanceBloc, GetSilaBalanceState>(
            builder: (context, state) {
              if (state is GetSilaBalanceInitial) {
                BlocProvider.of<GetSilaBalanceBloc>(context)
                    .add(GetSilaBalanceRequest());
                return Container();
              }
              if (state is GetSilaBalanceLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is GetSilaBalanceLoadSuccess) {
                return WalletScreenPopulated(response: state.response);
              }
              if (state is GetSilaBalanceLoadFailure) {
                return Text(
                  'Something went wrong with sila_balance!',
                  style: TextStyle(color: Colors.red),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class WalletScreenPopulated extends StatelessWidget {
  WalletScreenPopulated({Key key, @required this.response}) : super(key: key);

  final GetSilaBalanceResponse response;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              '\$' + response.silaBalance.toString(),
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 48,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Account Balance',
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                ),
                Text(
                  "Balance Breakdown",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.teal, fontSize: 18),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _CardWidget(
                      title: 'Dig Hole for Pool',
                      date: 'November 20, 2020',
                      price: '\$1000'),
                  _CardWidget(
                      title: 'Install Rebar',
                      date: 'November 23, 2020',
                      price: '\$1500'),
                  _CardWidget(
                      title: 'Plumbing & Electrical',
                      date: 'November 24, 2020',
                      price: '\$750'),
                  _CardWidget(
                      title: 'Pour Concrete',
                      date: 'November 28, 2020',
                      price: '\$3000'),
                  _CardWidget(
                      title: 'Tile & Decking',
                      date: 'December 10, 2020',
                      price: '\$1700'),
                  _CardWidget(
                      title: 'Interior Finishing',
                      date: 'December 13, 2020',
                      price: '\$1000'),
                  _CardWidget(
                      title: 'Pool Start-Up',
                      date: 'November 17, 2020',
                      price: '\$800'),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
      height: 103,
      width: double.maxFinite,
      child: Card(
        color: Colors.teal[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 5,
        child: InkWell(
          onTap: () => "",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    price,
                                    style: TextStyle(color: Colors.black45),
                                    textAlign: TextAlign.right,
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
