import 'package:cus_dbs_app/pages/main/home/map/values/sizes.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'index.dart';

class MapPage extends GetView<MapController> {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.state.currentLocation.value.latitude == null ||
            controller.state.currentLocation.value.longitude == null)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: [
              GoogleMap(
                padding: EdgeInsets.only(top: 26, bottom: 0),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      controller.state.currentLocation.value.latitude ?? 0.0,
                      controller.state.currentLocation.value.longitude ?? 0.0),
                  zoom: 13.5,
                ),
                // polylines: {
                //   Polyline(
                //     polylineId: PolylineId('route'),
                //     points: controller.state.polylineCoordinates,
                //     color: Colors.blue,
                //     width: 6,
                //   ),
                // },
                polylines: controller.state.polylineSet,

                circles: controller.state.circleSet,
                markers: controller.state.markerSet,
                onMapCreated: (GoogleMapController mapController) {
                  controller.controllerOfGoogleMap = mapController;

                  //controller.updateMapTheme(controller.controllerOfGoogleMap!); null
                  controller.mapCompletePageController
                      .complete(controller.controllerOfGoogleMap);
                  bottomMapPadding.value = 300;
                  controller.getCurrentLocation(() {});
                },
                // onCameraMove: (CameraPosition newPosition) {

                // },
              ),
            ],
          ));
  }
}
