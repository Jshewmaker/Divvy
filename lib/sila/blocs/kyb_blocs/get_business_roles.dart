import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/kyb/get_business_roles_response/get_business_roles_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class GetBusinessRolesState {}

class GetBusinessRolesInitial extends GetBusinessRolesState {}

class GetBusinessRolesLoadInProgress extends GetBusinessRolesState {}

class GetBusinessRolesLoadSuccess extends GetBusinessRolesState {
  GetBusinessRolesLoadSuccess(this.response);

  final GetBusinessRolesResponse response;
}

class GetBusinessRolesLoadFailure extends GetBusinessRolesState {}

class GetBusinessRolesCubit extends Cubit<GetBusinessRolesState> {
  GetBusinessRolesCubit(this._silaBusinessRepository)
      : super(GetBusinessRolesInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> getBusinessRoles() async {
    emit(GetBusinessRolesLoadInProgress());
    try {
      final response = await _silaBusinessRepository.getBusinessRoles();
      emit(GetBusinessRolesLoadSuccess(response));
    } catch (_) {
      emit(GetBusinessRolesLoadFailure());
    }
  }
}
