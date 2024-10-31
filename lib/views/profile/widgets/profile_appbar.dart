import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_driver/controllers/login_controller.dart';
import 'package:get/get.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return AppBar(
      backgroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
      leading: GestureDetector(
        onTap: () {},
        child: GestureDetector(
          onTap: () {
            controller.logout();
          },
          child: const Icon(
            AntDesign.logout,
            size: 18,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 15,
                  height: 25,
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 15,
                  width: 1,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 5,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(
                    SimpleLineIcons.settings,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
