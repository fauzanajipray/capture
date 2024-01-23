import 'dart:convert';

class Category {
  String? idKategori;
  String? namaKategori;
  String? logo;
  String? deleteSts;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    this.idKategori,
    this.namaKategori,
    this.logo,
    this.deleteSts,
    this.createdAt,
    this.updatedAt,
  });

  Category copyWith({
    String? idKategori,
    String? namaKategori,
    String? logo,
    String? deleteSts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Category(
        idKategori: idKategori ?? this.idKategori,
        namaKategori: namaKategori ?? this.namaKategori,
        logo: logo ?? this.logo,
        deleteSts: deleteSts ?? this.deleteSts,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        idKategori: json["id_kategori"],
        namaKategori: json["nama_kategori"],
        logo: json["logo"],
        deleteSts: json["delete_sts"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_kategori": idKategori,
        "nama_kategori": namaKategori,
        "logo": logo,
        "delete_sts": deleteSts,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
