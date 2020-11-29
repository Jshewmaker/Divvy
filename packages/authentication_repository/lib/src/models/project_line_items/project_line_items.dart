import 'project_line_items_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  final Timestamp generalContractorApprovalDate;
  final double cost;
  final Timestamp homeownerApprovalDate;
  final Timestamp datePaid;
  final int phase;
  final String title;

  const LineItem({
    @required this.title,
    this.generalContractorApprovalDate,
    this.cost,
    this.datePaid,
    this.phase,
    this.homeownerApprovalDate,
  });

  /// Empty user which represents an unauthenticated user.
  static const empty = LineItem(
    title: '',
    generalContractorApprovalDate: null,
    cost: null,
    datePaid: null,
    phase: null,
    homeownerApprovalDate: null,
  );

  @override
  List<Object> get props => [
        generalContractorApprovalDate,
        cost,
        homeownerApprovalDate,
        datePaid,
        phase,
        title,
      ];

  static LineItem fromEntity(LineItemEntity entity) {
    return LineItem(
      generalContractorApprovalDate: entity.generalContractorApprovalDate,
      cost: entity.cost,
      homeownerApprovalDate: entity.homeownerApprovalDate,
      datePaid: entity.datePaid,
      phase: entity.phase,
      title: entity.title,
    );
  }

  LineItemEntity toEntity() {
    return LineItemEntity(
      generalContractorApprovalDate,
      cost,
      homeownerApprovalDate,
      datePaid,
      phase,
      title,
    );
  }
}
