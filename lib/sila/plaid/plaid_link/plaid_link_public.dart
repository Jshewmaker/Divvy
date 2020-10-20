class PlaidPublicTokenExchangeResponseModel {
    String accessToken;
    String itemID;
    String requestID;

    PlaidPublicTokenExchangeResponseModel({this.accessToken, this.itemID, this.requestID});

    factory PlaidPublicTokenExchangeResponseModel.fromJson(Map<String, dynamic> json) {
        return PlaidPublicTokenExchangeResponseModel(
            accessToken: json['access_token'], 
            itemID: json['item_id'], 
            requestID: json['request_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['access_token'] = this.accessToken;
        data['item_id'] = this.itemID;
        data['request_id'] = this.requestID;
        return data;
    }
}

