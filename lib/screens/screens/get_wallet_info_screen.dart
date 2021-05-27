import 'package:divvy/sila/blocs/get_sila_balance/get_sila_balance.dart';
import 'package:divvy/sila/blocs/get_sila_balance/get_sila_balance_bloc.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class GetWalletInfoScreen extends StatelessWidget {
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
                //BlocProvider.of<GetSilaBalanceBloc>(context)
                //    .add(GetSilaBalanceRequest(user));
                return Container();
              }
              if (state is GetSilaBalanceLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is GetSilaBalanceLoadSuccess) {
                final apiResponse = state.userSilaResponse;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(apiResponse.silaBalance.toString()),
                  ],
                );
              }
              if (state is GetSilaBalanceLoadFailure) {
                return Text(
                  'Something went wrong with sila_balance! ${state.exception.toString()}',
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
