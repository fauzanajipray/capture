import 'dart:convert';

class History {
  String? idRekapPembayaran;
  String? statusPembayaran;
  String? namaMerchant;
  String? logo;
  int? totalHargaPackageMerchant;
  String? nama;
  String? token;
  String? noOrder;
  DateTime? createdAt;

  History({
    this.idRekapPembayaran,
    this.statusPembayaran,
    this.namaMerchant,
    this.logo,
    this.totalHargaPackageMerchant,
    this.nama,
    this.token,
    this.noOrder,
    this.createdAt,
  });

  History copyWith({
    String? idRekapPembayaran,
    String? statusPembayaran,
    String? namaMerchant,
    String? logo,
    int? totalHargaPackageMerchant,
    String? nama,
    String? token,
    String? noOrder,
    DateTime? createdAt,
  }) =>
      History(
        idRekapPembayaran: idRekapPembayaran ?? this.idRekapPembayaran,
        statusPembayaran: statusPembayaran ?? this.statusPembayaran,
        namaMerchant: namaMerchant ?? this.namaMerchant,
        logo: logo ?? this.logo,
        totalHargaPackageMerchant:
            totalHargaPackageMerchant ?? this.totalHargaPackageMerchant,
        nama: nama ?? this.nama,
        token: token ?? this.token,
        noOrder: noOrder ?? this.noOrder,
        createdAt: createdAt ?? this.createdAt,
      );

  factory History.fromRawJson(String str) => History.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory History.fromJson(Map<String, dynamic> json) => History(
        idRekapPembayaran: json["id_rekap_pembayaran"],
        statusPembayaran: json["status_pembayaran"],
        namaMerchant: json["nama_merchant"],
        logo: json["logo"],
        totalHargaPackageMerchant: (json["total_harga_package_merchant"] is int)
            ? json["total_harga_package_merchant"]
            : int.tryParse(json["total_harga_package_merchant"]),
        nama: json["nama"],
        noOrder: json['no_order'],
        token: json['token'],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_rekap_pembayaran": idRekapPembayaran,
        "status_pembayaran": statusPembayaran,
        "nama_merchant": namaMerchant,
        "logo": logo,
        "total_harga_package_merchant": totalHargaPackageMerchant,
        "nama": nama,
        "token": token,
        "created_at": createdAt?.toIso8601String(),
      };
}
