import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_driver/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:foodly_driver/hooks/fetchAllNearbyRestaurants.dart';
import 'package:foodly_driver/models/restaurants.dart';
import 'package:foodly_driver/views/home/widgets/chat_title_restaurant.dart';

class ChatWithRetaurant extends HookWidget {
  const ChatWithRetaurant({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllRestaurants("41007428");
    final restaurants = hookResult.data;
    final isLoading = hookResult.isLoading;

    return Scaffold(
      body: isLoading
          ? const FoodsListShimmer()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              height: hieght,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: restaurants.length,
                  itemBuilder: (context, i) {
                    Restaurants restaurant = restaurants[i];
                    return ChatTileRestaurants(restaurant: restaurant);
                  }),
            ),
    );
  }
}
