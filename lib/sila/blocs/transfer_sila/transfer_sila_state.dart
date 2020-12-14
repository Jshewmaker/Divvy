import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/models/transfer_sila_response.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class TransferSilaState extends Equatable {
  const TransferSilaState();

  @override
  List<Object> get props => [];
}

class TransferSilaInitial extends TransferSilaState {}

class TransferSilaLoadInProgress extends TransferSilaState {}

class TransferSilaLoadSuccess extends TransferSilaState {
  final TransferSilaResponse response;

  const TransferSilaLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class TransferSilaLoadFailure extends TransferSilaState {
  final Exception exception;

  const TransferSilaLoadFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
