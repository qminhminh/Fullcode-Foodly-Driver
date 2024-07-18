import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_driver/common/app_style.dart';
import 'package:foodly_driver/common/custom_container.dart';
import 'package:foodly_driver/common/reusable_text.dart';
import 'package:foodly_driver/constants/constants.dart';

class NoSelection extends StatelessWidget {
  const NoSelection({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        backgroundColor: kPrimary,
        appBar: AppBar(
          backgroundColor: kOffWhite,
          elevation: 0,
          
        ),
        body: SafeArea(
          child: CustomContainer(
            containerContent: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/delivery.png',
                  height: hieght / 3,
                  width: width,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                  child: ReusableText(
                      text: "No selected orders",
                      style: appStyle(20, kDark, FontWeight.bold)),
                ),
                
              ],
            ),
          ),
        ));
  }
}
