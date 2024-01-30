import 'dart:convert';

import 'package:capture/features/home/models/product.dart';

class SnapCreate {
  String? token;

  SnapCreate({
    this.token,
  });

  SnapCreate copyWith({
    String? token,
  }) =>
      SnapCreate(
        token: token ?? this.token,
      );

  factory SnapCreate.fromRawJson(String str) =>
      SnapCreate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SnapCreate.fromJson(Map<String, dynamic> json) => SnapCreate(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}

class SnapPayment {
  String? token;
  Product? product;

  SnapPayment({
    this.token,
    this.product,
  });

  SnapPayment copyWith({
    String? token,
    Product? product,
  }) =>
      SnapPayment(
        token: token ?? this.token,
        product: product ?? this.product,
      );

  factory SnapPayment.fromRawJson(String str) =>
      SnapPayment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SnapPayment.fromJson(Map<String, dynamic> json) => SnapPayment(
        token: json["token"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "product": product,
      };
}
