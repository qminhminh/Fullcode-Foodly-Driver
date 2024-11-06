// ignore_for_file: sort_child_properties_last, unnecessary_null_comparison, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_driver/common/app_style.dart';
import 'package:foodly_driver/common/custom_appbar.dart';
import 'package:foodly_driver/common/custom_container.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:foodly_driver/views/home/chat_tab.dart';
import 'package:foodly_driver/views/home/driver_orders/active.dart';
import 'package:foodly_driver/views/home/driver_orders/delivered.dart';
import 'package:foodly_driver/views/home/driver_orders/pending.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

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

  final box = GetStorage();
  late final String uid = box.read("userId").replaceAll('"', '');

  List<dynamic> messages = [];
  bool isLoading = false;
  String? error;

  Future<void> requestPermissionsWithPrompt() async {
    PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus.isDenied) {
      print("Người dùng đã từ chối quyền vị trí.");
    } else if (locationStatus.isPermanentlyDenied) {
      openAppSettings(); // Mở cài đặt ứng dụng nếu bị từ chối vĩnh viễn
    }

    PermissionStatus notificationStatus =
        await Permission.notification.request();
    if (notificationStatus.isDenied) {
      print("Người dùng đã từ chối quyền thông báo.");
    } else if (notificationStatus.isPermanentlyDenied) {
      openAppSettings(); // Mở cài đặt ứng dụng nếu bị từ chối vĩnh viễn
    }
  }

  // Hàm fetch dữ liệu
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final url = Uri.parse('$appBaseUrl/api/chats/messages-dri/$uid');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          messages = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissionsWithPrompt();
    fetchData();
  }

  Future<void> navigateToChatTab() async {
    final result = await Get.to(() => const ChatTab(),
        duration: const Duration(milliseconds: 400));

    // Kiểm tra giá trị trả về
    if (result == true) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final countUnreadMessage = messages.isNotEmpty
        ? messages
            .where((msg) => msg['isRead'] == 'unread' && msg['sender'] != uid)
            .toList()
        : [];
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
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 60.0),
          child: Stack(
            clipBehavior: Clip.none, // Để phần badge hiển thị bên ngoài
            children: [
              FloatingActionButton(
                focusColor: kPrimary,
                hoverColor: kPrimary,
                onPressed: navigateToChatTab,
                child: const Icon(Icons.chat_bubble),
                backgroundColor: kPrimary,
              ),
              Positioned(
                top: 4, // Đặt vị trí của badge
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red, // Màu nền cho badge
                    shape: BoxShape.circle, // Đặt hình dạng là hình tròn
                  ),
                  child: Text(
                    '${countUnreadMessage != null ? countUnreadMessage.length : 0}', // Số đếm
                    style: const TextStyle(
                      color: Colors.white, // Màu chữ của số đếm
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
