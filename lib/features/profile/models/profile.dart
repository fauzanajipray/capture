import 'dart:convert';

class Profile {
  String? idUser;
  String? nama;
  String? username;
  String? email;
  String? password;
  String? phone;
  DateTime? tglLahir;
  String? gender;
  String? idRole;
  String? isActive;
  String? fotoUser;
  String? deleteSts;
  DateTime? createdAt;
  DateTime? updatedAt;

  Profile({
    this.idUser,
    this.nama,
    this.username,
    this.email,
    this.password,
    this.phone,
    this.tglLahir,
    this.gender,
    this.idRole,
    this.isActive,
    this.fotoUser,
    this.deleteSts,
    this.createdAt,
    this.updatedAt,
  });

  Profile copyWith({
    String? idUser,
    String? nama,
    String? username,
    String? email,
    String? password,
    String? phone,
    DateTime? tglLahir,
    String? gender,
    String? idRole,
    String? isActive,
    String? fotoUser,
    String? deleteSts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Profile(
        idUser: idUser ?? this.idUser,
        nama: nama ?? this.nama,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        phone: phone ?? this.phone,
        tglLahir: tglLahir ?? this.tglLahir,
        gender: gender ?? this.gender,
        idRole: idRole ?? this.idRole,
        isActive: isActive ?? this.isActive,
        fotoUser: fotoUser ?? this.fotoUser,
        deleteSts: deleteSts ?? this.deleteSts,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Profile.fromRawJson(String str) => Profile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        idUser: json["id_user"],
        nama: json["nama"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        tglLahir: json["tgl_lahir"] == null
            ? null
            : DateTime.parse(json["tgl_lahir"]),
        gender: json["gender"],
        idRole: json["id_role"],
        isActive: json["is_active"],
        fotoUser: json["foto_user"],
        deleteSts: json["delete_sts"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "nama": nama,
        "username": username,
        "email": email,
        "password": password,
        "phone": phone,
        "tgl_lahir": (tglLahir == null)
            ? null
            : "${tglLahir!.year.toString().padLeft(4, '0')}-${tglLahir!.month.toString().padLeft(2, '0')}-${tglLahir!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "id_role": idRole,
        "is_active": isActive,
        "foto_user": fotoUser,
        "delete_sts": deleteSts,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
