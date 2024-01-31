import 'dart:convert';

class Callback {
  String? idRekapPembayaran;
  String? statusPembayaran;
  String? noOrder;
  String? namaMerchant;
  String? logo;
  int? totalHargaPackageMerchant;
  String? nama;
  DateTime? createdAt;

  Callback({
    this.idRekapPembayaran,
    this.statusPembayaran,
    this.noOrder,
    this.namaMerchant,
    this.logo,
    this.totalHargaPackageMerchant,
    this.nama,
    this.createdAt,
  });

  Callback copyWith({
    String? idRekapPembayaran,
    String? statusPembayaran,
    String? noOrder,
    String? namaMerchant,
    String? logo,
    int? totalHargaPackageMerchant,
    String? nama,
    DateTime? createdAt,
  }) =>
      Callback(
        idRekapPembayaran: idRekapPembayaran ?? this.idRekapPembayaran,
        statusPembayaran: statusPembayaran ?? this.statusPembayaran,
        noOrder: noOrder ?? this.noOrder,
        namaMerchant: namaMerchant ?? this.namaMerchant,
        logo: logo ?? this.logo,
        totalHargaPackageMerchant:
            totalHargaPackageMerchant ?? this.totalHargaPackageMerchant,
        nama: nama ?? this.nama,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Callback.fromRawJson(String str) =>
      Callback.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Callback.fromJson(Map<String, dynamic> json) => Callback(
        idRekapPembayaran: json["id_rekap_pembayaran"],
        statusPembayaran: json["status_pembayaran"],
        noOrder: json["no_order"],
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
        "no_order": noOrder,
        "nama_merchant": namaMerchant,
        "logo": logo,
        "total_harga_package_merchant": totalHargaPackageMerchant,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
      };
}
