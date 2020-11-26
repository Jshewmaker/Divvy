import 'package:divvy/sila/blocs/redeem_sila_cubit.dart';
import 'package:divvy/sila/models/redeem_sila_model.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class RedeemSilaScreen extends StatelessWidget {
  RedeemSilaScreen({Key key, @required this.amount}) : super(key: key);
  final int amount;
  final SilaRepository _silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RedeemSilaCubit(_silaRepository),
      child: BlocBuilder<RedeemSilaCubit, RedeemSilaState>(
        builder: (context, state) {
          if (state is RedeemSilaInitial) {
            context.bloc<RedeemSilaCubit>().redeemSila(amount);
            return const EmptyWidget();
          } else if (state is RedeemSilaLoadInProgress) {
            return const LoadingWidget();
          } else if (state is RedeemSilaLoadSuccess) {
            return PopulatedWidget(response: state.response);
          } else {
            return const ErrorWidget();
          }
        },
      ),
    );
  }
}

class PopulatedWidget extends StatelessWidget {
  PopulatedWidget({Key key, @required this.response}) : super(key: key);

  final RedeemSilaModel response;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(response.message),
              // RaisedButton(
              //   child: Text('Register Business Member'),
              //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              //       builder: (contest) => RegisterBusinessAdminScreen())),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(''),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Process Loading.'),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '🙈',
          style: TextStyle(fontSize: 64),
        ),
        Text(
          'Something went wrong!',
          style: theme.textTheme.headline5,
        ),
      ],
    );
  }
}
