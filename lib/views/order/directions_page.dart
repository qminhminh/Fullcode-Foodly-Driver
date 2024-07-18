import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_driver/common/app_style.dart';
import 'package:foodly_driver/common/custom_btn.dart';
import 'package:foodly_driver/common/divida.dart';
import 'package:foodly_driver/common/reusable_text.dart';
import 'package:foodly_driver/common/row_text.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:foodly_driver/controllers/location_controller.dart';
import 'package:foodly_driver/models/distance_time.dart';
import 'package:foodly_driver/services/distance.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsPage extends StatefulWidget {
  const DirectionsPage({super.key, required});

  @override
  State<DirectionsPage> createState() => _DirectionsPageState();
}

class _DirectionsPageState extends State<DirectionsPage> {
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Placemark? place;
  String googleApiKey = "AIzaSyB4lViZNqNgOWIYse9C3MKxzgSSshF7St8";
  late GoogleMapController mapController;
  LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng _restaurant = const LatLng(37.7786, -122.4181);

  Map<MarkerId, Marker> markers = {};
  String image =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/5c2a9ca8-eb07-400b-b8a6-2acfab2a9ee2-image001.webp";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _center,
          zoom: 15.0,
          bearing: 50,
        ),
      ));

      _addMarker(_center, "current_location");
      _addMarker(LatLng(_restaurant.latitude, _restaurant.longitude),
          "restaurant_location");
      _getPolyline();
    });
  }

  void _addMarker(LatLng position, String id) {
    setState(() {
      final markerId = MarkerId(id);
      final marker = Marker(
        markerId: markerId,
        position: position,
        infoWindow: const InfoWindow(title: 'Current Location'),
      );
      markers[markerId] = marker;
    });
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(_center.latitude, _center.longitude),
      PointLatLng(_restaurant.latitude, _restaurant.longitude),
      travelMode: TravelMode.driving,
      optimizeWaypoints: true,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    _addPolyLine();
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: kPrimary, points: polylineCoordinates, width: 6);
    polylines[id] = polyline;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final location = Get.put(UserLocationController());
    DistanceTime distanceTime = Distance().calculateDistanceTimePrice(
        location.currentLocation.latitude,
        location.currentLocation.longitude,
        _restaurant.latitude,
        _restaurant.longitude,
        10,
        2.00);

    String numberString = "25 min".substring(0, 2);
    double totalTime = double.parse(numberString) + distanceTime.time;

    LatLng restaurant = LatLng(_restaurant.latitude, _restaurant.longitude);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: restaurant,
              zoom: 30.0,
            ),
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            bottom: 70.h,
            left: 0,
            right: 0,
            child: Container(
              width: width,
              height: hieght / 3.25,
              decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r))),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 12.h),
                decoration: BoxDecoration(
                    color: kLightWhite,
                    borderRadius: BorderRadius.circular(20.r)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                            text: "The Kings",
                            style: appStyle(20, kGray, FontWeight.bold)),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: kTertiary,
                          backgroundImage:
                              NetworkImage(image),
                        ),
                      ],
                    ),
                    const Divida(),
                    RowText(
                        first: "Distance To Restaurant",
                        second:
                            "${distanceTime.distance.toStringAsFixed(3)} km"),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Price From Current Location",
                        second: "\$ ${distanceTime.price.toStringAsFixed(3)}"),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Estimated Delivery Time",
                        second: "${totalTime.toStringAsFixed(0)} mins"),
                    SizedBox(
                      height: 5.h,
                    ),
                    const RowText(
                        first: "Business Hours", second: "10:00 AM - 10:00 PM"),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Divida(),
                    const RowText(
                        first: "Address",
                        second: "153 Main Street, San Francisco, CA"),
                    SizedBox(
                      height: 10.h,
                    ),
                    const CustomButton(
                      color: kPrimary,
                      btnHieght: 35,
                      radius: 6,
                      text: "Make a reservation",
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 50.h,
            left: 12.w,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              width: width,
              height: 30.h,
              decoration: BoxDecoration(
                  color: kOffWhite,
                  border: Border.all(color: kPrimary, width: 1),
                  borderRadius: BorderRadius.circular(20.r)),
                  child: const RowText(first: "Picking order from", second: "The Kings"),
            ),
          )
        ],
      ),
    );
  }
}
