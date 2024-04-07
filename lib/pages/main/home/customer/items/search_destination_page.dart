import 'package:cus_dbs_app/pages/main/home/customer/home_customer_controller.dart';
import 'package:cus_dbs_app/pages/main/home/map/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../common/entities/prediction_model.dart';
import '../../../../../common/methods/common_methods.dart';
import '../../../../../common/widgets/prediction_place_ui.dart';

class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});
  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {
  final homeCustomerController = Get.find<CustomerHomeController>();

  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController =
      TextEditingController();
  List<PredictionModel> dropOffPredictionsPlacesList = [];

  ///Places API - Place AutoComplete
  searchLocation(String locationName) async {
    if (locationName.length > 1) {
      String apiPlacesUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$locationName&key=$google_api_key&components=country:vn&location=10.7769,106.7009&radius=20000";

      var responseFromPlacesAPI =
          await CommonMethods.sendRequestToGoogleMapdAPI(apiPlacesUrl);

      if (responseFromPlacesAPI == "error") {
        print('Error to request Places API');
        return;
      }

      if (responseFromPlacesAPI["status"] == "OK") {
        var predictionResultInJson = responseFromPlacesAPI["predictions"];
        var predictionsList = (predictionResultInJson as List)
            .map((eachPlacePrediction) =>
                PredictionModel.fromJson(eachPlacePrediction))
            .toList();

        setState(() {
          dropOffPredictionsPlacesList = predictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String userAddress = homeCustomerController
            .state.pickUpLocation.value?.humanReadableAddress ??
        '';

    pickUpTextEditingController.text = userAddress;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24, top: 48, right: 24, bottom: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 6,
                      ),

                      //icon button - title
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const Center(
                            child: Text(
                              "Set Dropoff Location",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      //pickup text field
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/initial.png",
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Container(
                              // decoration: BoxDecoration(
                              //   color: Colors.grey,
                              //   borderRadius: BorderRadius.circular(5),
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  maxLines: 1,
                                  controller: pickUpTextEditingController,
                                  decoration: InputDecoration(
                                      hintText: "Pickup Address",
                                      fillColor: Colors.white70,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                          left: 11, top: 9, bottom: 9)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 11,
                      ),

                      //destination text field
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/final.png",
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Container(
                              // decoration: BoxDecoration(
                              //   color: Colors.grey,
                              //   borderRadius: BorderRadius.circular(5),
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  maxLines: 1,
                                  controller: destinationTextEditingController,
                                  onChanged: (inputText) {
                                    searchLocation(inputText);
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Destination Address",
                                      fillColor: Colors.white70,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                          left: 11, top: 9, bottom: 9)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //display prediction results for destination place
            (dropOffPredictionsPlacesList.length > 0)
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          child: PredictionPlaceUI(
                            predictedPlaceData:
                                dropOffPredictionsPlacesList[index],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 2,
                      ),
                      itemCount: dropOffPredictionsPlacesList.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
