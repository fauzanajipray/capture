import 'dart:convert';

class Notif {
  String? idUser;
  String? nameUser;
  String? fillNotif;
  String? stsNotif;
  String? namaMerchant;
  String? logo;
  int? totalHargaPackageMerchant;
  DateTime? createdAt;

  Notif({
    this.idUser,
    this.nameUser,
    this.fillNotif,
    this.stsNotif,
    this.namaMerchant,
    this.logo,
    this.totalHargaPackageMerchant,
    this.createdAt,
  });

  get statusPembayaran => null;

  Notif copyWith({
    String? idUser,
    String? nameUser,
    String? fillNotif,
    String? stsNotif,
    String? namaMerchant,
    String? logo,
    int? totalHargaPackageMerchant,
    DateTime? createdAt,
  }) =>
      Notif(
        idUser: idUser ?? this.idUser,
        nameUser: nameUser ?? this.nameUser,
        fillNotif: fillNotif ?? this.fillNotif,
        stsNotif: stsNotif ?? this.stsNotif,
        namaMerchant: namaMerchant ?? this.namaMerchant,
        logo: logo ?? this.logo,
        totalHargaPackageMerchant:
            totalHargaPackageMerchant ?? this.totalHargaPackageMerchant,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Notif.fromRawJson(String str) => Notif.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Notif.fromJson(Map<String, dynamic> json) => Notif(
        idUser: json["id_user"],
        nameUser: json["name_user"],
        fillNotif: json["fill_notification"],
        stsNotif: json["sts_notif"],
        namaMerchant: json["nama_merchant"],
        logo: json["logo"],
        totalHargaPackageMerchant:
            int.parse(json["total_harga_package_merchant"] ?? '0'),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "name_user": nameUser,
        "fill_Notif": fillNotif,
        "sts_notif": stsNotif,
        "nama_merchant": namaMerchant,
        "logo": logo,
        "total_harga_package_merchant": totalHargaPackageMerchant,
        "created_at": createdAt?.toIso8601String(),
      };
}
