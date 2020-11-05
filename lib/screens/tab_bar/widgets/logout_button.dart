import 'package:divvy/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';

Widget logout(
  context,
) {
  return IconButton(
    key: const Key('homePage_logout_iconButton'),
    icon: const Icon(Icons.more_vert),
    onPressed: () =>
        context.bloc<AuthenticationBloc>().add(AuthenticationLogoutRequested()),
  );
}
