import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/issue_sila_screen.dart';
import 'package:divvy/screens/screens/redeem_sila_screen.dart';
import 'package:divvy/sila/blocs/issue_sila/issue_sila.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetSilaBalanceBloc(silaRepository: silaRepository),
        ),
        BlocProvider(
          create: (context) => IssueSilaBloc(silaRepository: silaRepository),
        )
      ],
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
    double amountSila;
    amountSila = (response.silaBalance.round()) / 100;
    var user = context.watch<UserModelProvider>();
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Text(
          '\$' + amountSila.toString(),
          style: TextStyle(
              color: Colors.teal, fontSize: 48, fontWeight: FontWeight.bold),
        ),
        Text(
          'Account Balance',
          style: TextStyle(
              color: Colors.teal, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: user.user.isHomeowner,
              child: RaisedButton(
                child: Text("Add Money"),
                shape: (RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                color: const Color(0xFF1E90FF),
                textColor: Colors.white,
                onPressed: () async {
                  final amount = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IssueSilaScreen()));
                  if (amount != null) {
                    BlocProvider.of<IssueSilaBloc>(context)
                        .add(IssueSilaRequest(amount: double.parse(amount)));
                  }

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (contest) => IssueSilaScreen()));
                },
              ),
            ),
            Visibility(
              visible: user.user.isHomeowner == false,
              child: RaisedButton(
                child: Text('Send Money to Bank'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        RedeemSilaScreen(amount: amountSila.round()))),
              ),
            ),
          ],
        ),
      ],
    )));
  }
}
