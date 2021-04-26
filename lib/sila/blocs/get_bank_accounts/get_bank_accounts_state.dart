import 'package:divvy/sila/models/bank_accounts_entity.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class GetBankAccountsState extends Equatable {
  const GetBankAccountsState();

  @override
  List<Object> get props => [];
}

class GetBankAccountsInitial extends GetBankAccountsState {}

class GetBankAccountsLoadInProgress extends GetBankAccountsState {}

class GetBankAccountsLoadSuccess extends GetBankAccountsState {
  final ListOfBankAccountEntities response;

  const GetBankAccountsLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class GetBankAccountsLoadNotReady extends GetBankAccountsState {
  final ListOfBankAccountEntities response;

  const GetBankAccountsLoadNotReady({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class GetBankAccountsLoadFailure extends GetBankAccountsState {}
