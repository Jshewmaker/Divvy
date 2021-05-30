import 'package:equatable/equatable.dart';

abstract class GetBankAccountsEvent extends Equatable {
  const GetBankAccountsEvent();
}

class GetBankAccountsRequest extends GetBankAccountsEvent {
  const GetBankAccountsRequest();

  @override
  List<Object> get props => [];
}
