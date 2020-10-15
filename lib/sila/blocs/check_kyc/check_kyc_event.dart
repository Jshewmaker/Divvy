import 'package:equatable/equatable.dart';

abstract class CheckKycEvent extends Equatable {
  const CheckKycEvent();
}

class CheckKycRequest extends CheckKycEvent {
  const CheckKycRequest();

  @override
  List<Object> get props => [];
}
