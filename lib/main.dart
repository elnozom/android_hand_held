import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
void main() async {
   await GetStorage.init();
  runApp(
    GetMaterialApp(
      title: "elnozom",
      locale: Locale('ar', 'AE'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Frutiger'),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
