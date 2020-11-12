import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/blocs/kyb_blocs/register_business_cubit.dart';
import 'package:divvy/sila/models/kyb/register_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class RegisterKYBScreen extends StatelessWidget {
  RegisterKYBScreen({Key key}) : super(key: key);

  final SilaBusinessRepository _silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => RegisterKYBScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBusinessCubit(_silaBusinessRepository),
      child: BlocBuilder<RegisterBusinessCubit, RegisterBusinessState>(
        builder: (context, state) {
          if (state is RegisterBusinessInitial) {
            context.bloc<RegisterBusinessCubit>().registerBusinesss();
            return const RegisterBusinessEmpty();
          } else if (state is RegisterBusinessLoadInProgress) {
            return const RegisterBusinessLoading();
          } else if (state is RegisterBusinessLoadSuccess) {
            return RegisterBusinessPopulated(response: state.response);
          } else {
            return const RegisterBusinessError();
          }
        },
      ),
    );
  }
}

class RegisterBusinessPopulated extends StatelessWidget {
  RegisterBusinessPopulated({Key key, @required this.response})
      : super(key: key);

  final KYBRegisterResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(response.message),
            RaisedButton(
                child: Text('Register Business Member'), onPressed: () => ''
                // Navigator.of(context).push(
                //             MaterialPageRoute(
                //                 builder: (contest) => RegisterHandleScreenState(
                //                     handle: _textController.text))),
                )
          ],
        ),
      ),
    );
  }
}

class RegisterBusinessEmpty extends StatelessWidget {
  const RegisterBusinessEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(''),
      ),
    );
  }
}

class RegisterBusinessLoading extends StatelessWidget {
  const RegisterBusinessLoading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Process Loading.'),
      ),
    );
  }
}

class RegisterBusinessError extends StatelessWidget {
  const RegisterBusinessError({Key key}) : super(key: key);

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
