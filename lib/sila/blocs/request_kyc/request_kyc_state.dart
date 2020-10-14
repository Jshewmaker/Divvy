import 'package:divvy/sila/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';



abstract class RequestKYCState extends Equatable {
  const RequestKYCState();

  @override
  List<Object> get props => [];
}

class RequestKYCInitial extends RequestKYCState {}

class RequestKYCLoadInProgress extends RequestKYCState {}

class RequestKYCLoadSuccess extends RequestKYCState {
  final Handle handle;

  const RequestKYCLoadSuccess({@required this.handle}) : assert(handle != null);

  @override
  List<Object> get props => [handle];
}

class RequestKYCLoadFailure extends RequestKYCState {
  
}