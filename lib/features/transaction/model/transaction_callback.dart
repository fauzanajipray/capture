import 'dart:convert';

class TransactionCallback {
  String? transactionStatus;
  String? statusMessage;
  String? transactionId;
  String? orderId;
  String? paymentType;

  TransactionCallback({
    this.transactionStatus,
    this.statusMessage,
    this.transactionId,
    this.orderId,
    this.paymentType,
  });

  TransactionCallback copyWith({
    String? transactionStatus,
    String? statusMessage,
    String? transactionId,
    String? orderId,
    String? paymentType,
  }) =>
      TransactionCallback(
        transactionStatus: transactionStatus ?? this.transactionStatus,
        statusMessage: statusMessage ?? this.statusMessage,
        transactionId: transactionId ?? this.transactionId,
        orderId: orderId ?? this.orderId,
        paymentType: paymentType ?? this.paymentType,
      );

  factory TransactionCallback.fromRawJson(String str) =>
      TransactionCallback.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionCallback.fromJson(Map<String, dynamic> json) =>
      TransactionCallback(
        transactionStatus: json["transactionStatus"],
        statusMessage: json["statusMessage"],
        transactionId: json["transactionId"],
        orderId: json["orderId"],
        paymentType: json["paymentType"],
      );

  Map<String, dynamic> toJson() => {
        "transactionStatus": transactionStatus,
        "statusMessage": statusMessage,
        "transactionId": transactionId,
        "orderId": orderId,
        "paymentType": paymentType,
      };
}
