import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:divvy/app.dart';
import 'package:divvy/simple_bloc_observer.dart';
import 'package:http/http.dart' as http;

import 'flavor_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();

  final SilaRepository checkHandleRepository = SilaRepository(
    silaApiClient: SilaApiClient(
      httpClient: http.Client(),
    ),
  );

//  final FirebaseService firebaseService = FirebaseService();
  FlavorConfig(
      flavor: Flavor.DEV,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(isPlaidSandbox: true));

  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    silaRepository: checkHandleRepository,
    firebaseService: FirebaseService(),
  ));
}
