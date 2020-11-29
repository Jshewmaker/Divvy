import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LineItemListEntity {
  final List<LineItemEntity> lineItems;

  LineItemListEntity({
    this.lineItems,
  });

  factory LineItemListEntity.fromSnapshot(QuerySnapshot snapshot) {
    List<LineItemEntity> lineItems = List<LineItemEntity>();
    lineItems =
        snapshot.documents.map((i) => LineItemEntity.fromSnapshot(i)).toList();

    return LineItemListEntity(lineItems: lineItems);
  }
}

class LineItemEntity extends Equatable {
  final Timestamp generalContractorApprovalDate;
  final double cost;
  final Timestamp homeownerApprovalDate;
  final Timestamp datePaid;
  final int phase;
  final String title;

  const LineItemEntity(
    this.generalContractorApprovalDate,
    this.cost,
    this.homeownerApprovalDate,
    this.datePaid,
    this.phase,
    this.title,
  );

  Map<String, Object> toJson() {
    return {
      "general_contractor_approval_date": generalContractorApprovalDate,
      "cost": cost,
      "homeowner_approval_date": homeownerApprovalDate,
      "date_paid": datePaid,
      "phase": phase,
      "title": title,
    };
  }

  List<Object> get props => [
        generalContractorApprovalDate,
        cost,
        homeownerApprovalDate,
        datePaid,
        phase,
        title,
      ];

  static LineItemEntity fromJson(Map<String, Object> json) {
    return LineItemEntity(
      json["general_contractor_approval_date"] as Timestamp,
      json["cost"] as double,
      json["homeowner_approval_date"] as Timestamp,
      json["date_paid"] as Timestamp,
      json["phase"] as int,
      json["title"] as String,
    );
  }

  //Specific to Firestore
  static LineItemEntity fromSnapshot(DocumentSnapshot snap) {
    return LineItemEntity(
      snap.data['general_contractor_approval_date'],
      snap.data['cost'].toDouble(),
      snap.data['homeowner_approval_date'],
      snap.data['date_paid'],
      snap.data['phase'],
      snap.data['title'],
    );
  }

  //Specific to Firestore
  Map<String, Object> toDocument() {
    return {
      "general_contractor_approval_date": generalContractorApprovalDate,
      "cost": cost,
      "homeowner_approval_date": homeownerApprovalDate,
      "date_paid": datePaid,
      "phase": phase,
      "title": title,
    };
  }
}
