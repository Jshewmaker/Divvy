part of 'updatephonebloc_bloc.dart';

abstract class UpdatePhoneEvent extends Equatable {
  const UpdatePhoneEvent();

  @override
  List<Object> get props => [];
}

class UpdatePhoneRequest extends UpdatePhoneEvent {
  final String phoneNumber;

  const UpdatePhoneRequest({@required this.phoneNumber})
      : assert(phoneNumber != null);

  @override
  List<Object> get props => [phoneNumber];
}
