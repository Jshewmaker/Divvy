import 'package:divvy/screens/screens/kyb_screens/certify_beneficial_owner_screen.dart';
import 'package:divvy/sila/blocs/kyb_blocs/get_entity_cubit.dart';
import 'package:divvy/sila/models/get_entity/get_entity_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class GetEntityScreen extends StatelessWidget {
  GetEntityScreen({Key key}) : super(key: key);

  final SilaBusinessRepository _silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetEntityCubit(_silaBusinessRepository),
      child: BlocBuilder<GetEntityCubit, GetEntityState>(
        builder: (context, state) {
          if (state is GetEntityInitial) {
            context.watch<GetEntityCubit>().getGetEntity();
            return const GetEntityEmpty();
          } else if (state is GetEntityLoadInProgress) {
            return const GetEntityLoading();
          } else if (state is GetEntityLoadSuccess) {
            return GetEntityPopulated(response: state.getEntity);
          } else {
            return const GetEntityError();
          }
        },
      ),
    );
  }
}

class GetEntityPopulated extends StatelessWidget {
  GetEntityPopulated({Key key, @required this.response}) : super(key: key);

  final GetEntityResponse response;

  @override
  Widget build(BuildContext context) {
    String token = getToken(response);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(token),
            RaisedButton(
              child: Text('Certify Business Owner'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contest) => CertifyBuisnessOwnerScreen(token))),
            )
          ],
        ),
      ),
    );
  }

  String getToken(GetEntityResponse response) {
    String token;
    int i = 0;

    do {
      if (response.memberships[i].certificationToken != null) {
        return response.memberships[i].certificationToken;
      }
      i++;
    } while (i < response.memberships.length);
    return token;
  }
}

class GetEntityEmpty extends StatelessWidget {
  const GetEntityEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(''),
      ),
    );
  }
}

class GetEntityLoading extends StatelessWidget {
  const GetEntityLoading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Process Loading.'),
      ),
    );
  }
}

class GetEntityError extends StatelessWidget {
  const GetEntityError({Key key}) : super(key: key);

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
