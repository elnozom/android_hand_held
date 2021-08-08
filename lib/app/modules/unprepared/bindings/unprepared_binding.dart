import 'package:get/get.dart';

import '../controllers/unprepared_controller.dart';

class UnpreparedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnpreparedController>(
      () => UnpreparedController(),
    );
  }
}
