import 'package:equatable/equatable.dart';

class Identity extends Equatable {
  final int addedEpoch;
  final int modifiedEpoch;
  final String uuid;
  final String identityType;
  final String identity;
  final int documentID;
  final String documentName;

  Identity(
      {this.addedEpoch,
      this.modifiedEpoch,
      this.uuid,
      this.identityType,
      this.identity,
      this.documentID,
      this.documentName});

  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      addedEpoch: json['added_epoch'],
      modifiedEpoch: json['modified_epoch'],
      uuid: json['uuid'],
      identityType: json['identity_type'],
      identity: json['identity'],
      documentID: json['documentID'],
      documentName: json['document_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_epoch'] = this.addedEpoch;
    data['modified_epoch'] = this.modifiedEpoch;
    data['uuid'] = this.uuid;
    data['indentity_type'] = this.identityType;
    data['indentity'] = this.identity;
    data['document_id'] = this.documentID;
    data['document_name'] = this.documentName;
    return data;
  }

  @override
  List<Object> get props => [
        this.addedEpoch,
        this.modifiedEpoch,
        this.uuid,
        this.identityType,
        this.identity,
        this.documentID,
        this.documentName
      ];
}
