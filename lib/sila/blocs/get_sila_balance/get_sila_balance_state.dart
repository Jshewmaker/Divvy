import 'package:divvy/sila/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class GetSilaBalanceState extends Equatable {
  const GetSilaBalanceState();

  @override
  List<Object> get props => [];
}

class GetSilaBalanceInitial extends GetSilaBalanceState {}

class GetSilaBalanceLoadInProgress extends GetSilaBalanceState {}

class GetSilaBalanceLoadSuccess extends GetSilaBalanceState {
  final GetSilaBalanceResponse userSilaResponse;
  final GetSilaBalanceResponse projectSilaResponse;

  const GetSilaBalanceLoadSuccess(
      {@required this.userSilaResponse, this.projectSilaResponse})
      : assert(userSilaResponse != null);

  @override
  List<Object> get props => [userSilaResponse, projectSilaResponse];
}

class GetSilaBalanceLoadFailure extends GetSilaBalanceState {}
