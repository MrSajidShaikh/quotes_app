import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotes_app/screen/saved_screen.dart';
import 'package:quotes_app/screen/view_fliterQuote_Screen.dart';
import 'package:sizer/sizer.dart';
import 'screen/add/add_Screen.dart';
import 'screen/home_Screen.dart';
import 'screen/splash_Screen.dart';

void main() {
  runApp(
    Sizer(
      builder: (context, orientation, deviceType) =>
          GetMaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              "/": (p0) => const SplashScreen(),
              "/home": (p0) => const HomeScreen(),
              "/add": (p0) => const Add_Screen(),
              "/viewCategory": (p0) => const View_FilteredQuote_Screen(),
              "/savedScreen": (p0) => const SavedQuotesScreen(),
            },
          ),
    ),
  );
}