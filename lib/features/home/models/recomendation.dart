import 'dart:convert';

class Recomendation {
  String? idMerchant;
  String? idKategori;
  String? namaMerchant;
  String? logo;
  String? deskripsi;
  String? linkYoutube;
  int? totalHargaPackageMerchant;
  String? stsRekomendasi;
  String? deleteSts;
  DateTime? createdAt;
  DateTime? updatedAt;

  Recomendation({
    this.idMerchant,
    this.idKategori,
    this.namaMerchant,
    this.logo,
    this.deskripsi,
    this.linkYoutube,
    this.totalHargaPackageMerchant,
    this.stsRekomendasi,
    this.deleteSts,
    this.createdAt,
    this.updatedAt,
  });

  Recomendation copyWith({
    String? idMerchant,
    String? idKategori,
    String? namaMerchant,
    String? logo,
    String? deskripsi,
    String? linkYoutube,
    int? totalHargaPackageMerchant,
    String? stsRekomendasi,
    String? deleteSts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Recomendation(
        idMerchant: idMerchant ?? this.idMerchant,
        idKategori: idKategori ?? this.idKategori,
        namaMerchant: namaMerchant ?? this.namaMerchant,
        logo: logo ?? this.logo,
        deskripsi: deskripsi ?? this.deskripsi,
        linkYoutube: linkYoutube ?? this.linkYoutube,
        totalHargaPackageMerchant:
            totalHargaPackageMerchant ?? this.totalHargaPackageMerchant,
        stsRekomendasi: stsRekomendasi ?? this.stsRekomendasi,
        deleteSts: deleteSts ?? this.deleteSts,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Recomendation.fromRawJson(String str) =>
      Recomendation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Recomendation.fromJson(Map<String, dynamic> json) => Recomendation(
        idMerchant: json["id_merchant"],
        idKategori: json["id_kategori"],
        namaMerchant: json["nama_merchant"],
        logo: json["logo"],
        deskripsi: json["deskripsi"],
        linkYoutube: json["link_youtube"],
        totalHargaPackageMerchant:
            int.parse(json["total_harga_package_merchant"]),
        stsRekomendasi: json["sts_rekomendasi"],
        deleteSts: json["delete_sts"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_merchant": idMerchant,
        "id_kategori": idKategori,
        "nama_merchant": namaMerchant,
        "logo": logo,
        "deskripsi": deskripsi,
        "link_youtube": linkYoutube,
        "total_harga_package_merchant": totalHargaPackageMerchant,
        "sts_rekomendasi": stsRekomendasi,
        "delete_sts": deleteSts,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
