import 'project_line_items_entity.dart';
import 'messages.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class LineItemListModel {
  final List<LineItem> lineItems;

  LineItemListModel({
    this.lineItems,
  });

  factory LineItemListModel.fromEntity(LineItemListEntity entityList) {
    List<LineItem> lineItems = List<LineItem>();
    lineItems =
        entityList.lineItems.map((i) => LineItem.fromEntity(i)).toList();

    return LineItemListModel(lineItems: lineItems);
  }
}

class LineItem extends Equatable {
  /// {@macro user}

  final DateTime generalContractorApprovalDate;
  final double cost;
  final DateTime homeownerApprovalDate;
  final DateTime dateDenied;
  final int phase;
  final String title;
  final String subContractor;
  final String comments;
  final String id;
  final String pictureUrl;
  final DateTime expectedFinishDate;
  final MessageListModel messages;
  final bool newMessageFromHomeowner;
  final bool newMessageFromGC;

  const LineItem({
    @required this.title,
    this.generalContractorApprovalDate,
    this.cost,
    this.dateDenied,
    this.phase,
    this.homeownerApprovalDate,
    this.subContractor,
    this.comments,
    this.id,
    this.pictureUrl,
    this.expectedFinishDate,
    this.messages,
    this.newMessageFromHomeowner,
    this.newMessageFromGC,
  });

  /// Empty user which represents an unauthenticated user.
  static const empty = LineItem(
    title: '',
    generalContractorApprovalDate: null,
    cost: null,
    dateDenied: null,
    phase: null,
    homeownerApprovalDate: null,
    subContractor: '',
    comments: '',
    id: '',
    pictureUrl: '',
    expectedFinishDate: null,
    messages: null,
    newMessageFromHomeowner: false,
    newMessageFromGC: false,
  );

  @override
  List<Object> get props => [
        generalContractorApprovalDate,
        cost,
        homeownerApprovalDate,
        dateDenied,
        phase,
        title,
        subContractor,
        comments,
        id,
        pictureUrl,
        expectedFinishDate,
        messages,
        newMessageFromHomeowner,
        newMessageFromGC,
      ];

  static LineItem fromEntity(LineItemEntity entity) {
    return LineItem(
      generalContractorApprovalDate:
          entity.generalContractorApprovalDate != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  entity.generalContractorApprovalDate)
              : null,
      cost: entity.cost,
      homeownerApprovalDate: entity.homeownerApprovalDate != null
          ? DateTime.fromMillisecondsSinceEpoch(entity.homeownerApprovalDate)
          : null,
      dateDenied: entity.dateDenied != null
          ? DateTime.fromMillisecondsSinceEpoch(entity.dateDenied)
          : null,
      phase: entity.phase,
      title: entity.title,
      subContractor: (entity.subContractor == null)
          ? 'Contractor not listed'
          : entity.subContractor,
      comments: entity.comments,
      id: entity.id,
      pictureUrl: entity.pictureUrl,
      expectedFinishDate: entity.expectedFinishDate != null
          ? DateTime.fromMillisecondsSinceEpoch(entity.expectedFinishDate)
          : null,
      messages: (entity.messages != null)
          ? MessageListModel.fromList(entity.messages)
          : null,
      newMessageFromHomeowner: (entity.newMessageFromHomeowner == null)
          ? false
          : entity.newMessageFromHomeowner,
      newMessageFromGC:
          (entity.newMessageFromGC == null) ? false : entity.newMessageFromGC,
    );
  }

  LineItemEntity toEntity() {
    var expectedFinishDateToUnix =
        expectedFinishDate.toUtc().millisecondsSinceEpoch;
    var generalContractorApprovalDateToUnix =
        generalContractorApprovalDate.toUtc().millisecondsSinceEpoch;
    var homeownerApprovalDateToUnix =
        homeownerApprovalDate.toUtc().millisecondsSinceEpoch;
    var datePaidToUnix = dateDenied.toUtc().millisecondsSinceEpoch;
    return LineItemEntity(
      generalContractorApprovalDateToUnix,
      cost,
      homeownerApprovalDateToUnix,
      datePaidToUnix,
      phase,
      title,
      subContractor,
      comments,
      id,
      pictureUrl,
      expectedFinishDateToUnix,
      messages.toList(),
      newMessageFromHomeowner,
      newMessageFromGC,
    );
  }
}
