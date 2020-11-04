import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:divvy/tab_bar/screens/get_wallet_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class IssueSilaScreen extends StatelessWidget {
  final String collection = "users";
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IssueSilaBloc(silaRepository: silaRepository),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Center(
                child: BlocBuilder<IssueSilaBloc, IssueSilaState>(
                  builder: (context, state) {
                    if (state is IssueSilaInitial) {
                      BlocProvider.of<IssueSilaBloc>(context)
                          .add(IssueSilaRequest());
                      return Container();
                    }
                    if (state is IssueSilaLoadInProgress) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is IssueSilaLoadSuccess) {
                      final apiResponse = state.response;
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(apiResponse.message),
                          ],
                        ),
                      );
                    }
                    if (state is IssueSilaLoadFailure) {
                      return Text(
                        'Something went wrong with issue_sila!',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
