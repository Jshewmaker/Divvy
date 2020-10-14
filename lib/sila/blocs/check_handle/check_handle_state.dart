import 'package:divvy/sila/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';


abstract class CheckHandleState extends Equatable {
  const CheckHandleState();

  @override
  List<Object> get props => [];
}

class CheckHandleInitial extends CheckHandleState {}

class CheckHandleLoadInProgress extends CheckHandleState {}

class CheckHandleLoadSuccess extends CheckHandleState {
  final Handle checkHandle;

  const CheckHandleLoadSuccess({@required this.checkHandle}) : assert(checkHandle != null);

  @override
  List<Object> get props => [checkHandle];
}

class CheckHandleLoadFailure extends CheckHandleState {
  
}