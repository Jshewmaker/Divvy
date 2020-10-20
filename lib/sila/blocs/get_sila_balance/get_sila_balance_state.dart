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
  final GetSilaBalanceResponse response;

  const GetSilaBalanceLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class GetSilaBalanceLoadFailure extends GetSilaBalanceState {}
