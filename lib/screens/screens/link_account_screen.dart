import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/blocs/link_account/link_account_bloc.dart';
import 'package:divvy/sila/blocs/link_account/link_account_event.dart';
import 'package:divvy/sila/blocs/link_account/link_account_state.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class LinkAccountScreen extends StatelessWidget {
  final String token;
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));
  LinkAccountScreen({Key key, @required this.token}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LinkAccountBloc>(
      create: (context) => LinkAccountBloc(silaRepository: silaRepository),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<LinkAccountBloc, LinkAccountState>(
            builder: (context, state) {
              if (state is LinkAccountInitial) {
                BlocProvider.of<LinkAccountBloc>(context)
                    .add(LinkAccountRequest(plaidPublicToken: token));
              }
              if (state is LinkAccountLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LinkAccountLoadSuccess) {
                FirebaseService _firebaseService = FirebaseService();
                _firebaseService.addDataToFirestoreDocument(
                    'users', {"bankAccountIsConnected": true});
                Navigator.pop(context);
              }
              if (state is LinkAccountLoadFailure) {
                return Text(
                  'Failure: link account failure',
                  style: TextStyle(color: Colors.red),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
