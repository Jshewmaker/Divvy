import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:meta/meta.dart';

abstract class LineItemState extends Equatable {
  const LineItemState();

  @override
  List<Object> get props => [];
}

class LineItemInitial extends LineItemState {}

class LineItemLoadInProgress extends LineItemState {}

class LineItemLoadSuccess extends LineItemState {
  final LineItemListModel lineItems;

  const LineItemLoadSuccess({@required this.lineItems});

  @override
  List<Object> get props => [LineItem];

  @override
  String toString() => 'LineItemConnected { LineItems: $LineItem}';
}

class LineItemLoadFailure extends LineItemState {}
