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
  List<Object> get props => [lineItems];

  @override
  String toString() => 'LineItemConnected { LineItems: $lineItems}';
}

class LineItemForInvoiceLoadSuccess extends LineItemState {
  final LineItem lineItem;
  final Project project;

  LineItemForInvoiceLoadSuccess({
    @required this.lineItem,
    @required this.project,
  });

  @override
  List<Object> get props => [lineItem];

  @override
  String toString() => 'LineItemForInvoiceConnected { LineItems: $lineItem}';
}

class LineItemLoadFailure extends LineItemState {}
