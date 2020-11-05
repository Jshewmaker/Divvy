import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/kyb/naics_categories_models/get_naics_categories_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class NaicsCategoriesState {}

class NaicsCategoriesInitial extends NaicsCategoriesState {}

class NaicsCategoriesLoadInProgress extends NaicsCategoriesState {}

class NaicsCategoriesLoadSuccess extends NaicsCategoriesState {
  NaicsCategoriesLoadSuccess(this.naicsCategories);

  final GetNaicsCategoriesResponse naicsCategories;
}

class NaicsCategoriesLoadFailure extends NaicsCategoriesState {}

class NaicsCategoriesCubit extends Cubit<NaicsCategoriesState> {
  NaicsCategoriesCubit(this._silaBusinessRepository)
      : super(NaicsCategoriesInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> getNaicsCategories() async {
    emit(NaicsCategoriesLoadInProgress());
    try {
      final naicsCategories =
          await _silaBusinessRepository.getNaicsCategories();
      emit(NaicsCategoriesLoadSuccess(naicsCategories));
    } catch (_) {
      emit(NaicsCategoriesLoadFailure());
    }
  }
}
