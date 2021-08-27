// To parse this JSON data, do
//
//     final toook = toookFromJson(jsonString);

import 'dart:convert';

Toook toookFromJson(String str) => Toook.fromJson(json.decode(str));

String toookToJson(Toook data) => json.encode(data.toJson());

class Toook {
  Toook({
    this.limit,
    this.totalGeneral,
    this.totalBlocked,
    this.general,
  });

  int limit;
  int totalGeneral;
  int totalBlocked;
  List<General> general;

  factory Toook.fromJson(Map<String, dynamic> json) => Toook(
    limit: json["limit"],
    totalGeneral: json["total_general"],
    totalBlocked: json["total_blocked"],
    general: List<General>.from(json["General"].map((x) => General.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "total_general": totalGeneral,
    "total_blocked": totalBlocked,
    "General": List<dynamic>.from(general.map((x) => x.toJson())),
  };
}

class General {
  General({
    this.id,
    this.rowNo,
    this.name,
    this.postingDate,
    this.country,
    this.blocked,
    this.email,
    this.balance,
    this.short,
  });

  int id;
  String rowNo;
  String name;
  String postingDate;
  String country;
  int blocked;
  String email;
  String balance;
  String short;

  factory General.fromJson(Map<String, dynamic> json) => General(
    id: json["id"],
    rowNo: json["row_no"],
    name: json["name"],
    postingDate: json["posting_date"],
    country: json["country"],
    blocked: json["blocked"],
    email: json["email"],
    balance: json["balance"],
    short: json["short"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "row_no": rowNo,
    "name": name,
    "posting_date": postingDate,
    "country": country,
    "blocked": blocked,
    "email": email,
    "balance": balance,
    "short": short,
  };
}