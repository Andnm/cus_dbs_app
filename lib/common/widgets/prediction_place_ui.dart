import 'package:cus_dbs_app/pages/main/home/map/home_map_controller.dart';
import 'package:cus_dbs_app/pages/main/home/map/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../pages/main/home/customer/home_customer_controller.dart';
import '../entities/address_model.dart';
import '../entities/prediction_model.dart';
import '../methods/common_methods.dart';

class PredictionPlaceUI extends StatefulWidget {
  PredictionModel? predictedPlaceData;

  PredictionPlaceUI({
    super.key,
    this.predictedPlaceData,
  });

  @override
  State<PredictionPlaceUI> createState() => _PredictionPlaceUIState();
}

class _PredictionPlaceUIState extends State<PredictionPlaceUI> {
  final homeCustomerController = Get.find<CustomerHomeController>();

  ///Place Details - Places API
  fetchClickedPlaceDetails(String placeID) async {
    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) =>
    //         LoadingDialog(messageText: "Getting details..."));
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    String urlPlaceDetailsAPI =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$google_api_key";

    var responseFromPlaceDetailsAPI =
        await CommonMethods.sendRequestToGoogleMapdAPI(urlPlaceDetailsAPI);
    print('API RESPONSE $responseFromPlaceDetailsAPI ');
    //Navigator.pop(context);

    if (responseFromPlaceDetailsAPI == "error") {
      return;
    }

    if (responseFromPlaceDetailsAPI["status"] == "OK") {
      AddressModel dropOffLocation = AddressModel();

      dropOffLocation.placeName = responseFromPlaceDetailsAPI["result"]["name"];
      dropOffLocation.latitudePosition =
          responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lat"];
      dropOffLocation.longitudePosition =
          responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lng"];
      dropOffLocation.placeID = placeID;

      // Provider.of<AppInfo>(context, listen: false)
      //     .updateDropOffLocation(dropOffLocation);
      homeCustomerController.state.dropOffLocation.value = dropOffLocation;

      //Navigator.pop(context, "placeSelected");
      final mapPageController = Get.find<MapController>();
      final customerHomeController = Get.find<CustomerHomeController>();

      await mapPageController.retrieveDirectionDetails();

      await customerHomeController.getAvailableNearbyOnlineDriversOnMap();

      EasyLoading.dismiss();
      Get.back(result: "placeSelected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        fetchClickedPlaceDetails(
            widget.predictedPlaceData!.place_id.toString());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      child: SizedBox(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(
                  Icons.share_location,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 13,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.predictedPlaceData!.main_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.predictedPlaceData!.secondary_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
