import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'messages.dart';

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
  final String subContractor;
  final String comments;
  final String id;
  final String pictureUrl;
  final Timestamp expectFinishedDate;
  final List<dynamic> messages;

  const LineItemEntity(
    this.generalContractorApprovalDate,
    this.cost,
    this.homeownerApprovalDate,
    this.datePaid,
    this.phase,
    this.title,
    this.subContractor,
    this.comments,
    this.id,
    this.pictureUrl,
    this.expectFinishedDate,
    this.messages,
  );

  Map<String, Object> toJson() {
    //TODO: messages to json
    return {
      "general_contractor_approval_date": generalContractorApprovalDate,
      "cost": cost,
      "homeowner_approval_date": homeownerApprovalDate,
      "date_paid": datePaid,
      "phase": phase,
      "title": title,
      "sub_contactor": subContractor,
      "comments": comments,
      "picture_url": pictureUrl,
      "expect_finished_date": expectFinishedDate,
    };
  }

  List<Object> get props => [
        generalContractorApprovalDate,
        cost,
        homeownerApprovalDate,
        datePaid,
        phase,
        title,
        subContractor,
        comments,
        id,
        pictureUrl,
        expectFinishedDate,
        messages,
      ];

  static LineItemEntity fromJson(Map<String, Object> json) {
    //TODO: messages from json
    return LineItemEntity(
      json["general_contractor_approval_date"] as Timestamp,
      json["cost"] as double,
      json["homeowner_approval_date"] as Timestamp,
      json["date_paid"] as Timestamp,
      json["phase"] as int,
      json["title"] as String,
      json["sub_contactor"] as String,
      json["comments"] as String,
      json["id"] as String,
      json["picture_url"] as String,
      json["expect_finished_date"] as Timestamp,
      json["messages"] as List<Map>,
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
      snap.data['sub_contactor'],
      snap.data['comments'],
      snap.documentID,
      snap.data['picture_url'],
      snap.data['expect_finished_date'],
      snap.data['messages'],
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
      "sub_contactor": subContractor,
      "comments": comments,
      "picture_url": pictureUrl,
      "expect_finished_date": expectFinishedDate,
      "messages": messages.toList(),
    };
  }
}
