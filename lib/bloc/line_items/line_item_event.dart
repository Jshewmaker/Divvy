import 'package:equatable/equatable.dart';

abstract class LineItemEvent extends Equatable {
  const LineItemEvent();

  @override
  List<Object> get props => [];
}

class LineItemConnectedLoadSuccess extends LineItemEvent {}

class LineItemRequested extends LineItemEvent {
  final String projectID;
  final int phase;

  const LineItemRequested(this.projectID, this.phase);

  @override
  List<Object> get props => [projectID, phase];

  @override
  String toString() => 'Connecting LineItem{LineItem $projectID and $phase}';
}
