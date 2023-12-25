// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String name;
  String email;
  String mobile;
  String password;
  DateTime createdAt;
  int status;
  bool deleted;
  String uid;
  DocumentReference? reference;

  UserModel({
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.createdAt,
    required this.status,
    required this.deleted,
    required this.uid,
    this.reference,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? mobile,
    String? password,
    DateTime? createdAt,
    int? status,
    bool? deleted,
    String? uid,
    DocumentReference? reference,
  }) =>
      UserModel(
        name: name ?? this.name,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        password: password ?? this.password,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        deleted: deleted ?? this.deleted,
        uid: uid ?? this.uid,
        reference: reference ?? this.reference,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        password: json["password"],
        createdAt: json["createdAt"].toDate(),
        status: json["status"],
        deleted: json["deleted"],
        uid: json["uid"],
        reference: json["reference"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "mobile": mobile,
        "password": password,
        "createdAt": createdAt,
        "status": status,
        "deleted": deleted,
        "uid": uid,
        "reference": reference,
      };
}
