import 'package:elnozom/app/data/models/config_model.dart';
import 'package:elnozom/app/modules/home/tab_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final List<TabModel> tabs = [
    TabModel(
      icon: Icons.add_shopping_cart,
      text: "مشتريات",
      transSerial: 19,
      link: "buy",
      accountType: 2,
      type: 2,
    ),
    TabModel(
      icon: Icons.production_quantity_limits,
      text: 'مرتجع مشتريات',
      transSerial: 26,
      link: 'buy-return',
      accountType: 2,
      type: 2,
    ),
    TabModel(
      icon: Icons.credit_score,
      text: 'مبيعات',
      transSerial: 30,
      link: 'sell',
      accountType: 1,
      type: 1,
    ),
    TabModel(
      icon: Icons.credit_card,
      text: ' مرتجع مبيعات',
      transSerial: 20,
      link: 'sell-return',
      accountType: 1,
      type: 1,
    ),
    TabModel(
      icon: Icons.cloud_upload_outlined,
      text: ' صرف تحويلات ',
      transSerial: 27,
      link: 'transaction',
      accountType: -1,
      type: 3,
    ),
    TabModel(
      icon: Icons.account_balance_wallet_outlined,
      text: ' رصيد اول مدة',
      transSerial: 24,
      link: 'first',
      accountType: -1,
      type: -1,
    ),
    TabModel(
      icon: Icons.check_circle_outline,
      text: 'مراجعة اسعار',
      transSerial: -1,
      link: 'trolley-check',
      accountType: -1,
      type: -1,
    ),
    TabModel(
      icon: Icons.inventory_2_outlined,
      text: 'ادوات الجرد',
      transSerial: 31,
      link: 'inventory',
      accountType: -1,
      type: -1,
    ),
    TabModel(
      icon: Icons.settings_outlined,
      text: "الاعدادات",
      transSerial: 0,
      link: 'settings',
      accountType: -1,
      type: -1,
    )
  ];

  void goTo(index) {
    var tab = tabs[index];
    if (tab.transSerial == -1) {
      Get.toNamed("/trolley");
    } else if(tab.transSerial == 0) {
      Get.toNamed("/settings");
    } else {
      Config arguments = new Config(trSerial :tab.transSerial , type: tab.type , accType:tab.accountType);
      Get.toNamed("/list", arguments: arguments);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
