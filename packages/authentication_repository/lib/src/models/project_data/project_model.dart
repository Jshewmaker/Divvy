import 'package:authentication_repository/src/models/project_data/project_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Project {
  final bool complete;
  final String generalContractorID;
  final String homeownerID;
  final String projectID;
  final String projectName;
  final double projectCost;

  const Project(
      {@required this.complete,
      @required this.generalContractorID,
      @required this.homeownerID,
      @required this.projectID,
      @required this.projectName,
      @required this.projectCost});

  List<Object> get props => [
        complete,
        generalContractorID,
        homeownerID,
        projectID,
        projectName,
        projectCost
      ];

  ProjectEntity toEntity() {
    return ProjectEntity(complete, generalContractorID, homeownerID, projectID,
        projectName, projectCost);
  }

  static Project fromEntity(ProjectEntity entity) {
    return Project(
      complete: entity.complete,
      generalContractorID: entity.generalContractorID,
      homeownerID: entity.homeownerID,
      projectID: entity.projectID,
      projectName: entity.projectName,
      projectCost: entity.projectCost,
    );
  }
}
