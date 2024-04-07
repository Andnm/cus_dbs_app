class UpdateIdentity {
  String? fullName;
  String? dob;
  String? gender;
  String? nationality;
  String? placeOrigin;
  String? placeResidence;
  String? personalIdentification;
  String? expiredDate;

  UpdateIdentity({
    this.fullName,
    this.dob,
    this.gender,
    this.nationality,
    this.placeOrigin,
    this.placeResidence,
    this.personalIdentification,
    this.expiredDate,
  });

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "dob": dob,
        "gender": gender,
        "nationality": nationality,
        "placeOrigin": placeOrigin,
        "placeResidence": placeResidence,
        "personalIdentification": personalIdentification,
        "expiredDate": expiredDate,
      };
}
