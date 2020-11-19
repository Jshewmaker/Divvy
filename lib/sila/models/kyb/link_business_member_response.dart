import 'package:equatable/equatable.dart';

class LinkBusinessMemberResponse extends Equatable {
  final bool success;
  final String status;
  final String message;
  final String role;
  final String details;
  final String verificationUuid;

  const LinkBusinessMemberResponse({
    this.success,
    this.status,
    this.message,
    this.role,
    this.details,
    this.verificationUuid,
  });

  @override
  List<Object> get props => [
        success,
        status,
        message,
        role,
        details,
        verificationUuid,
      ];

  static LinkBusinessMemberResponse fromJson(dynamic json) {
    return LinkBusinessMemberResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      role: json['role'],
      details: json['details'],
      verificationUuid: json['verification_uuid'],
    );
  }
}
