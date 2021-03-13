import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CreateSilaBusinessEvent extends Equatable {
  const CreateSilaBusinessEvent();
}

class DivvyCheckForBusinessHandle extends CreateSilaBusinessEvent {
  const DivvyCheckForBusinessHandle();

  @override
  List<Object> get props => [];
}

class CreateBusinessHandle extends CreateSilaBusinessEvent {
  const CreateBusinessHandle();

  @override
  List<Object> get props => [];
}

class SilaRegisterBusiness extends CreateSilaBusinessEvent {
  final String handle;
  const SilaRegisterBusiness({@required this.handle});

  @override
  List<Object> get props => [handle];
}

class DivvyCheckForAdminHandle extends CreateSilaBusinessEvent {
  const DivvyCheckForAdminHandle();

  @override
  List<Object> get props => [];
}

class CreateAdminHandle extends CreateSilaBusinessEvent {
  const CreateAdminHandle();

  @override
  List<Object> get props => [];
}

class SilaRegisterAdmin extends CreateSilaBusinessEvent {
  final String handle;
  const SilaRegisterAdmin({@required this.handle});

  @override
  List<Object> get props => [handle];
}

class SilaCheckBusinessHandle extends CreateSilaBusinessEvent {
  final String handle;
  const SilaCheckBusinessHandle({@required this.handle});

  @override
  List<Object> get props => [handle];
}

class SilaCheckAdminHandle extends CreateSilaBusinessEvent {
  final String handle;
  const SilaCheckAdminHandle({@required this.handle});

  @override
  List<Object> get props => [handle];
}

class LinkBusinessMembers extends CreateSilaBusinessEvent {
  const LinkBusinessMembers();

  @override
  List<Object> get props => [];
}

class RequestKYB extends CreateSilaBusinessEvent {
  const RequestKYB();

  @override
  List<Object> get props => [];
}

class CheckKYB extends CreateSilaBusinessEvent {
  const CheckKYB();

  @override
  List<Object> get props => [];
}

class CertifyBeneficialOwner extends CreateSilaBusinessEvent {
  const CertifyBeneficialOwner();

  @override
  List<Object> get props => [];
}

class CertifyBusiness extends CreateSilaBusinessEvent {
  const CertifyBusiness();

  @override
  List<Object> get props => [];
}
