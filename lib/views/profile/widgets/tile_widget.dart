import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_driver/common/app_style.dart';
import 'package:foodly_driver/constants/constants.dart';


class TilesWidget extends StatelessWidget {
  final String title;
  final IconData leading;
  final Function()? onTap;

  const TilesWidget({
    Key? key,
    required this.title,
    required this.leading,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        visualDensity: VisualDensity.compact,
        onTap: onTap,
        leading: Icon(leading, size: 20,),
        title: Text(
          title,
          style: appStyle(11, kGray, FontWeight.normal),
        ),
        trailing: title != "Settings"
            ? const Icon(
                AntDesign.right,
                size: 16,
              )
            : SvgPicture.asset(
                "assets/icons/usa.svg",
                width: 15,
                height: 20,
              ));
  }
}
