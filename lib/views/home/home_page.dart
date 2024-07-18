import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_driver/common/app_style.dart';
import 'package:foodly_driver/common/custom_appbar.dart';
import 'package:foodly_driver/common/custom_container.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:foodly_driver/views/home/driver_orders/active.dart';
import 'package:foodly_driver/views/home/driver_orders/delivered.dart';
import 'package:foodly_driver/views/home/driver_orders/pending.dart';

class HomePage extends StatefulHookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: kPrimary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: const CustomAppBar(),
          elevation: 0,
          backgroundColor: kLightWhite,
        ),
        body: SafeArea(
          child: CustomContainer(
            containerContent: SizedBox(
              height: hieght,
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Container(
                      height: 25.h,
                      width: width,
                      decoration: BoxDecoration(
                        color: kOffWhite,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        labelColor: Colors.white,
                        labelStyle:
                            appStyle(12, kLightWhite, FontWeight.normal),
                        unselectedLabelColor: Colors.grey.withOpacity(0.7),
                        tabs: const <Widget>[
                          Tab(
                            text: "Ready",
                          ),
                          Tab(
                            text: "Active",
                          ),
                          Tab(
                            text: "Delivered",
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: hieght,
                    child: TabBarView(
                        controller: _tabController,
                        children: const [
                          PendingOrders(),
                          ActiveOrders(),
                          DeliveredOrders()
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
