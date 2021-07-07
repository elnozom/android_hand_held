import 'package:elnozom/app/modules/config/providers/account_provider.dart';
import 'package:elnozom/app/modules/edit/views/edit_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ConfigController extends GetxController with StateMixin<List<dynamic>> {
  //TODO: Implement ConfigController
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final invoiceNoController = TextEditingController();
  bool notFound = false;
  bool serialErr = false;
  var suggestions = [''];
  int? serial = null;
  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    super.onInit();
    change(null, status: RxStatus.success());
  }

  @override
  void onClose() {
    codeController.dispose();
    nameController.dispose();
    invoiceNoController.dispose();
    super.onClose();
  }

  // TODO : watch code controller change
  // get the account from api
  // fill name controller with account
  void codeSubmitted(context, data) {
    var req = {"Code": int.parse(data), "Name": "", "Type": Get.arguments.accType};
    AccountProvider().getAccount(req).then((resp) {
      if (resp != null && resp.isNotEmpty) {
        notFound = false;
        nameController.text = resp[0]['AccountName'];
        serial = resp[0]['Serial'];
        print(serial);
        print(resp[0]['Serial']);
      } else {
        nameController.text = '';
        notFound = true;
      }
      change(resp, status: RxStatus.success());
    }, onError: (err) {
      notFound = true;
      nameController.text = '';
      change(null, status: RxStatus.error(err));
    });
  }

  void nameSubmitted(context, data) {
    serial = int.parse(data.split("....")[1]);
    create();
  }

  void create(){
    if(serial == null){
      serialErr = true;
    } else {
      Get.arguments.accSerial =  serial;
      serialErr = false;
      Get.toNamed('/edit' , arguments: Get.arguments);
    }
    change(null, status: RxStatus.success());
  }

  void nameChanged(context, data) {
    if (data.length == 0) {
      suggestions = [''];
    } 
    if (data.length == 1) {
      var req = {"Code": 0, "Name": data, "Type": Get.arguments.accType};
      AccountProvider().getAccount(req).then((resp) {
        print(resp);
        if (resp != null && resp.isNotEmpty) {
          notFound = false;
        } else {
          notFound = true;
        }
        if (resp != null) {
          for (var acc in resp) {
            if (!suggestions.contains(acc['AccountName'])) {
              suggestions
                  .add(acc['AccountName'] + "...." + acc['Serial'].toString());
            }
          }
        }
        change(resp, status: RxStatus.success());
      }, onError: (err) {
        notFound = true;
        change(null, status: RxStatus.error(err));
      });
    }
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      // todo : create document
    }
  }
}
