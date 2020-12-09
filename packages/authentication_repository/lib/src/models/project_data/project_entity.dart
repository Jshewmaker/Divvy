import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final bool complete;
  final String generalContractorID;
  final String homeownerID;
  final int projectID;
  final String projectName;
  final double projectCost;

  const ProjectEntity(this.complete, this.generalContractorID, this.homeownerID,
      this.projectID, this.projectName, this.projectCost);

  Map<String, Object> toJson() {
    return {
      "complete": complete,
      "general_contractor_id": generalContractorID,
      "homeowner_id": homeownerID,
      "project_id": projectID,
      "project_name": projectName,
      "project_cost": projectCost,
    };
  }

  List<Object> get props => [
        complete,
        generalContractorID,
        homeownerID,
        projectID,
        projectName,
        projectCost,
      ];

  static ProjectEntity fromJson(Map<String, Object> json) {
    return ProjectEntity(
      json["complete"] as bool,
      json["general_contractor_id"] as String,
      json["homeowner_id"] as String,
      json["project_id"] as int,
      json["project_name"] as String,
      json["project_cost"] as double,
    );
  }

  static ProjectEntity fromSnapshot(DocumentSnapshot snap) {
    return ProjectEntity(
      snap.data['complete'],
      snap.data['general_contractor_id'],
      snap.data['homeowner_id'],
      snap.data['project_id'],
      snap.data['project_name'],
      snap.data['project_cost'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "complete": complete,
      "general_contractor_id": generalContractorID,
      "homeowner_id": homeownerID,
      "project_id": projectID,
      "project_name": projectName,
      "project_cost": projectCost,
    };
  }
}
