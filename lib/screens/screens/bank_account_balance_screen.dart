import 'package:divvy/sila/blocs/get_bank_account_balance.dart';
import 'package:divvy/sila/models/bank_account_balance_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class BankAccountInfoScreen extends StatelessWidget {
  BankAccountInfoScreen({Key key}) : super(key: key);

  SilaRepository _silaBusinessRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => BankAccountInfoScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankAccountBalanceCubit(_silaBusinessRepository),
      child: BlocBuilder<BankAccountBalanceCubit, BankAccountBalanceState>(
        builder: (context, state) {
          if (state is BankAccountBalanceInitial) {
            context.watch<BankAccountBalanceCubit>().getBankAccountBalances();
            return const BankAccountEmpty();
          } else if (state is BankAccountBalanceLoadInProgress) {
            return const BankAccountLoading();
          } else if (state is BankAccountBalanceLoadSuccess) {
            return BankAccountPopulated(
                response: state.bankAccountBalanceResponse);
          } else {
            return const BankAccountError();
          }
        },
      ),
    );
  }
}

class BankAccountPopulated extends StatelessWidget {
  const BankAccountPopulated({Key key, @required this.response})
      : super(key: key);

  final BankAccountBalanceResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(response.accountName),
            Text(response.availableBalance.toString()),
            Text(response.currentBalance.toString()),
          ],
        ),
      ),
    );
  }
}

class BankAccountEmpty extends StatelessWidget {
  const BankAccountEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('No process running.'),
      ),
    );
  }
}

class BankAccountLoading extends StatelessWidget {
  const BankAccountLoading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Process Loading.'),
      ),
    );
  }
}

class BankAccountError extends StatelessWidget {
  const BankAccountError({Key key}) : super(key: key);

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
