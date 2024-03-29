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
  final int generalContractorApprovalDate;
  final double cost;
  final int homeownerApprovalDate;
  final int dateDenied;
  final int phase;
  final String title;
  final String subContractor;
  final String comments;
  final String id;
  final String pictureUrl;
  final int expectedFinishDate;
  final List<dynamic> messages;
  final bool newMessageFromHomeowner;
  final bool newMessageFromGC;

  const LineItemEntity(
    this.generalContractorApprovalDate,
    this.cost,
    this.homeownerApprovalDate,
    this.dateDenied,
    this.phase,
    this.title,
    this.subContractor,
    this.comments,
    this.id,
    this.pictureUrl,
    this.expectedFinishDate,
    this.messages,
    this.newMessageFromHomeowner,
    this.newMessageFromGC,
  );

  Map<String, Object> toJson() {
    //TODO: messages to json
    return {
      "general_contractor_approval_date": generalContractorApprovalDate,
      "cost": cost,
      "homeowner_approval_date": homeownerApprovalDate,
      "date_denied": dateDenied,
      "phase": phase,
      "title": title,
      "sub_contractor": subContractor,
      "comments": comments,
      "picture_url": pictureUrl,
      "expected_finish_date": expectedFinishDate,
      "new_message_from_homeowner": newMessageFromHomeowner,
      "new_message_from_gc": newMessageFromGC,
    };
  }

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

  static LineItemEntity fromJson(Map<String, Object> json) {
    //TODO: messages from json
    return LineItemEntity(
      json["general_contractor_approval_date"] as int,
      json["cost"] as double,
      json["homeowner_approval_date"] as int,
      json["date_denied"] as int,
      json["phase"] as int,
      json["title"] as String,
      json["sub_contractor"] as String,
      json["comments"] as String,
      json["id"] as String,
      json["picture_url"] as String,
      json["expected_finish_date"] as int,
      json["messages"] as List<Map>,
      json["new_message_from_homeowner"] as bool,
      json["new_message_from_gc"] as bool,
    );
  }

  //Specific to Firestore
  static LineItemEntity fromSnapshot(DocumentSnapshot snap) {
    return LineItemEntity(
      snap.data['general_contractor_approval_date'],
      snap.data['cost'].toDouble(),
      snap.data['homeowner_approval_date'],
      snap.data['date_denied'],
      snap.data['phase'],
      snap.data['title'],
      snap.data['sub_contractor'],
      snap.data['comments'],
      snap.documentID,
      snap.data['picture_url'],
      snap.data['expected_finish_date'],
      snap.data['messages'],
      snap.data['new_message_from_homeowner'],
      snap.data['new_message_from_gc'],
    );
  }

  //Specific to Firestore
  Map<String, Object> toDocument() {
    return {
      "general_contractor_approval_date": generalContractorApprovalDate,
      "cost": cost,
      "homeowner_approval_date": homeownerApprovalDate,
      "date_denied": dateDenied,
      "phase": phase,
      "title": title,
      "sub_contractor": subContractor,
      "comments": comments,
      "picture_url": pictureUrl,
      "expected_finish_date": expectedFinishDate,
      "messages": messages.toList(),
      "new_message_from_homeowner": newMessageFromHomeowner,
      "new_message_from_gc": newMessageFromGC,
    };
  }
}
