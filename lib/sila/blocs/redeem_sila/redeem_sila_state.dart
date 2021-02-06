import 'package:divvy/sila/models/redeem_sila_model.dart';

abstract class RedeemSilaState {}

class RedeemSilaInitial extends RedeemSilaState {}

class RedeemSilaLoadInProgress extends RedeemSilaState {}

class RedeemSilaLoadSuccess extends RedeemSilaState {
  RedeemSilaLoadSuccess(this.response);

  final RedeemSilaModel response;
}

class RedeemSilaLoadFailure extends RedeemSilaState {}
