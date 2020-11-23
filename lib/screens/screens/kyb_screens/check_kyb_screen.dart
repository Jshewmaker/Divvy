import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/kyb_screens/register_business_admin_screen.dart';
import 'package:divvy/sila/blocs/kyb_blocs/check_kyb_cubit.dart';
import 'package:divvy/sila/blocs/kyb_blocs/register_business_cubit.dart';
import 'package:divvy/sila/models/kyb/check_kyb_response/check_kyb_response.dart';
import 'package:divvy/sila/models/kyb/register_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CheckKYBScreen extends StatelessWidget {
  CheckKYBScreen({Key key}) : super(key: key);

  final SilaBusinessRepository _silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckKYBCubit(_silaBusinessRepository),
      child: BlocBuilder<CheckKYBCubit, CheckKYBState>(
        builder: (context, state) {
          if (state is CheckKYBInitial) {
            context.bloc<CheckKYBCubit>().checkKYB();
            return const CheckKYBEmpty();
          } else if (state is CheckKYBLoadInProgress) {
            return const CheckKYBLoading();
          } else if (state is CheckKYBLoadSuccess) {
            return CheckKYBPopulated(response: state.checkKYB);
          } else {
            return const CheckKYBError();
          }
        },
      ),
    );
  }
}

class CheckKYBPopulated extends StatelessWidget {
  CheckKYBPopulated({Key key, @required this.response}) : super(key: key);

  final CheckKybResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

class CheckKYBEmpty extends StatelessWidget {
  const CheckKYBEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(''),
      ),
    );
  }
}

class CheckKYBLoading extends StatelessWidget {
  const CheckKYBLoading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Process Loading.'),
      ),
    );
  }
}

class CheckKYBError extends StatelessWidget {
  const CheckKYBError({Key key}) : super(key: key);

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
