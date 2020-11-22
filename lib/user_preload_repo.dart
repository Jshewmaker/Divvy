import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';

abstract class TodosRepository {
  Stream<UserModel> user();
}
