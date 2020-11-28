import 'package:divvy/sila/blocs/kyb_blocs/link_business_members_cubit.dart';
import 'package:divvy/sila/models/kyb/link_business_member_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class LinkBusinessMemberScreen extends StatelessWidget {
  LinkBusinessMemberScreen({Key key}) : super(key: key);

  final SilaBusinessRepository _silaBusinessRepository = SilaBusinessRepository(
      silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LinkBusinessMembersCubit(_silaBusinessRepository),
      child: BlocBuilder<LinkBusinessMembersCubit, LinkBusinessMembersState>(
        builder: (context, state) {
          if (state is LinkBusinessMembersInitial) {
            context.read<LinkBusinessMembersCubit>().getLinkBusinessMembers();
            return const RegisterBusinessEmpty();
          } else if (state is LinkBusinessMembersLoadInProgress) {
            return const RegisterBusinessLoading();
          } else if (state is LinkBusinessMembersLoadSuccess) {
            return RegisterBusinessPopulated(
                response: state.linkBusinessMembers);
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

  final List<LinkBusinessMemberResponse> response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(response[0].message),
          Text(response[1].message),
          Text(response[2].message),
        ],
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
