import 'package:get/get.dart';

import 'package:elnozom/app/modules/config/bindings/config_binding.dart';
import 'package:elnozom/app/modules/config/views/config_view.dart';
import 'package:elnozom/app/modules/edit/bindings/edit_binding.dart';
import 'package:elnozom/app/modules/edit/views/edit_view.dart';
import 'package:elnozom/app/modules/home/bindings/home_binding.dart';
import 'package:elnozom/app/modules/home/views/home_view.dart';
import 'package:elnozom/app/modules/list/bindings/list_binding.dart';
import 'package:elnozom/app/modules/list/views/list_view.dart';
import 'package:elnozom/app/modules/order/bindings/order_binding.dart';
import 'package:elnozom/app/modules/order/views/order_view.dart';
import 'package:elnozom/app/modules/prepare/bindings/prepare_binding.dart';
import 'package:elnozom/app/modules/prepare/views/prepare_view.dart';
import 'package:elnozom/app/modules/settings/bindings/settings_binding.dart';
import 'package:elnozom/app/modules/settings/views/settings_view.dart';
import 'package:elnozom/app/modules/trolley/bindings/trolley_binding.dart';
import 'package:elnozom/app/modules/trolley/views/trolley_view.dart';
import 'package:elnozom/app/modules/unprepared/bindings/unprepared_binding.dart';
import 'package:elnozom/app/modules/unprepared/views/unprepared_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CONFIG,
      page: () => ConfigView(),
      binding: ConfigBinding(),
    ),
    GetPage(
      name: _Paths.EDIT,
      page: () => EditView(),
      binding: EditBinding(),
    ),
    GetPage(
      name: _Paths.LIST,
      page: () => ListView(),
      binding: ListBinding(),
    ),
    GetPage(
      name: _Paths.TROLLEY,
      page: () => TrolleyView(),
      binding: TrolleyBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.PREPARE,
      page: () => PrepareView(),
      binding: PrepareBinding(),
    ),
    GetPage(
      name: _Paths.UNPREPARED,
      page: () => UnpreparedView(),
      binding: UnpreparedBinding(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => OrderView(),
      binding: OrderBinding(),
    ),
  ];
}
