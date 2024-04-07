import 'package:cus_dbs_app/common/entities/address_model.dart';
import 'package:cus_dbs_app/common/entities/place.dart';

class SearchRequestModel {
  double? pickupLatitude;
  double? pickupLongtitude;

  double? dropOffLatitude;
  double? dropOffLongtitude;

  String? id;
  num? price;
  SearchRequestModel(
      {this.id,
      this.pickupLatitude,
      this.pickupLongtitude,
      this.dropOffLatitude,
      this.dropOffLongtitude,
      this.price});

  factory SearchRequestModel.fromJson(Map<String, dynamic> json) =>
      SearchRequestModel(
        id: json['id'],
        pickupLatitude: json['pickupLatitude'],
        pickupLongtitude: json['pickupLongtitude'],
        dropOffLatitude: json["dropOffLatitude"],
        dropOffLongtitude: json["dropOffLongtitude"],
        price: json["price"],
      );
  Map<String, dynamic> toJson() => {
        'pickupLatitude': pickupLatitude,
        'pickupLongtitude': pickupLongtitude,
        'dropOffLatitude': dropOffLatitude,
        'dropOffLongtitude': dropOffLongtitude,
        'price': price,
      };

  @override
  String toString() {
    return 'SearchRequestModel{pickupLatitude: $pickupLatitude, pickupLongtitude: $pickupLongtitude, dropOffLatitude: $dropOffLatitude, dropOffLongtitude: $dropOffLongtitude, searchRequestId: $id, price: $price}';
  }
}
