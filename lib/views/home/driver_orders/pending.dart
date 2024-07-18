import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_driver/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:foodly_driver/controllers/driver_controller.dart';
import 'package:foodly_driver/hooks/fetchOrders.dart';
import 'package:foodly_driver/models/ready_orders.dart';
import 'package:foodly_driver/views/home/widgets/order_tile.dart';
import 'package:get/get.dart';

class PendingOrders extends HookWidget {
  const PendingOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverController());
    final hookResult = useFetchClientOrders();
    List<ReadyOrders>? orders = hookResult.data;
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    controller.setOnStatusChangeCallback(refetch);

    return Container(
      height: hieght / 1.3,
      width: width,
      color: kLightWhite,
      child: isLoading
          ? const FoodsListShimmer()
          : ListView.builder(
              padding: EdgeInsets.only(top: 10.h, left: 12.w, right: 12.w),
              itemCount: orders!.length,
              itemBuilder: (context, i) {
                ReadyOrders order = orders[i];
                return OrderTile(
                  order: order,
                  active: 'ready',
                );
              }),
    );
  }
}
