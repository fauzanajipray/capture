import 'dart:convert';

class History {
  String? idRekapPembayaran;
  String? statusPembayaran;
  String? namaMerchant;
  String? logo;
  int? totalHargaPackageMerchant;
  String? nama;
  DateTime? createdAt;

  History({
    this.idRekapPembayaran,
    this.statusPembayaran,
    this.namaMerchant,
    this.logo,
    this.totalHargaPackageMerchant,
    this.nama,
    this.createdAt,
  });

  History copyWith({
    String? idRekapPembayaran,
    String? statusPembayaran,
    String? namaMerchant,
    String? logo,
    int? totalHargaPackageMerchant,
    String? nama,
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
        createdAt: createdAt ?? this.createdAt,
      );

  factory History.fromRawJson(String str) => History.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory History.fromJson(Map<String, dynamic> json) => History(
        idRekapPembayaran: json["id_rekap_pembayaran"],
        statusPembayaran: json["status_pembayaran"],
        namaMerchant: json["nama_merchant"],
        logo: json["logo"],
        totalHargaPackageMerchant:
            int.parse(json["total_harga_package_merchant"] ?? '0'),
        nama: json["nama"],
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
        "created_at": createdAt?.toIso8601String(),
      };
}
