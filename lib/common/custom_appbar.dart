import 'package:flutter/material.dart';
import 'package:foodly_driver/common/app_style.dart';
import 'package:foodly_driver/common/reusable_text.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodly_driver/controllers/driver_controller.dart';
import 'package:foodly_driver/controllers/location_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    _determinePosition();

    super.initState();
  }

  Stream<Map<String, dynamic>> newOrders() {
    DatabaseReference ordersRef = FirebaseDatabase.instance.ref('drivers');

    return ordersRef.onValue.map((event) {
      final orderData = event.snapshot.value as Map<dynamic, dynamic>;

      return Map<String, dynamic>.from(orderData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final driverController = Get.put(DriverController());
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      height: 100,
      color: kLightWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: kTertiary,
                backgroundImage: NetworkImage(profile),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                        text: "Current Location",
                        style: appStyle(13, kSecondary, FontWeight.w600)),
                    ReusableText(
                        text: currentLocation != null
                            ? '${currentLocation!.street}, ${currentLocation!.subLocality}, ${currentLocation!.locality}'
                            : "San Francisco 1 Stockton Street",
                        style: appStyle(11, kGray, FontWeight.normal))
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Text(
                getTimeOfDay(),
                style: const TextStyle(fontSize: 35),
              ),
              Positioned(
                  child: StreamBuilder<Map<String, dynamic>>(
                stream: newOrders(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox
                        .shrink(); // Show loading indicator while waiting for data
                  }
                  if (snapshot.hasError) {
                    return const SizedBox
                        .shrink(); // Handle errors from the stream
                  }

                  // The stream has data, so display the appropriate UI
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  String lastOrder = "updated";

                  Map<String, dynamic> orderData = snapshot.data!;
                  if (lastOrder != orderData['order_id']) {
                    driverController.refetch.value = true;
                    lastOrder = orderData['order_id'];

                    Future.delayed(
                      const Duration(seconds: 2),
                      () {
                        driverController.refetch.value = false;
                      },
                    );
                  } else {}
                  return const SizedBox.shrink();
                },
              ))
            ],
          ),
        ],
      ),
    );
  }

  String getTimeOfDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return "☀️";
    } else if (hour >= 12 && hour < 17) {
      return "🌤️";
    } else {
      return "🌙";
    }
  }

  String profile =
      'https://res.cloudinary.com/dp2bicmif/image/upload/v1721315877/logo_hrsyqx.png';
  LatLng _center = const LatLng(37.78792117665919, -122.41325651079953);
  Placemark? currentLocation;

  Future<void> _getCurrentLocation() async {
    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      _getAddressFromLatLng(_center);
    });
    // ignore: use_build_context_synchronously
    final location = Get.put(UserLocationController());

    location.setUserLocation(_center);
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (placemarks.isNotEmpty) {
      setState(() {
        currentLocation = placemarks[0];
        // ignore: use_build_context_synchronously
        final location = Get.put(UserLocationController());

        location.setUserAddress(currentLocation!);
      });
    }
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
}
