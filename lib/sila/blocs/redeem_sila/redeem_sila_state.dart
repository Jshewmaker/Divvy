import 'package:divvy/sila/models/redeem_sila_model.dart';
import 'package:equatable/equatable.dart';

abstract class RedeemSilaState extends Equatable {
  const RedeemSilaState();

  @override
  List<Object> get props => [];
}

class RedeemSilaInitial extends RedeemSilaState {}

class RedeemSilaLoadInProgress extends RedeemSilaState {}

class RedeemSilaLoadSuccess extends RedeemSilaState {
  RedeemSilaLoadSuccess(this.response);

  final RedeemSilaModel response;
}

class RedeemSilaLoadFailure extends RedeemSilaState {}
