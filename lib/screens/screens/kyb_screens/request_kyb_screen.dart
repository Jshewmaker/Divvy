import 'package:divvy/sila/blocs/kyb_blocs/request_kyb_cubit.dart';
import 'package:divvy/sila/models/register_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class RequestKYBScreen extends StatelessWidget {
  RequestKYBScreen({Key key}) : super(key: key);

  final SilaBusinessRepository _silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestKYBCubit(_silaBusinessRepository),
      child: BlocBuilder<RequestKYBCubit, RequestKYBState>(
        builder: (context, state) {
          if (state is RequestKYBInitial) {
            context.read<RequestKYBCubit>().requestKYB();
            return const RequestKYBEmpty();
          } else if (state is RequestKYBLoadInProgress) {
            return const RequestKYBLoading();
          } else if (state is RequestKYBLoadSuccess) {
            return RequestKYBPopulated(response: state.requestKYB);
          } else {
            return const RequestKYBError();
          }
        },
      ),
    );
  }
}

class RequestKYBPopulated extends StatelessWidget {
  RequestKYBPopulated({Key key, @required this.response}) : super(key: key);

  final RegisterResponse response;

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

class RequestKYBEmpty extends StatelessWidget {
  const RequestKYBEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(''),
      ),
    );
  }
}

class RequestKYBLoading extends StatelessWidget {
  const RequestKYBLoading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Process Loading.'),
      ),
    );
  }
}

class RequestKYBError extends StatelessWidget {
  const RequestKYBError({Key key}) : super(key: key);

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
