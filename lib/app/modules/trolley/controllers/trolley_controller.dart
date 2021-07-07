import 'package:elnozom/app/modules/edit/providers/doc_item_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TrolleyController extends GetxController with StateMixin<List<dynamic>> {
  //TODO: Implement TrolleyController
  bool itemNotFound = false;
  final FocusNode itemFocus = FocusNode();
  List<dynamic>? item = [];
  final codeController = TextEditingController();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    change(null, status: RxStatus.success());
  }

  void itemChanged(context, data) {
    final Map req = {"BCode": data.toString(), "StoreCode": 1};
    DocItemProvider().getItem(req).then((resp) {
      if (resp == null) {
        itemNotFound = true;
        change(null, status: RxStatus.success());
      } else {
        itemNotFound = false;
        codeController.text = '';
        change(resp, status: RxStatus.success());
      }
    }, onError: (err) {
      change(null, status: RxStatus.error(err));
    });
    _fieldFocusChange(context , itemFocus , itemFocus);
    // FocusScope.of(context).requestFocus(itemFocus);
  }

  @override
  void onClose() {}
  void increment() => count.value++;
  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
