import 'dart:convert';

class CustomerItem {
  String? access_token;
  String? tokenType;
  String? userID;
  int? expiresIn;
  String? userName;
  String? email;
  String? password;
  String? phoneNumber;
  String? name;
  String? avatar;
  String? dateLogin;
  String? address;
  String? gender;
  String? dob;

  List<String>? roles;

  CustomerItem({
    this.access_token,
    this.tokenType,
    this.userID,
    this.expiresIn,
    this.userName,
    this.phoneNumber,
    this.email,
    this.password,
    this.name,
    this.avatar,
    this.dateLogin,
    this.roles,
    this.address,
    this.gender,
    this.dob,
  });

  String get getName => name ?? userName ?? '';
  String get getEmail => email ?? '';

  factory CustomerItem.fromJson(Map<String, dynamic> json) => CustomerItem(
      access_token: json["access_token"],
      tokenType: json["tokenType"],
      userID: json["userID"],
      expiresIn: json["expiresIn"],
      phoneNumber: json["phoneNumber"],
      email: json["email"] ?? "",
      userName: json['userName'],
      name: json['name'],
      avatar: json["avatar"],
      address: json["address"] ?? "",
      gender: json["gender"] ?? "",
      dob: json["dob"] ?? "",
      dateLogin: json["dateLogin"],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : []);

  Map<String, dynamic> toJson() => {
        "access_token": access_token,
        "tokenType": tokenType,
        "userID": userID,
        "expiresIn": expiresIn,
        "phoneNumber": phoneNumber,
        "email": email,
        "userName": userName,
        "password": password,
        "name": name,
        "avatar": avatar,
        "dateLogin": dateLogin,
        "roles": roles
      };

  @override
  String toString() {
    return 'CustomerItem{access_token: $access_token, tokenType: $tokenType, userID: $userID, expiresIn: $expiresIn, userName: $userName, phoneNumber: $phoneNumber, name: $name, avatar: $avatar, dateLogin: $dateLogin, roles: $roles}';
  }
}

class CustomerExternalLogin {
  String? provider;
  String? idToken;

  CustomerExternalLogin({
    this.provider,
    this.idToken,
  });

  Map<String, dynamic> toJson() => {
        "provider": provider,
        "idToken": idToken,
      };
}

class CustomerInternalLogin {
  String? email;
  String? password;

  CustomerInternalLogin({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };

  @override
  String toString() {
    return "(email: $email,password: $password)";
  }
}

class CustomerRegister {
  String? userName;
  String? email;
  String? password;

  CustomerRegister({
    this.userName,
    this.password,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "password": password,
        "email": email,
      };
}

class CustomerUpdateProfile {
  String? name;
  String? address;
  String? phoneNumber;
  String? gender;
  String? dob;

  CustomerUpdateProfile({
    this.name,
    this.address,
    this.phoneNumber,
    this.gender,
    this.dob,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "dob": dob,
      };
}
