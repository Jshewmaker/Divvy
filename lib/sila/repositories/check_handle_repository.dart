import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:flutter/material.dart';

class CheckHandleRepository {
  final SilaApiClient silaApiClient;

  CheckHandleRepository({@required this.silaApiClient})
      : assert(silaApiClient != null);

  Future<CheckHandle> checkHandle(String handle) async {
    final CheckHandle checkHandle = await silaApiClient.checkHandle(handle);
    return checkHandle;
  }
}
