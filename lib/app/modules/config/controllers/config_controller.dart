import 'package:elnozom/app/data/models/config_model.dart';
import 'package:elnozom/app/modules/config/providers/account_provider.dart';
import 'package:elnozom/app/modules/edit/views/edit_view.dart';
import 'package:elnozom/app/modules/list/providers/doc_provider.dart';
import 'package:elnozom/app/modules/settings/providers/store_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:elnozom/app/modules/settings/store_model.dart';
import 'package:get_storage/get_storage.dart';

class ConfigController extends GetxController with StateMixin<List<dynamic>> {
  final localeStorage = GetStorage();
  //TODO: Implement ConfigController
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final invoiceNoController = TextEditingController();
  final invCodeController = TextEditingController();
  final FocusNode codeNode = FocusNode();
  final FocusNode nameNode = FocusNode();
  final FocusNode invoiceNoNode = FocusNode();
  final FocusNode invCodeNode = FocusNode();
  bool notFound = false;
  var invoice = null;
  bool serialErr = false;

  // Config conf = args;
  var args = Get.arguments;
  bool isTransaction = Get.arguments.trSerial == 27;
  bool invErr = false;
  String lastChar = "";
  bool showAutoComplete = Get.arguments.trSerial != 100;
  bool showInvCode = Get.arguments.trSerial == 100;
  String emp = "";
  var suggestions = [''];
  var selectedOption;
  int? serial = null;
  List<Store> stores = [];
  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    super.onInit();
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
  }

  @override
  void onClose() {
    codeController.text = "";
    nameController.text = "";

    codeController.dispose();
    nameController.dispose();
    invoiceNoController.dispose();
    invCodeController.dispose();
    super.onClose();
  }

  // TODO : watch code controller change
  // get the account from api
  // fill name controller with account
  void codeSubmitted(context, data) {
    if (args.trSerial == 100) {
      var req = {
        "EmpCode": int.parse(data),
      };
      AccountProvider().getEmp(req).then((resp) {
        if (resp != null && resp.isNotEmpty) {
          notFound = false;
          emp = resp[0]['EmpName'];
        } else {
          emp = "";
          notFound = true;
        }
        change(resp, status: RxStatus.success());
        _fieldFocusChange(context, codeNode, invCodeNode);
      }, onError: (err) {
        notFound = true;
        emp = "";
        change(null, status: RxStatus.error(err.toString()));
      });
    }
    var req = {"Code": int.parse(data), "Name": "", "Type": args.accType};
    AccountProvider().getAccount(req).then((resp) {
      if (resp != null && resp.isNotEmpty) {
        notFound = false;
        nameController.text = resp[0]['AccountName'];
        serial = resp[0]['Serial'];
      } else {
        nameController.text = '';
        notFound = true;
        _fieldFocusChange(context, invCodeNode, invCodeNode);
      }
      change(resp, status: RxStatus.success());
    }, onError: (err) {
      notFound = true;
      nameController.text = '';
      change(null, status: RxStatus.error(err));
    });
  }

  void getInv(req) {
    DocProvider().getInv(req).then((resp) {
      if (resp != null) {
        invErr = false;
        invoice = resp;
        create();
      } else {
        invErr = true;
        invCodeController.text = '';

        change(null, status: RxStatus.success());
      }
    }, onError: (err) {
      invErr = true;
      invCodeController.text = '';
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void invCodeSubmitted(context, data) {
    var req = {
      "BCode": data,
    };
    getInv(req);
  }

  void nameSubmitted(context, data) {
    serial = int.parse(data.split("....")[1]);
    codeController.text = serial.toString();
    // create();
  }

  void create() async {
    if (args.trSerial == 100) {
      if (invoice != null) {
        var arguments = {
          'empCode': int.parse(codeController.text),
          'hSerial': invoice[0]['BonSer'],
          'invoice': invoice
        };
        Get.toNamed('/prepare', arguments: arguments);
      } else {
        var req = {
          "BCode": invCodeController.text,
        };
      }
    } else if (args.trSerial == 102) {
      if (serial == null) {
        serialErr = true;
      } else {
        args.accSerial = serial;
        // print(args);
        Get.toNamed('/order', arguments: args);
      }
    } else {
      //check if its not a transaction and serial not passed to pass an error
      if (args.trSerial != 27 && serial == null) {
        serialErr = true;
      } else {
        args.accSerial = serial;
        args.toStore = selectedOption != null ? int.parse(selectedOption) : 0;
        serialErr = false;
        Get.toNamed('/edit', arguments: args);
      }
      change(null, status: RxStatus.success());
    }
  }

  void nameChanged(context, data) {
    if (data.length == 1 && data != lastChar) {
      lastChar = data;
      var req = {"Code": 0, "Name": data, "Type": args.accType};
      AccountProvider().getAccount(req).then((resp) {
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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
