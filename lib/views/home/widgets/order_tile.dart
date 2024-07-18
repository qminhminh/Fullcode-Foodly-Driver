// ignore_for_file: unrelated_type_equality_checks, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_driver/common/app_style.dart';
import 'package:foodly_driver/common/reusable_text.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:foodly_driver/controllers/location_controller.dart';
import 'package:foodly_driver/controllers/order_controller.dart';
import 'package:foodly_driver/models/distance_time.dart';
import 'package:foodly_driver/models/ready_orders.dart';
import 'package:foodly_driver/services/distance.dart';
import 'package:foodly_driver/views/entrypoint.dart';
import 'package:foodly_driver/views/order/active_page.dart';
import 'package:foodly_driver/views/order/delivered.dart';
import 'package:foodly_driver/views/order/ready_page.dart';
import 'package:get/get.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
    required this.active,
  });

  final ReadyOrders order;
  final String? active;

  @override
  Widget build(BuildContext context) {
    final location = Get.put(UserLocationController());
    final controller = Get.put(OrdersController());
    DistanceTime distance = Distance().calculateDistanceTimePrice(
        location.currentLocation.latitude,
        location.currentLocation.longitude,
        order.restaurantCoords[0],
        order.restaurantCoords[1],
        5,
        5);

    DistanceTime distance2 = Distance().calculateDistanceTimePrice(
        order.restaurantCoords[0],
        order.restaurantCoords[1],
        order.recipientCoords[0],
        order.recipientCoords[1],
        15,
        5);

    double distanceToRestaurant = distance.distance + 1;
    double distanceFromRestaurantToClient = distance2.distance + 1;

    return GestureDetector(
      onTap: () {
        controller.order = order;
        controller.setDistance = distanceToRestaurant + distanceFromRestaurantToClient;
       
       if(order.orderStatus == "Delivered"){
        Get.to(() => const DeliveredPage(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 2));
             activeOrder = const DeliveredPage();
       }else{
         Get.to(() => const ReadyPage(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 2));
              activeOrder = const ActivePage();
       }

      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 84,
            width: width,
            decoration: const BoxDecoration(
                color: kOffWhite,
                borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: SizedBox(
                        height: 75.h,
                        width: 70.h,
                        child: Image.network(
                          order.orderItems[0].foodId.imageUrl[0],
                          fit: BoxFit.cover,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6.h,
                      ),
                      ReusableText(
                          text: order.orderItems[0].foodId.title,
                          style: appStyle(10, kGray, FontWeight.w500)),
                      OrderRowText(
                          text: "📌 ${order.restaurantId.coords.address}"),
                      OrderRowText(
                          text:
                              "🏠 ${order.deliveryAddress.addressLine1}"),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            decoration: BoxDecoration(
                                color: active == 'ready'
                                    ? kSecondary
                                    : const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(10)),
                            child: ReusableText(
                                text:
                                    "To 📌 ${distanceToRestaurant.toStringAsFixed(2)} km",
                                style: appStyle(
                                    9,
                                    active == 'ready'
                                        ? const Color(0xFFFFFFFF)
                                        : kGray,
                                    FontWeight.w400)),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            decoration: BoxDecoration(
                                color: active == 'active'
                                    ? kSecondary
                                    : const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(10)),
                            child: ReusableText(
                                text:
                                    "From 📌 To 🏠 ${distanceFromRestaurantToClient.toStringAsFixed(2)} km",
                                style: appStyle(
                                    9,
                                    active == 'active'
                                        ? const Color(0xFFFFFFFF)
                                        : kGray,
                                    FontWeight.w400)),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(10)),
                            child: ReusableText(
                                text: "\$ ${order.deliveryFee}",
                                style: appStyle(9, kGray, FontWeight.w400)),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: ReusableText(
                                text: "⏰ 25 min",
                                style: appStyle(9, kGray, FontWeight.w400)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 6.h,
            child: Container(
              width: 60.h,
              height: 19.h,
              decoration: BoxDecoration(
                  color: order.orderStatus == "Out_for_Delivery"
                      ? order.orderStatus == "Delivered"
                          ? kGray
                          : kPrimary
                      : kGray.withOpacity(0.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  )),
              child: Center(
                child: ReusableText(
                  text: order.orderStatus == "Out_for_Delivery"
                      ? "Active"
                      : order.orderStatus == "Delivered" ? "Delivered" : "Pick Up",
                  style: appStyle(11, kLightWhite, FontWeight.w500),
                ),
              ),
            ),
          ),
           Positioned(
              right: 70.h,
              top: 6.h,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                child: SizedBox(
                  width: 19.h,
                  height: 19.h,
                  child: Image.network(order.restaurantId.logoUrl,
                      fit: BoxFit.cover),
                ),
              ))
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class OrderRowText extends StatelessWidget {
  OrderRowText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width / 1.6,
        child: ReusableText(
            text: text, style: appStyle(9, kGray, FontWeight.w400)));
  }
}
