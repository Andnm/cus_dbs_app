class DriverItem {
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
  List<String>? roles;

  DriverItem(
      {this.access_token,
      this.tokenType,
      this.userID,
      this.expiresIn,
      this.userName,
      this.email,
      this.password,
      this.phoneNumber,
      this.name,
      this.avatar,
      this.dateLogin,
      this.roles});

  factory DriverItem.fromJson(Map<String, dynamic> json) => DriverItem(
      access_token: json["access_token"],
      tokenType: json["tokenType"],
      userID: json["userID"],
      expiresIn: json["expiresIn"],
      userName: json["userName"],
      phoneNumber: json["phoneNumber"],
      name: json['name'],
      avatar: json["avatar"],
      dateLogin: json["dateLogin"],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : []);

  Map<String, dynamic> toJson() => {
        "access_token": access_token,
        "tokenType": tokenType,
        "userID": userID,
        "expiresIn": expiresIn,
        "userName": userName,
        "phoneNumber": phoneNumber,
        "name": name,
        "avatar": avatar,
        "dateLogin": dateLogin,
        "roles": roles
      };

  @override
  String toString() {
    return 'DriverItem{access_token: $access_token, tokenType: $tokenType, userID: $userID, expiresIn: $expiresIn, userName: $userName, phoneNumber: $phoneNumber, name: $name, avatar: $avatar, dateLogin: $dateLogin, roles: $roles}';
  }
}

class DriverExternalLogin {
  String? provider;
  String? idToken;

  DriverExternalLogin({
    this.provider,
    this.idToken,
  });

  Map<String, dynamic> toJson() => {
        "provider": provider,
        "idToken": idToken,
      };
}

class DriverInternalLogin {
  String? email;
  String? password;

  DriverInternalLogin({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

class OnlineNearByDriver {
  String? id;
  String? email;
  bool? isOnline;
  double? latitude;
  double? longitude;

  OnlineNearByDriver({
    this.id,
    this.email,
    this.isOnline,
    this.latitude,
    this.longitude,
  });

  factory OnlineNearByDriver.fromJson(Map<String, dynamic> json) =>
      OnlineNearByDriver(
        id: json["id"],
        email: json["email"],
        isOnline: json["isOnline"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  @override
  String toString() {
    return 'OnlineNearByDriver{id: $id, email: $email, isOnline: $isOnline, latitude: $latitude, longitude: $longitude}';
  }
}
