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
import 'package:path/path.dart';

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
                          .add(GetSilaBalanceRequest(user.user));
                      return Container();
                    }
                    if (state is GetSilaBalanceLoadInProgress) {
                      return WalletScreenInitial(
                        user: user.user,
                      );
                    }
                    if (state is GetSilaBalanceLoadSuccess) {
                      if (state.projectSilaResponse != null) {
                        return WalletScreenPopulated(
                          userSilaResponse: state.userSilaResponse,
                          projectSilaResponse: state.projectSilaResponse,
                          user: user.user,
                        );
                      } else {
                        return WalletScreenPopulated(
                          userSilaResponse: state.userSilaResponse,
                          user: user.user,
                        );
                      }
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
    return Column(children: [
      SizedBox(
        height: 20,
      ),
      Center(
          child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              child: BalanceCard(
                  amountSila: 0,
                  title: "Project",
                  buttonVisible: user.isHomeowner,
                  user: user))),
      Visibility(
        visible: !user.isHomeowner,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
                child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: BalanceCard(
                        amountSila: 0,
                        title: "Your",
                        buttonVisible: true,
                        user: user))),
          ],
        ),
      ),
    ]);
  }
}

class WalletScreenPopulated extends StatelessWidget {
  WalletScreenPopulated(
      {Key key,
      @required this.userSilaResponse,
      this.projectSilaResponse,
      this.user})
      : super(key: key);

  final GetSilaBalanceResponse userSilaResponse;
  final GetSilaBalanceResponse projectSilaResponse;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    double amountUserSila, amountProjectSila;
    amountUserSila = (userSilaResponse.silaBalance.roundToDouble()) / 100;
    if (projectSilaResponse != null) {
      amountProjectSila =
          (projectSilaResponse.silaBalance.roundToDouble()) / 100;
    } else {
      amountProjectSila = 0.0;
    }

    return Column(children: [
      SizedBox(
        height: 20,
      ),
      Center(
          child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              child: BalanceCard(
                  amountSila: amountProjectSila,
                  title: "Project",
                  buttonVisible: user.isHomeowner,
                  user: user))),
      Visibility(
        visible: !user.isHomeowner,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
                child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: BalanceCard(
                        amountSila: amountUserSila,
                        title: "Your",
                        buttonVisible: true,
                        user: user))),
          ],
        ),
      ),
    ]);
  }
}

class BalanceCard extends StatelessWidget {
  BalanceCard(
      {Key key, this.amountSila, this.title, this.buttonVisible, this.user});

  final double amountSila;
  final String title;
  final bool buttonVisible;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            title + ' Balance',
            style: TextStyle(
              color: Colors.teal[400],
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            NumberFormat.currency(symbol: '\$').format(amountSila),
            style: TextStyle(
              color: Colors.teal[400],
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Visibility(
            visible: buttonVisible,
            child: _button(context, user.isHomeowner, amountSila),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  RaisedButton _button(
      BuildContext context, bool isHomeowner, double amountSila) {
    if (isHomeowner) {
      return RaisedButton(
        child: Text("Add Money"),
        shape:
            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        color: const Color(0xFF1E90FF),
        textColor: Colors.white,
        onPressed: () async {
          final amount = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => IssueSilaScreen()));

          if (amount != null) {
            BlocProvider.of<IssueSilaBloc>(context)
                .add(IssueSilaRequest(amount: double.parse(amount)));
          }

          // Navigator.of(context).push(MaterialPageRoute(

          //     builder: (contest) => IssueSilaScreen()));
        },
      );
    } else {
      return RaisedButton(
          child: Text('Transfer to Bank'),
          shape:
              (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          color: const Color(0xFF1E90FF),
          textColor: Colors.white,
          onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => RedeemSilaScreen(

                          //TODO: where do we wanna do all of the sila converting

                          amount: (amountSila * 100).round())),
                )
              });
    }
  }
}
