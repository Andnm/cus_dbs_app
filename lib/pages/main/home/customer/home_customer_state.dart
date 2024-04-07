import 'package:cus_dbs_app/app/booking_status_type.dart';
import 'package:cus_dbs_app/common/entities/address_model.dart';
import 'package:cus_dbs_app/common/entities/direction_detail.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../common/entities/driver.dart';

class CustomerHomeState {
  Rx<AddressModel?> pickUpLocation = AddressModel().obs;
  Rx<AddressModel?> dropOffLocation = AddressModel().obs;
  Rx<DirectionDetails?> tripDirectionDetailsInfo = DirectionDetails().obs;
  RxList<OnlineNearByDriver?> availableNearbyOnlineDriversList =
      <OnlineNearByDriver>[].obs;
}
