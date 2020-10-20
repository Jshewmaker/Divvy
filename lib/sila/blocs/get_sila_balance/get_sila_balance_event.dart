import 'package:equatable/equatable.dart';

abstract class GetSilaBalanceEvent extends Equatable {
  const GetSilaBalanceEvent();
}

class GetSilaBalanceRequest extends GetSilaBalanceEvent {
  const GetSilaBalanceRequest();

  @override
  List<Object> get props => [];
}
