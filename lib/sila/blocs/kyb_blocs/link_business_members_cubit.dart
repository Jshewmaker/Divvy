import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/kyb/link_business_member_response.dart';
import 'package:divvy/sila/models/kyb/naics_categories_models/get_naics_categories_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class LinkBusinessMembersState {}

class LinkBusinessMembersInitial extends LinkBusinessMembersState {}

class LinkBusinessMembersLoadInProgress extends LinkBusinessMembersState {}

class LinkBusinessMembersLoadSuccess extends LinkBusinessMembersState {
  LinkBusinessMembersLoadSuccess(this.linkBusinessMembers);

  final List<LinkBusinessMemberResponse> linkBusinessMembers;
}

class LinkBusinessMembersLoadFailure extends LinkBusinessMembersState {}

class LinkBusinessMembersCubit extends Cubit<LinkBusinessMembersState> {
  LinkBusinessMembersCubit(this._silaBusinessRepository)
      : super(LinkBusinessMembersInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> getLinkBusinessMembers() async {
    emit(LinkBusinessMembersLoadInProgress());
    try {
      List<LinkBusinessMemberResponse> linkBusinessMembers = [];
      linkBusinessMembers = await _silaBusinessRepository.linkBusinessMember();
      emit(LinkBusinessMembersLoadSuccess(linkBusinessMembers));
    } catch (_) {
      emit(LinkBusinessMembersLoadFailure());
    }
  }
}
