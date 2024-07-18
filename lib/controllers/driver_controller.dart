// ignore_for_file: unused_import, prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:foodly_driver/models/api_error.dart';
import 'package:foodly_driver/models/driver_response.dart';
import 'package:foodly_driver/models/sucess_model.dart';
import 'package:foodly_driver/views/auth/login_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DriverController extends GetxController {
  final box = GetStorage();
  Driver? driver;

  var refetch = false.obs;

  // Function to be called when status changes
  Function? onStatusChange;

  @override
  void onInit() {
    super.onInit();
    // Set up the listener
    ever(refetch, (_) async {
      if (refetch.isTrue && onStatusChange != null) {
        await Future.delayed(const Duration(seconds: 5));
        onStatusChange!();
      }
    });
  }

  void setOnStatusChangeCallback(Function callback) {
    onStatusChange = callback;
  }

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  RxString _vehicleType = ''.obs;

  String get vehicleType => _vehicleType.value;

  set setVehicleType(String newValue) {
    _vehicleType.value = newValue;
  }

  void driverRegistration(String model) async {
    String accessToken = box.read('token');
    setLoading = true;
    var url = Uri.parse('$appBaseUrl/api/driver');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: model,
      );

      if (response.statusCode == 201) {
        var data = successResponseFromJson(response.body);
        setLoading = false;

        Get.snackbar(data.message,
            "Thank you for registering, wait for the approval. We will notify you soon via email",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.add_alert));

        Get.off(() => const Login(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to login, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to login, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }
}
