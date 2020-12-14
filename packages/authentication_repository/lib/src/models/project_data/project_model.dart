import 'package:authentication_repository/src/models/project_data/project_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Project {
  final bool complete;
  final String generalContractorPath;
  final String homeownerPath;
  final String generalContractorSilaHandle;
  final String homeownerSilaHandle;
  final String projectID;
  final String projectName;
  final double projectCost;

  const Project(
      {@required this.complete,
      @required this.generalContractorPath,
      @required this.homeownerPath,
      @required this.generalContractorSilaHandle,
      @required this.homeownerSilaHandle,
      @required this.projectID,
      @required this.projectName,
      @required this.projectCost});

  List<Object> get props => [
        complete,
        generalContractorPath,
        homeownerPath,
        generalContractorSilaHandle,
        homeownerSilaHandle,
        projectID,
        projectName,
        projectCost
      ];

  ProjectEntity toEntity() {
    return ProjectEntity(
        complete,
        generalContractorPath,
        homeownerPath,
        generalContractorSilaHandle,
        homeownerSilaHandle,
        projectID,
        projectName,
        projectCost);
  }

  static Project fromEntity(ProjectEntity entity) {
    return Project(
      complete: entity.complete,
      generalContractorPath: entity.generalContractorPath,
      homeownerPath: entity.homeownerPath,
      generalContractorSilaHandle: entity.generalContractorSilaHandle,
      homeownerSilaHandle: entity.homeownerSilaHandle,
      projectID: entity.projectID,
      projectName: entity.projectName,
      projectCost: entity.projectCost,
    );
  }
}
