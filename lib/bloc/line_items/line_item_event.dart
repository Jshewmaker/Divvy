import 'package:equatable/equatable.dart';

abstract class LineItemEvent extends Equatable {
  const LineItemEvent();

  @override
  List<Object> get props => [];
}

class LineItemConnectedLoadSuccess extends LineItemEvent {}

class LineItemRequested extends LineItemEvent {
  final int phase;

  const LineItemRequested(this.phase);

  @override
  List<Object> get props => [phase];

  @override
  String toString() => 'Connecting LineItem{LineItem  $phase}';
}
