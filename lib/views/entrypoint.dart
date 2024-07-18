import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_driver/common/app_style.dart';
import 'package:foodly_driver/common/reusable_text.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:foodly_driver/controllers/order_controller.dart';
import 'package:foodly_driver/controllers/tab_controller.dart';
import 'package:foodly_driver/views/home/home_page.dart';
import 'package:foodly_driver/views/order/active_page.dart';
import 'package:foodly_driver/views/order/no_selection.dart';
import 'package:foodly_driver/views/profile/profile_page.dart';
import 'package:get/get.dart';

Widget activeOrder = const NoSelection();

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final controller = Get.put(OrdersController());

  List<Widget> pageList = <Widget>[
    const HomePage(),
    const ActivePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final entryController = Get.put(MainScreenController());
    

    return Obx(() => Scaffold(
          body: Stack(
            children: [
              pageList[entryController.tabIndex],
              Align(
                alignment: Alignment.bottomCenter,
                child: Theme(
                  data: Theme.of(context).copyWith(canvasColor: kPrimary),
                  child: BottomNavigationBar(
                      selectedFontSize: 12,
                      backgroundColor: entryController.tabIndex == 1? Colors.transparent: kPrimary,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      unselectedIconTheme:
                          const IconThemeData(color: Colors.black38),
                      items: [
                        BottomNavigationBarItem(
                          icon: entryController.tabIndex == 0
                              ? const Icon(
                                  AntDesign.appstore1,
                                  color: kSecondary,
                                  size: 24,
                                )
                              : const Icon(AntDesign.appstore1),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: entryController.tabIndex == 2
                              ? Badge(
                                  
                                  label: ReusableText(
                                      text: "2",
                                      style: appStyle(
                                          8, kLightWhite, FontWeight.normal)),
                                  child: const Icon(
                                    Ionicons.fast_food,
                                    size: 24,
                                  ))
                              : Badge(
                                  
                                  label: ReusableText(
                                      text: "2",
                                      style: appStyle(
                                          8, kLightWhite, FontWeight.normal)),
                                  child: const Icon(
                                    Ionicons.fast_food_sharp,
                                    size: 24,
                                  )),
                          label: 'Profile',
                        ),
                        BottomNavigationBarItem(
                          icon: entryController.tabIndex == 3
                              ? const Icon(
                                  FontAwesome.user_circle,
                                  size: 24,
                                )
                              : const Icon(
                                  FontAwesome.user_circle_o,
                                ),
                          label: 'Profile',
                        ),
                      ],
                      currentIndex: entryController.tabIndex,
                      unselectedItemColor: kGray,
                      selectedItemColor: kSecondary,
                      onTap: ((value) {
                        entryController.setTabIndex = value;
                      })),
                ),
              ),
            ],
          ),
        ));
  }
}
