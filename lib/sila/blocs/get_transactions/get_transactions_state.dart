import 'package:divvy/sila/models/get_transactions_response.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class GetTransactionsState extends Equatable {
  const GetTransactionsState();

  @override
  List<Object> get props => [];
}

class GetEntityInitial extends GetTransactionsState {}

class GetTransactionsLoadInProgress extends GetTransactionsState {}

class GetTransactionsLoadSuccess extends GetTransactionsState {
  final GetTransactionsResponse response;

  const GetTransactionsLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class GetTransactionsLoadFailure extends GetTransactionsState {}
