import 'package:divvy/sila/plaid/models/plaid_public_token_exchange_response_model.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class PlaidState extends Equatable {
  const PlaidState();

  @override
  List<Object> get props => [];
}

class PlaidInitial extends PlaidState {
  PlaidInitial();
}

class PlaidLoadInProgress extends PlaidState {}

class PlaidLoadSuccess extends PlaidState {
  final PlaidPublicTokenExchangeResponseModel
      plaidPublicTokenExchangeResponseModel;

  const PlaidLoadSuccess({@required this.plaidPublicTokenExchangeResponseModel})
      : assert(plaidPublicTokenExchangeResponseModel != null);

  @override
  List<Object> get props => [plaidPublicTokenExchangeResponseModel];
}

class PlaidLoadFailure extends PlaidState {}
