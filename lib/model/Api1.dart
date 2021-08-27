
import 'dart:convert';

Loginapi loginapiFromJson(String str) => Loginapi.fromJson(json.decode(str));

String loginapiToJson(Loginapi data) => json.encode(data.toJson());

class Loginapi {
  Loginapi({
    this.title,
    this.type,
    this.message,
    this.data,
  });

  String title;
  int type;
  List<dynamic> message;
  Data data;

  factory Loginapi.fromJson(Map<String, dynamic> json) => Loginapi(
    title: json["title"],
    type: json["type"],
    message: List<dynamic>.from(json["message"].map((x) => x)),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "type": type,
    "message": List<dynamic>.from(message.map((x) => x)),
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.email,
    this.name,
    this.apiToken,
    this.companyId,
    this.companyJson,
    this.roleId,
    this.updatedAt,
    this.image,
    this.designation,
    this.companies,
  });

  int id;
  String email;
  String name;
  String apiToken;
  int companyId;
  String companyJson;
  int roleId;
  DateTime updatedAt;
  String image;
  String designation;
  List<Company> companies;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    apiToken: json["api_token"],
    companyId: json["company_id"],
    companyJson: json["company_json"],
    roleId: json["role_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    image: json["image"],
    designation: json["designation"],
    companies: List<Company>.from(json["companies"].map((x) => Company.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "api_token": apiToken,
    "company_id": companyId,
    "company_json": companyJson,
    "role_id": roleId,
    "updated_at": updatedAt.toIso8601String(),
    "image": image,
    "designation": designation,
    "companies": List<dynamic>.from(companies.map((x) => x.toJson())),
  };
}

class Company {
  Company({
    this.id,
    this.name,
    this.code,
    this.logo,
    this.domain,
  });

  int id;
  String name;
  String code;
  String logo;
  String domain;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    logo: json["logo"],
    domain: json["domain"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "logo": logo,
    "domain": domain,
  };
}