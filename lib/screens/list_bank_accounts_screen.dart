import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/blocs/get_bank_accounts/get_bank_accounts.dart';
import 'package:divvy/sila/blocs/get_bank_accounts/get_bank_accounts_bloc.dart';
import 'package:divvy/sila/models/bank_accounts_entity.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ListBankAccountsScreen extends StatelessWidget {
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetBankAccountsBloc(silaRepository: silaRepository),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<GetBankAccountsBloc, GetBankAccountsState>(
            builder: (context, state) {
              if (state is GetBankAccountsInitial) {
                BlocProvider.of<GetBankAccountsBloc>(context)
                    .add(GetBankAccountsRequest());
                return Container();
              }
              if (state is GetBankAccountsLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is GetBankAccountsLoadSuccess) {
                final apiResponse = state.response;
                if (apiResponse.bankAccounts.length == 0) {
                  return NoTransactions();
                }

                return PopulatedWidget(
                  accounts: apiResponse,
                );
              }
              if (state is GetBankAccountsLoadFailure) {
                return Text(
                  'Something went wrong with getting your accounts!',
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

class NoTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text(
        'No Accounts Linked',
        style: TextStyle(color: Colors.grey[400]),
      ),
    ));
  }
}

class PopulatedWidget extends StatelessWidget {
  final ListOfBankAccountEntities accounts;

  PopulatedWidget({
    Key key,
    @required this.accounts,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
      itemCount: accounts.bankAccounts.length,
      separatorBuilder: (BuildContext context, int index) => Divider(height: 3),
      itemBuilder: (context, index) {
        return _Card(accounts, index);
      },
    ));
  }
}

class _Card extends StatelessWidget {
  _Card(
    this._accounts,
    this.index,
  );
  final ListOfBankAccountEntities _accounts;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: GestureDetector(
        onTap: () => {
          //TODO
        },
        child: Card(
          elevation: 0,
          color: Colors.grey[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          _accounts.bankAccounts[index].accountName,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
