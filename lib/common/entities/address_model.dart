class AddressModel {
  String? humanReadableAddress;
  double? latitudePosition;
  double? longitudePosition;
  String? placeID;
  String? placeName;

  AddressModel({
    this.humanReadableAddress,
    this.latitudePosition,
    this.longitudePosition,
    this.placeID,
    this.placeName,
  });

  factory AddressModel.fromMap(Map<String, dynamic> dataMap) {
    return AddressModel(
      humanReadableAddress: dataMap['humanReadableAddress'] as String?,
      latitudePosition: dataMap['latitudePosition'] as double?,
      longitudePosition: dataMap['longitudePosition'] as double?,
      placeID: dataMap['placeID'] as String?,
      placeName: dataMap['placeName'] as String?,
    );
  }

  @override
  String toString() {
    return 'AddressModel{humanReadableAddress: $humanReadableAddress, latitudePosition: $latitudePosition, longitudePosition: $longitudePosition, placeID: $placeID, placeName: $placeName}';
  }
}
