import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class TransferSilaEvent extends Equatable {
  const TransferSilaEvent();
}

class TransferSilaRequest extends TransferSilaEvent {
  final UserModel sender;
  final double amount;
  final String receiverHandle;
  final String transferMessage;
  const TransferSilaRequest(
      {@required this.sender,
      @required this.amount,
      @required this.receiverHandle,
      @required this.transferMessage})
      : assert(sender != null, amount != null);
  List<Object> get props => [sender, amount, receiverHandle, transferMessage];
}
