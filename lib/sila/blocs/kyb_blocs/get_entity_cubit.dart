import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/get_entity/get_entity_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class GetEntityState {}

class GetEntityInitial extends GetEntityState {}

class GetEntityLoadInProgress extends GetEntityState {}

class GetEntityLoadSuccess extends GetEntityState {
  GetEntityLoadSuccess(this.getEntity);

  final GetEntityResponse getEntity;
}

class GetEntityLoadFailure extends GetEntityState {}

class GetEntityCubit extends Cubit<GetEntityState> {
  GetEntityCubit(this._silaBusinessRepository) : super(GetEntityInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> getGetEntity() async {
    emit(GetEntityLoadInProgress());
    try {
      GetEntityResponse getEntity = await _silaBusinessRepository.getEntity();
      emit(GetEntityLoadSuccess(getEntity));
    } catch (_) {
      emit(GetEntityLoadFailure());
    }
  }
}
