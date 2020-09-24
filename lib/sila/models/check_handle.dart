import 'package:equatable/equatable.dart';

class CheckHandle extends Equatable {
  final String success;
  final String message;
  final String reference;
  final String status;

  const CheckHandle({this.success, this.message, this.reference, this.status});

  @override
  List<Object> get props => [
        success,
        message,
        reference,
        status,
      ];

  static CheckHandle fromJson(dynamic json) {
    return CheckHandle(
      success: json['success'],
      message: json['message'],
      reference: json['reference'],
      status: json['status'],
    );
  }

}
