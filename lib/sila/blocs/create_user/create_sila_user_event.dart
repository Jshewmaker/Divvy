import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CreateSilaUserEvent extends Equatable {
  const CreateSilaUserEvent();
}

class DivvyCheckForHandle extends CreateSilaUserEvent {
  const DivvyCheckForHandle();

  @override
  List<Object> get props => [];
}

class CreateHandle extends CreateSilaUserEvent {
  const CreateHandle();

  @override
  List<Object> get props => [];
}

class SilaCheckHandle extends CreateSilaUserEvent {
  final String handle;

  const SilaCheckHandle({@required this.handle}) : assert(handle != null);

  @override
  List<Object> get props => [];
}

class SilaRegisterHandle extends CreateSilaUserEvent {
  final String handle;

  const SilaRegisterHandle({@required this.handle}) : assert(handle != null);

  @override
  List<Object> get props => [];
}

class SilaRequestKYC extends CreateSilaUserEvent {
  const SilaRequestKYC();

  @override
  List<Object> get props => [];
}

class SilaCheckKYC extends CreateSilaUserEvent {
  const SilaCheckKYC();

  @override
  List<Object> get props => [];
}

class CreateSilaUserRequest extends CreateSilaUserEvent {
  final String handle;

  const CreateSilaUserRequest({@required this.handle}) : assert(handle != null);

  @override
  List<Object> get props => [handle];
}
