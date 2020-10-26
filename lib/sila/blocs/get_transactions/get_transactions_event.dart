import 'package:equatable/equatable.dart';

abstract class GetTransactionsEvent extends Equatable {
  const GetTransactionsEvent();
}

class GetTransactionsRequest extends GetTransactionsEvent {
  const GetTransactionsRequest();

  @override
  List<Object> get props => [];
}
