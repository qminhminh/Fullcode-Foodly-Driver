// ignore_for_file: unnecessary_null_comparison, unnecessary_string_interpolations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_driver/common/app_style.dart';
import 'package:foodly_driver/common/reusable_text.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:foodly_driver/models/user.dart';
import 'package:foodly_driver/views/home/widgets/chat_customer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ChatTileCustomer extends HookWidget {
  const ChatTileCustomer({
    super.key,
    required this.customer,
  });

  final User customer;

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    late final String uid = box.read("userId").replaceAll('"', '');
    final messages = useState<List<dynamic>>([]);
    final isLoading = useState(false);
    final error = useState<Exception?>(null);

    Future<void> fetchData() async {
      isLoading.value = true;
      try {
        final url = Uri.parse(
            '$appBaseUrl/api/chats/messages-driver/$uid/${customer.id}');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          messages.value = json.decode(response.body);
        } else {
          throw Exception('Failed to load messages');
        }
      } catch (e) {
        error.value = e as Exception?;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchData();
      return null;
    }, const []);

    final lastUnreadMessage = messages.value.isNotEmpty
        ? messages.value.lastWhere(
            (msg) => msg['isRead'] == 'unread',
            orElse: () => null,
          )
        : null;
    return GestureDetector(
      onTap: () async {
        final result = await Get.to(
          () => ChatCustomer(customer: customer),
          duration: const Duration(milliseconds: 300),
          transition: Transition.fadeIn,
        );

        if (result == true) {
          fetchData();
        }
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 70,
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
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 70.h,
                          width: 70.w,
                          child: Image.network(
                            customer.profile,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(
                                Icons.error,
                                color: kPrimary,
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                          text: customer.username,
                          style: appStyle(15, kDark, FontWeight.w400)),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          if (lastUnreadMessage !=
                              null) // Chỉ hiển thị khi có tin chưa đọc
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 8), // Khoảng cách giữa tin nhắn và nhãn
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape
                                    .circle, // Đặt hình dạng bo tròn hoàn toàn
                              ),
                            ),
                          const SizedBox(
                            width: 1,
                          ),
                          Text(
                              lastUnreadMessage != null
                                  ? "${lastUnreadMessage!['message']}"
                                  : "No new messages",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: appStyle(
                                  15,
                                  lastUnreadMessage != null
                                      ? kGray
                                      : Colors.black,
                                  FontWeight.w400)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 70.h,
            top: 6.h,
            child: Container(
              width: 19.h,
              height: 19.h,
              decoration: const BoxDecoration(
                color: kSecondary,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: GestureDetector(
                onTap: () {},
                child: const Center(
                  child: Icon(
                    MaterialCommunityIcons.shopping_outline,
                    size: 15,
                    color: kLightWhite,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
