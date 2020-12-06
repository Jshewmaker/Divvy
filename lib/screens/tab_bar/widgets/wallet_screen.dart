import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/account/plaid_link_screen.dart';
import 'package:divvy/screens/screens/issue_sila_screen.dart';
import 'package:divvy/screens/screens/redeem_sila_screen.dart';
import 'package:divvy/sila/blocs/issue_sila/issue_sila.dart';
import 'package:divvy/sila/blocs/wallet_screen/wallet_screen_bloc.dart';
import 'package:divvy/sila/blocs/wallet_screen/wallet_screen_event.dart';
import 'package:divvy/sila/blocs/wallet_screen/wallet_screen_state.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:flutter/material.dart';

import 'package:divvy/sila/blocs/get_sila_balance/get_sila_balance.dart';
import 'package:divvy/sila/blocs/get_sila_balance/get_sila_balance_bloc.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserModelProvider>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetSilaBalanceBloc(silaRepository: silaRepository),
        ),
        BlocProvider(
          create: (context) => IssueSilaBloc(silaRepository: silaRepository),
        ),
        BlocProvider(create: (context) => WalletScreenBloc()),
      ],
      child: Scaffold(
        body: Center(
          child: BlocBuilder<WalletScreenBloc, WalletScreenState>(
            builder: (context, state) {
              if (state is WalletScreenInitialState) {
                BlocProvider.of<WalletScreenBloc>(context)
                    .add(WalletScreenCheck());
                return Container();
              }
              if (state is WalletScreenAccountNotLinked) {
                return PlaidLinkScreen();
              }
              if (state is WalletScreenHasAccountLinked) {
                return BlocBuilder<GetSilaBalanceBloc, GetSilaBalanceState>(
                  builder: (context, state) {
                    if (state is GetSilaBalanceInitial) {
                      BlocProvider.of<GetSilaBalanceBloc>(context)
                          .add(GetSilaBalanceRequest());
                      return Container();
                    }
                    if (state is GetSilaBalanceLoadInProgress) {
                      return WalletScreenInitial(
                        user: user.user,
                      );
                    }
                    if (state is GetSilaBalanceLoadSuccess) {
                      return WalletScreenPopulated(
                        response: state.response,
                        user: user.user,
                      );
                    }
                    if (state is GetSilaBalanceLoadFailure) {
                      return Text(
                        'Something went wrong with sila_balance!',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                    return Container();
                  },
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

class WalletScreenInitial extends StatelessWidget {
  WalletScreenInitial({Key key, this.user});

  final UserModel user;

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
          NumberFormat.currency(symbol: '\$').format(0),
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
              visible: user.isHomeowner,
              child: RaisedButton(
                child: Text("Add Money"),
                shape: (RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                color: const Color(0xFF1E90FF),
                textColor: Colors.white,
                onPressed: () async {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (contest) => IssueSilaScreen()));
                },
              ),
            ),
            Visibility(
              visible: user.isHomeowner == false,
              child: RaisedButton(
                color: const Color(0xFF1E90FF),
                shape: (RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                child: Text('Send Money to Bank'),
                onPressed: () => {},
              ),
            ),
          ],
        ),
      ],
    )));
  }
}

class WalletScreenPopulated extends StatelessWidget {
  WalletScreenPopulated({Key key, @required this.response, this.user})
      : super(key: key);

  final GetSilaBalanceResponse response;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    double amountSila;
    amountSila = (response.silaBalance.round()) / 100;

    return Scaffold(
        body: Center(
            child: Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Text(
          NumberFormat.currency(symbol: '\$').format(amountSila),
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
              visible: user.isHomeowner,
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
              visible: user.isHomeowner == false,
              child: RaisedButton(
                  child: Text('Send Money to Bank'),
                  shape: (RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                  color: const Color(0xFF1E90FF),
                  textColor: Colors.white,
                  onPressed: () => {
                        if (amountSila == 0)
                          {}
                        else
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RedeemSilaScreen(
                                  amount: amountSila.round()))),
                      }),
            ),
          ],
        ),
      ],
    )));
  }
}
