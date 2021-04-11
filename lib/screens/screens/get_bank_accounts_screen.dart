import 'package:divvy/sila/blocs/get_bank_account_balance.dart';
import 'package:divvy/sila/blocs/get_bank_accounts_cubit.dart';
import 'package:divvy/sila/models/bank_account_balance_response.dart';
import 'package:divvy/sila/models/get_bank_accounts_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
      create: (context) => GetBankAccountsCubit(_silaBusinessRepository),
      child: BlocBuilder<GetBankAccountsCubit, GetBankAccountsState>(
        builder: (context, state) {
          if (state is GetBankAccountsInitial) {
            //changed to watch from read
            context.watch<GetBankAccountsCubit>().getGetBankAccountss();
            return const BankAccountEmpty();
          } else if (state is GetBankAccountsLoadInProgress) {
            return const BankAccountLoading();
          } else if (state is GetBankAccountsLoadSuccess) {
            return BankAccountPopulated(response: state.bankAccountResponse);
          } else {
            return const BankAccountError();
          }
        },
      ),
    );
  }
}

// class BankAccountPopulated extends StatelessWidget {
//   const BankAccountPopulated({Key key, @required this.response})
//       : super(key: key);

//   final BankAccountBalanceResponse response;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: [
//             Text(response.accountName),
//             Text(response.availableBalance.toString()),
//             Text(response.currentBalance.toString()),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BankAccountPopulated extends StatelessWidget {
  BankAccountPopulated({
    Key key,
    @required this.response,
  }) : super(key: key);

  final GetBankAccountsResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bank Accounts'),
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              response.accountNumber,
              style: TextStyle(
                  color: Colors.teal[400],
                  fontSize: 48,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        )));
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
