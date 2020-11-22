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
              'Account Balance: Phase 2',
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
                  "Project Breakdown By Phase",
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
                    title: 'Phase 1',
                    date: 'November 20, 2020',
                    price: '\$5000',
                    color: 100,
                  ),
                  _CardWidget(
                    title: 'Phase 2',
                    date: 'November 23, 2020',
                    price: '\$3000',
                    color: 100,
                  ),
                  _CardWidget(
                    title: 'Phase 3',
                    date: 'November 24, 2020',
                    price: '\$3750',
                    color: 400,
                  ),
                  _CardWidget(
                    title: 'Phase 4',
                    date: 'November 28, 2020',
                    price: '\$3000',
                    color: 400,
                  ),
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
  final int color;

  _CardWidget({Key key, this.title, this.date, this.price, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 133,
      width: double.maxFinite,
      child: Card(
        color: Colors.teal[color],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    date,
                                    style: TextStyle(color: Colors.grey[100]),
                                  ),
                                  if (color == 400)
                                    FlatButton(
                                      height: 20,
                                      child: Text(
                                        'Add Funds',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                      onPressed: () => "",
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
