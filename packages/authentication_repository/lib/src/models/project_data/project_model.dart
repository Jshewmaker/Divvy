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
  final String homeownerName;
  final String generalContractorName;
  final String address;

  const Project({
    @required this.complete,
    @required this.generalContractorPath,
    @required this.homeownerPath,
    @required this.generalContractorSilaHandle,
    @required this.homeownerSilaHandle,
    @required this.projectID,
    @required this.projectName,
    @required this.projectCost,
    @required this.homeownerName,
    @required this.generalContractorName,
    @required this.address,
  });

  List<Object> get props => [
        complete,
        generalContractorPath,
        homeownerPath,
        generalContractorSilaHandle,
        homeownerSilaHandle,
        projectID,
        projectName,
        projectCost,
        homeownerName,
        generalContractorName,
        address,
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
      projectCost,
      homeownerName,
      generalContractorName,
      address,
    );
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
      homeownerName: entity.homeownerName,
      generalContractorName: (entity.generalContractorName == null)
          ? 'Contractor not listed'
          : entity.generalContractorName,
      address: entity.address,
    );
  }

  static const empty = Project(
    complete: null,
    generalContractorPath: '',
    homeownerPath: '',
    generalContractorSilaHandle: '',
    homeownerSilaHandle: '',
    projectID: '',
    projectName: '',
    projectCost: null,
    homeownerName: '',
    generalContractorName: '',
    address: '',
  );
}
