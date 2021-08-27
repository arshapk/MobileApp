// To parse this JSON data, do
//
//     final api3 = api3FromJson(jsonString);

import 'dart:convert';

Api3 api3FromJson(String str) => Api3.fromJson(json.decode(str));

String api3ToJson(Api3 data) => json.encode(data.toJson());

class Api3 {
  Api3({
    this.limit,
    this.totalGeneral,
    this.totalBlocked,
    this.blocked,
  });

  int limit;
  int totalGeneral;
  int totalBlocked;
  List<Blocked> blocked;

  factory Api3.fromJson(Map<String, dynamic> json) => Api3(
    limit: json["limit"],
    totalGeneral: json["total_general"],
    totalBlocked: json["total_blocked"],
    blocked: List<Blocked>.from(json["Blocked"].map((x) => Blocked.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "total_general": totalGeneral,
    "total_blocked": totalBlocked,
    "Blocked": List<dynamic>.from(blocked.map((x) => x.toJson())),
  };
}

class Blocked {
  Blocked({
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

  factory Blocked.fromJson(Map<String, dynamic> json) => Blocked(
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

// To parse this JSON data, do
//
//     final filecust = filecustFromJson(jsonString);

Filecust filecustFromJson(String str) => Filecust.fromJson(json.decode(str));

String filecustToJson(Filecust data) => json.encode(data.toJson());

class Filecust {
  Filecust({
    this.customer,
    this.secured,
    this.inSecured,
  });

  List<dynamic> customer;
  List<Secured> secured;
  List<Secured> inSecured;

  factory Filecust.fromJson(Map<String, dynamic> json) => Filecust(
    customer: List<dynamic>.from(json["Customer"].map((x) => x)),
    secured: List<Secured>.from(json["Secured"].map((x) => Secured.fromJson(x))),
    inSecured: List<Secured>.from(json["InSecured"].map((x) => Secured.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Customer": List<dynamic>.from(customer.map((x) => x)),
    "Secured": List<dynamic>.from(secured.map((x) => x.toJson())),
    "InSecured": List<dynamic>.from(inSecured.map((x) => x.toJson())),
  };
}

class Secured {
  Secured({
    this.id,
    this.jobId,
    this.title,
    this.file,
    this.type,
    this.size,
    this.postingDate,
    this.service,
    this.userName,
  });

  int id;
  int jobId;
  String title;
  String file;
  Type type;
  String size;
  String postingDate;
  Service service;
  UserName userName;

  factory Secured.fromJson(Map<String, dynamic> json) => Secured(
    id: json["id"],
    jobId: json["job_id"],
    title: json["title"],
    file: json["file"],
    type: typeValues.map[json["type"]],
    size: json["size"],
    postingDate: json["posting_date"],
    service: serviceValues.map[json["service"]],
    userName: userNameValues.map[json["user_name"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "job_id": jobId,
    "title": title,
    "file": file,
    "type": typeValues.reverse[type],
    "size": size,
    "posting_date": postingDate,
    "service": serviceValues.reverse[service],
    "user_name": userNameValues.reverse[userName],
  };
}

enum Service { CUSTOMS_CLEARANCE }

final serviceValues = EnumValues({
  "Customs Clearance": Service.CUSTOMS_CLEARANCE
});

enum Type { JPEG, JPG, PNG }

final typeValues = EnumValues({
  "jpeg": Type.JPEG,
  "jpg": Type.JPG,
  "png": Type.PNG
});

enum UserName { DHINESH_DHIRAN }

final userNameValues = EnumValues({
  "Dhinesh Dhiran": UserName.DHINESH_DHIRAN
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
