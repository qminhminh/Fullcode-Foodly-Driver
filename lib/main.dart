import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_driver/constants/constants.dart';
import 'package:foodly_driver/firebase_options.dart';
import 'package:foodly_driver/views/auth/login_page.dart';
import 'package:foodly_driver/views/auth/waiting_page.dart';
import 'package:foodly_driver/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Widget defaultHome = MainScreen();

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');
    String? driver = box.read('driverId');
    String? verification = box.read("verification");

    if (token == null) {
      defaultHome = const Login();
      // ignore: unnecessary_null_comparison
    } else if (token != null && driver == null) {
      defaultHome = const Login();
    } else if (driver != null && verification == "Verified") {
      defaultHome = MainScreen();
    } else if (driver != null && verification != "Verified") {
      defaultHome = const WaitingPage();
    }

    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Foodly Delivery App',
            theme: ThemeData(
              scaffoldBackgroundColor: kOffWhite,
              iconTheme: const IconThemeData(color: kDark),
              primarySwatch: Colors.grey,
            ),
            home: defaultHome,
          );
        });
  }
}
