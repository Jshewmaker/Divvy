
import 'package:equatable/equatable.dart';

abstract class RequestKYCEvent extends Equatable {
  const RequestKYCEvent();
}

class RequestKYCRequest extends RequestKYCEvent {
  const RequestKYCRequest();

  @override
  List<Object> get props => [];
}
