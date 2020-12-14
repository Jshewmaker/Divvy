import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final bool complete;
  final String generalContractorPath;
  final String homeownerPath;
  final String generalContractorSilaHandle;
  final String homeownerSilaHandle;
  final String projectID;
  final String projectName;
  final double projectCost;

  const ProjectEntity(
      this.complete,
      this.generalContractorPath,
      this.homeownerPath,
      this.generalContractorSilaHandle,
      this.homeownerSilaHandle,
      this.projectID,
      this.projectName,
      this.projectCost);

  Map<String, Object> toJson() {
    return {
      "complete": complete,
      "general_contractor_path": generalContractorPath,
      "homeowner_path": homeownerPath,
      "general_contractor_sila_handle": generalContractorSilaHandle,
      "home_owner_sila_handle": generalContractorSilaHandle,
      "project_id": projectID,
      "project_name": projectName,
      "project_cost": projectCost,
    };
  }

  List<Object> get props => [
        complete,
        generalContractorPath,
        homeownerPath,
        generalContractorSilaHandle,
        homeownerSilaHandle,
        projectID,
        projectName,
        projectCost,
      ];

  static ProjectEntity fromJson(Map<String, Object> json) {
    return ProjectEntity(
      json["complete"] as bool,
      json["general_contractor_path"] as String,
      json["homeowner_path"] as String,
      json["general_contractor_sila_handle"] as String,
      json["home_owner_sila_handle"] as String,
      json["project_id"] as String,
      json["project_name"] as String,
      json["project_cost"] as double,
    );
  }

  static ProjectEntity fromSnapshot(DocumentSnapshot snap) {
    return ProjectEntity(
      snap.data['complete'],
      snap.data['general_contractor_path'],
      snap.data['homeowner_path'],
      snap.data['general_contractor_sila_handle'],
      snap.data['home_owner_sila_handle'],
      snap.documentID,
      snap.data['project_name'],
      snap.data['project_cost'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "complete": complete,
      "general_contractor_id": generalContractorPath,
      "homeowner_id": homeownerPath,
      "project_id": projectID,
      "project_name": projectName,
      "project_cost": projectCost,
    };
  }
}
