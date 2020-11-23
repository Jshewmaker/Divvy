import 'package:divvy/screens/screens/kyb_screens/certify_business_screen.dart';
import 'package:divvy/sila/blocs/kyb_blocs/certify_beneficial_owner_cubit.dart';
import 'package:divvy/sila/models/kyb/certify_business_owner_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CertifyBuisnessOwnerScreen extends StatelessWidget {
  final token;
  CertifyBuisnessOwnerScreen(this.token, {Key key}) : super(key: key);

  final SilaBusinessRepository _silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CertifyBeneficialOwnerCubit(_silaBusinessRepository),
      child:
          BlocBuilder<CertifyBeneficialOwnerCubit, CertifyBeneficialOwnerState>(
        builder: (context, state) {
          if (state is CertifyBeneficialOwnerInitial) {
            context
                .bloc<CertifyBeneficialOwnerCubit>()
                .certifyBeneficialOwners(token);
            return const ResponseEmpty();
          } else if (state is CertifyBeneficialOwnerLoadInProgress) {
            return const ResponseLoading();
          } else if (state is CertifyBeneficialOwnerLoadSuccess) {
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

  final CertifyBeneficialOwnerResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(response.message),
            RaisedButton(
              child: Text('Certify Business'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contest) => CertifyBuisnessScreen())),
            )
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
