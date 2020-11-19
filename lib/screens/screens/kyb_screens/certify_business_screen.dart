import 'package:divvy/sila/blocs/kyb_blocs/certify_business_cubit.dart';
import 'package:divvy/sila/models/kyb/certify_business_owner_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CertifyBuisnessScreen extends StatelessWidget {
  CertifyBuisnessScreen({Key key}) : super(key: key);

  final SilaBusinessRepository _silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CertifyBusinessCubit(_silaBusinessRepository),
      child: BlocBuilder<CertifyBusinessCubit, CertifyBusinessState>(
        builder: (context, state) {
          if (state is CertifyBusinessInitial) {
            context.bloc<CertifyBusinessCubit>().certifyBusinesss();
            return const ResponseEmpty();
          } else if (state is CertifyBusinessLoadInProgress) {
            return const ResponseLoading();
          } else if (state is CertifyBusinessLoadSuccess) {
            return ResponsePopulated(response: state.response);
          } else {
            return const ResponseError();
          }
        },
      ),
    );
  }
}

class ResponsePopulated extends StatelessWidget {
  ResponsePopulated({Key key, @required this.response}) : super(key: key);

  final CertifyBusinessOwnerResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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

class ResponseEmpty extends StatelessWidget {
  const ResponseEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(''),
      ),
    );
  }
}

class ResponseLoading extends StatelessWidget {
  const ResponseLoading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Process Loading.'),
      ),
    );
  }
}

class ResponseError extends StatelessWidget {
  const ResponseError({Key key}) : super(key: key);

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
