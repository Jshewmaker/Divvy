import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateAddressEvent extends Equatable {
  const UpdateAddressEvent();
}

class UpdateAddressRequest extends UpdateAddressEvent {
  final Map<String, String> address;

  const UpdateAddressRequest({@required this.address})
      : assert(address != null);

  @override
  List<Object> get props => [address];
}
