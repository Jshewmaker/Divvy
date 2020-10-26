import 'package:equatable/equatable.dart';

class GetTransactionsResponse extends Equatable {
  final bool success;
  final String status;
  final int page;
  final int returnedCount;
  final int totalCount;
  final List<dynamic> transactions;

  GetTransactionsResponse(
      {this.success,
      this.status,
      this.page,
      this.returnedCount,
      this.totalCount,
      this.transactions});

  factory GetTransactionsResponse.fromJson(Map<String, dynamic> json) {
    return GetTransactionsResponse(
      success: json['success'],
      status: json['status'],
      page: json['page'],
      returnedCount: json['returned_count'],
      totalCount: json['total_count'],
      transactions: json['transactions'] != null
          ? json['transactions']
              .map((v) => new Transactions.fromJson(v))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['page'] = this.page;
    data['returned_count'] = this.returnedCount;
    data['total_count'] = this.totalCount;
    if (this.transactions != null) {
      data['transactions'] = this.transactions.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object> get props => [
        this.success,
        this.status,
        this.page,
        this.returnedCount,
        this.totalCount,
        this.transactions
      ];
}

class Transactions extends Equatable {
  final String userHandle;
  final String referenceId;
  final String transactionId;
  final String transactionHash;
  final String transactionType;
  final int silaAmount;
  final String status;
  final String usdStatus;
  final String tokenStatus;
  final String created;
  final String lastUpdate;
  final int createdEpoch;
  final int lastUpdateEpoch;
  final String descriptor;
  final String descriptorAch;
  final String achName;
  final String destinationAddress;
  final String destinationHandle;
  final String handleAddress;
  final List<Timeline> timeline;
  final String bankAccountName;
  final String processingType;

  Transactions(
      {this.userHandle,
      this.referenceId,
      this.transactionId,
      this.transactionHash,
      this.transactionType,
      this.silaAmount,
      this.status,
      this.usdStatus,
      this.tokenStatus,
      this.created,
      this.lastUpdate,
      this.createdEpoch,
      this.lastUpdateEpoch,
      this.descriptor,
      this.descriptorAch,
      this.achName,
      this.destinationAddress,
      this.destinationHandle,
      this.handleAddress,
      this.timeline,
      this.bankAccountName,
      this.processingType});

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      userHandle: json['user_handle'],
      referenceId: json['reference_id'],
      transactionId: json['transaction_id'],
      transactionHash: json['transaction_hash'],
      transactionType: json['transaction_type'],
      silaAmount: json['sila_amount'],
      status: json['status'],
      usdStatus: json['usd_status'],
      tokenStatus: json['token_status'],
      created: json['created'],
      lastUpdate: json['last_update'],
      createdEpoch: json['created_epoch'],
      lastUpdateEpoch: json['last_update_epoch'],
      descriptor: json['descriptor'],
      descriptorAch: json['descriptor_ach'],
      achName: json['ach_name'],
      destinationAddress: json['destination_address'],
      destinationHandle: json['destination_handle'],
      handleAddress: json['handle_address'],
      timeline: json['timeline'] != null
          ? json['timeline'].map((v) => new Timeline.fromJson(v)).toList()
          : null,
      bankAccountName: json['bank_account_name'],
      processingType: json['processing_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_handle'] = this.userHandle;
    data['reference_id'] = this.referenceId;
    data['transaction_id'] = this.transactionId;
    data['transaction_hash'] = this.transactionHash;
    data['transaction_type'] = this.transactionType;
    data['sila_amount'] = this.silaAmount;
    data['status'] = this.status;
    data['usd_status'] = this.usdStatus;
    data['token_status'] = this.tokenStatus;
    data['created'] = this.created;
    data['last_update'] = this.lastUpdate;
    data['created_epoch'] = this.createdEpoch;
    data['last_update_epoch'] = this.lastUpdateEpoch;
    data['descriptor'] = this.descriptor;
    data['descriptor_ach'] = this.descriptorAch;
    data['ach_name'] = this.achName;
    data['destination_address'] = this.destinationAddress;
    data['destination_handle'] = this.destinationHandle;
    data['handle_address'] = this.handleAddress;

    data['bank_account_name'] = this.bankAccountName;
    data['processing_type'] = this.processingType;
    return data;
  }

  @override
  List<Object> get props => [
        this.userHandle,
        this.referenceId,
        this.transactionId,
        this.transactionHash,
        this.transactionType,
        this.silaAmount,
        this.status,
        this.usdStatus,
        this.tokenStatus,
        this.created,
        this.lastUpdate,
        this.createdEpoch,
        this.lastUpdateEpoch,
        this.descriptor,
        this.descriptorAch,
        this.achName,
        this.destinationAddress,
        this.destinationHandle,
        this.handleAddress,
        this.timeline,
        this.bankAccountName,
        this.processingType
      ];
}

class Timeline extends Equatable {
  final String date;
  final String dateEpoch;
  final String status;
  final String usdStatus;
  final tokenStatus;

  Timeline(
      {this.date,
      this.dateEpoch,
      this.status,
      this.usdStatus,
      this.tokenStatus});

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      date: json['date'],
      dateEpoch: json['date_epoch'],
      status: json['status'],
      usdStatus: json['usd_status'],
      tokenStatus: json['token_status'],
    );
  }

  @override
  List<Object> get props => [
        this.date,
        this.dateEpoch,
        this.status,
        this.usdStatus,
        this.tokenStatus
      ];
}
