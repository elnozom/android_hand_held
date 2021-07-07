import 'package:elnozom/app/modules/settings/providers/store_provider.dart';
import 'package:elnozom/app/modules/settings/store_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class SettingsController extends GetxController with StateMixin<List<dynamic>> {
  //TODO: Implement SettingsController

  List<Store> stores = [];
  final localeStorage = GetStorage();
  var selectedOption ;
  final deviceController = TextEditingController();
  @override
  void onInit() async {
    super.onInit();
    deviceController.text =  localeStorage.read('device') ?? '1';
    selectedOption = localeStorage.read('store') ?? '1';

    StoreProvider().getStores().then((resp) {
      for (var store in resp) {
        stores.add(new Store(
          storeName: store['store_name'],
          storeCode: store['store_code'],
        ));
      }
      change(resp, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void storeChanged(data) {
    selectedOption = data;
    change(null, status: RxStatus.success());
    print(data);
  }

   void submit() {
     localeStorage.write('store' , selectedOption);
     localeStorage.write('device' , deviceController.text);
     Get.offAllNamed('/home');
    print(localeStorage.read('device'));
  }

  void deviceChanged(data) {
    deviceController.text = data;
    change(null, status: RxStatus.success());
    print(data);
  }
}
