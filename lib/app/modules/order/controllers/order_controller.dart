import 'package:elnozom/app/modules/edit/providers/doc_item_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OrderController extends GetxController with StateMixin<List<dynamic>> {
  //TODO: Implement OrderController
  var suggestions = [''];

  final nameController = TextEditingController();
  final FocusNode nameNode = FocusNode();
  final FocusNode wholeQntNode = FocusNode();
  final FocusNode qntNode = FocusNode();
  String? lastChar = null;
  bool notFound = false;
  bool expExisted = false;
  bool qntHidden = false;
  bool withExp = false;
  bool qntErr = false;
  List<dynamic>? item = [];
  int? serial = null;
  DateTime? expDate = null;
var args = Get.arguments;
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  final qntController = TextEditingController();
  final wholeQntController = TextEditingController();
  final FocusNode monthNode = FocusNode();
  int? docNo = null;
  final FocusNode yearNode = FocusNode();
  void nameSubmitted(context, data) {
    serial = int.parse(data.split("....")[1]);
    nameController.text = data;
    // _fieldFocusChange(context, nameNode, wholeQntNode);
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
void wholeQntChanged(context, data) {
  print('asd');
  _fieldFocusChange(context, wholeQntNode, qntNode);
    if (!qntHidden) {
      _fieldFocusChange(context, wholeQntNode, qntNode);
    }
    if (withExp && qntHidden) {
      _fieldFocusChange(context, wholeQntNode, monthNode);
    }

    if (!withExp && qntHidden) {
      submit(context);
    }
  }
   void qntChanged(context, data) async {
    if (withExp) {
      _fieldFocusChange(context, qntNode, monthNode);
      if (expDate != null) {
        submit(context);
      }
    } else {
      submit(context);
    }
  }

  void submit(context) async {
    //validate the date is bigger than now

    // return error message if date is in the past

    // create date variable
    
    int qnt;
    qntController.text == null ? 0 : qntController.text;
    if (item![0]['ByWeight']) {
      qnt = int.parse(wholeQntController.text);
    } else {
      int minor = item![0]['MinorPerMajor'];
      qnt = int.parse(wholeQntController.text) * minor +
          int.parse(qntController.text);
    }

    if (qnt == 0) {
      qntErr = true;
    } else {
      qntErr = false;
      if(docNo != null){
        insertItem(context , docNo , qnt);
      } else {
final Map req = {
          "HeadSerial": 112,
          "ItemSerial": args.accSerial,
          "Qnt": qnt,
          "Price": 100,
        };

        var resp = await DocItemProvider().insertOrder(req).then((resp) {
          docNo = resp;
          insertItem(context , docNo , qnt);
        });
      }
    }
  }
  void insertItem(context,doc , qnt) async
  {
    final Map req = {
          "HeadSerial": doc,
          "ItemSerial": serial,
          "Qnt": qnt,
          "Price": 100,
        };

        var resp = await DocItemProvider().insertOrderItem(req);
        item = [];
        qntController.clear();
        wholeQntController.clear();
        nameController.clear();
        monthController.clear();
        yearController.clear();
        expDate = null;
        withExp = false;
        _fieldFocusChange(context, qntNode, nameNode);
  }

  void nameChanged(context, data) {
    if (data.length == 1 && data != lastChar) {
      lastChar = data;
      final Map req = {"Name": data.toString(), "StoreCode": 1};
      DocItemProvider().getItem(req).then((resp) {
        if (resp != null && resp.isNotEmpty) {
          notFound = false;
        } else {
          notFound = true;
        }
        if (resp != null) {
          for (var pr in resp) {
            if (!suggestions.contains(pr['ItemName'])) {
              suggestions
                  .add(pr['ItemName'] + "...." + pr['Serial'].toString());
            }
          }
        }
        change(resp, status: RxStatus.success());
      });
      // DocItemProvider().getItem(req).then((resp) {
      //   if (resp == null) {
      //     _fieldFocusChange(context, nameNode, nameNode);
      //     noItems = true;

      //   } else {
      //     noItems = false;
      //     _fieldFocusChange(context, nameNode, wholeQntNode);
      //     item = resp;

      //   }
      //   change(null, status: RxStatus.success());
      // }, onError: (err) {
      //   item = [];
      //   change(null, status: RxStatus.error(err));
      // });
    }
  }

  final count = 0.obs;
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
  void increment() => count.value++;
}
