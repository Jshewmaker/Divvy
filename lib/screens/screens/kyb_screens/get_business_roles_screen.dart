import 'package:divvy/sila/blocs/kyb_blocs/get_business_roles.dart';
import 'package:divvy/sila/models/kyb/get_business_roles_response/get_business_roles_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class GetBusinessRolesScreen extends StatelessWidget {
  GetBusinessRolesScreen({Key key}) : super(key: key);

  final SilaBusinessRepository _silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetBusinessRolesCubit(_silaBusinessRepository),
      child: BlocBuilder<GetBusinessRolesCubit, GetBusinessRolesState>(
        builder: (context, state) {
          if (state is GetBusinessRolesInitial) {
            context.read<GetBusinessRolesCubit>().getBusinessRoles();
            return const RegisterBusinessEmpty();
          } else if (state is GetBusinessRolesLoadInProgress) {
            return const RegisterBusinessLoading();
          } else if (state is GetBusinessRolesLoadSuccess) {
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

  final GetBusinessRolesResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(response.businessRoles[0].label),
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
