import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_driver/common/app_style.dart';
import 'package:foodly_driver/common/custom_btn.dart';
import 'package:foodly_driver/common/custom_container.dart';
import 'package:foodly_driver/common/reusable_text.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:foodly_driver/controllers/driver_controller.dart';
import 'package:foodly_driver/controllers/location_controller.dart';
import 'package:foodly_driver/models/driver_reg_request.dart';
import 'package:foodly_driver/views/auth/widgets/email_textfield.dart';
import 'package:get/get.dart';

class DriverRegistration extends StatefulWidget {
  const DriverRegistration({super.key});

  @override
  State<DriverRegistration> createState() => _DriverRegistrationState();
}

class _DriverRegistrationState extends State<DriverRegistration> {
  final TextEditingController _vehicle = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  final List<String> items = ['Bike', 'Car', 'Scooter', 'Drone'];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserLocationController());
    final driverController = Get.put(DriverController());
    return Scaffold(
        backgroundColor: kPrimary,
        appBar: AppBar(
          title: ReusableText(
              text: "Driver Registration",
              style: appStyle(16, kDark, FontWeight.w600)),
          backgroundColor: Colors.white,
          elevation: 0.4,
        ),
        body: CustomContainer(
          containerContent: SizedBox(
            width: width,
            height: hieght,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                Image.asset(
                  'assets/images/delivery.png',
                  height: hieght / 3,
                  width: width,
                ),
                SizedBox(
                  height: 20.h,
                ),
                ReusableText(
                    text: "Pick Vehicle Type",
                    style: appStyle(16, kDark, FontWeight.bold)),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: List.generate(items.length, (i) {
                    return Obx(() => GestureDetector(
                          onTap: () {
                            driverController.setVehicleType = items[i];
                          },
                          child: SizedBox(
                            width: 80.h,
                            height: 30.h,
                            child: Card(
                              elevation: 0.3,
                              color: driverController.vehicleType == items[i]
                                  ? kSecondary
                                  : kLightWhite,
                              child: Center(
                                child: Text(items[i]),
                              ),
                            ),
                          ),
                        ));
                  }),
                ),
                SizedBox(
                  height: 20.h,
                ),
                EmailTextField(
                    hintText: "Vehicle Number",
                    controller: _vehicle,
                    prefixIcon: Icon(
                      CupertinoIcons.car_detailed,
                      color: Theme.of(context).dividerColor,
                      size: 20.h,
                    ),
                    keyboardType: TextInputType.text,
                    onEditingComplete: () {}),
                SizedBox(
                  height: 10.h,
                ),
                EmailTextField(
                    hintText: "Phone Number",
                    controller: _phone,
                    prefixIcon: Icon(
                      CupertinoIcons.phone,
                      color: Theme.of(context).dividerColor,
                      size: 20.h,
                    ),
                    keyboardType: TextInputType.text,
                    onEditingComplete: () {}),
                SizedBox(
                  height: 20.h,
                ),
                CustomButton(
                  btnHieght: 45,
                  onTap: () {
                    if (_phone.text.isEmpty ||
                        _vehicle.text.isEmpty ||
                        driverController.vehicleType.isEmpty) {
                      Get.snackbar("Error", "Please fill all fields");
                      return;
                    } else {
                      DriverRegistrationRequest data =
                          DriverRegistrationRequest(
                              vehicleType: driverController.vehicleType,
                              phone: _phone.text,
                              vehicleNumber: _vehicle.text,
                              latitude: controller.currentLocation.latitude,
                              longitude: controller.currentLocation.longitude);

                      String driver = driverRegistrationRequestToJson(data);

                      driverController.driverRegistration(driver);
                    }
                  },
                  text: "S U B M I T",
                )
              ],
            ),
          ),
        ));
  }
}
