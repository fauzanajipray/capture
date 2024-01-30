import 'dart:convert';

class ProductDetail {
  String? idMerchant;
  String? namaMerchant;
  String? logo;
  String? deskripsi;
  String? linkYoutube;
  int? totalHargaPackageMerchant;
  List<Packagemerchant>? packagemerchant;

  ProductDetail({
    this.idMerchant,
    this.namaMerchant,
    this.logo,
    this.deskripsi,
    this.linkYoutube,
    this.totalHargaPackageMerchant,
    this.packagemerchant,
  });

  ProductDetail copyWith({
    String? idMerchant,
    String? namaMerchant,
    String? logo,
    String? deskripsi,
    String? linkYoutube,
    int? totalHargaPackageMerchant,
    List<Packagemerchant>? packagemerchant,
  }) =>
      ProductDetail(
        idMerchant: idMerchant ?? this.idMerchant,
        namaMerchant: namaMerchant ?? this.namaMerchant,
        logo: logo ?? this.logo,
        deskripsi: deskripsi ?? this.deskripsi,
        linkYoutube: linkYoutube ?? this.linkYoutube,
        totalHargaPackageMerchant:
            totalHargaPackageMerchant ?? this.totalHargaPackageMerchant,
        packagemerchant: packagemerchant ?? this.packagemerchant,
      );

  factory ProductDetail.fromRawJson(String str) =>
      ProductDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        idMerchant: json["id_merchant"],
        namaMerchant: json["nama_merchant"],
        logo: json["logo"],
        deskripsi: json["deskripsi"],
        linkYoutube: json["link_youtube"],
        totalHargaPackageMerchant: (json["total_harga_package_merchant"] is int)
            ? json["total_harga_package_merchant"]
            : int.tryParse(json["total_harga_package_merchant"]),
        packagemerchant: json["packagemerchant"] == null
            ? []
            : List<Packagemerchant>.from(json["packagemerchant"]!
                .map((x) => Packagemerchant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_merchant": idMerchant,
        "nama_merchant": namaMerchant,
        "logo": logo,
        "deskripsi": deskripsi,
        "link_youtube": linkYoutube,
        "total_harga_package_merchant": totalHargaPackageMerchant,
        "packagemerchant": packagemerchant == null
            ? []
            : List<dynamic>.from(packagemerchant!.map((x) => x.toJson())),
      };
}

class Packagemerchant {
  String? id;
  String? name;

  Packagemerchant({
    this.id,
    this.name,
  });

  Packagemerchant copyWith({
    String? id,
    String? name,
  }) =>
      Packagemerchant(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Packagemerchant.fromRawJson(String str) =>
      Packagemerchant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Packagemerchant.fromJson(Map<String, dynamic> json) =>
      Packagemerchant(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
