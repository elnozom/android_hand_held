import 'dart:async';
import 'dart:ffi';

import 'package:elnozom/app/modules/list/providers/doc_provider.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:elnozom/app/modules/edit/providers/doc_item_provider.dart';

class PrepareController extends GetxController with StateMixin<List<dynamic>> {
  //TODO: Implement PrepareController
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final qtyController = TextEditingController();
  final wholeQtyController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  bool showQnt = false;
  bool showWholeQnt = false;
  DateTime? expDate = null;
  bool itemNotFound = false;
  bool expExisted = false;
  bool withExp = false;
  bool yearErr = false;
  bool monthErr = false;
  var minorPerMajor = 1;
  var itemData = null;
  var args = Get.arguments;
  var invoice = Get.arguments['invoice'];
  List<dynamic>? item = [];
  List<String> columns = [
    "المنتج",
    "السعر",
  ];
  final FocusNode itemFocus = FocusNode();
  final FocusNode wholeQtyFocus = FocusNode();
  final FocusNode qtyFocus = FocusNode();
  final FocusNode monthFocus = FocusNode();
  final FocusNode yearFocus = FocusNode();
  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
  }

  @override
  void onReady() {
    super.onReady();
  }

  List<DataColumn> generateColumns() {
    List<DataColumn> wid = [];
    for (var i = 0; i < columns.length; i++) {
      wid.add(DataColumn(
        label: Text(
          columns[i],
        ),
      ));
    }
    return wid;
  }

  void closeDoc() async {
    final Map req = {
      "HSerial": int.parse(args['hSerial']),
      "EmpCode": args['empCode'],
    };
    var resp = await DocItemProvider().closePrepareDoc(req).then((resp) {
      if (resp![0]['Close']) {
        Get.toNamed('/home');
      } else {
        Get.snackbar(
          "تحذير",
          "لا يمكنك غلق هذا المستند تأكد من مراجعة الفاتورة",
        );
      }
    });
  }

  Future<void> showBackAlertDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تحذير'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('هل انت متاكد من انك تريد مغادرة عملية التحضير'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('خروج'),
              onPressed: () {
                Get.offAllNamed('/home', arguments: args);
              },
            ),
          ],
        );
      },
    );
  }

  DataRow generateRows(index) {
    List<DataCell> wid = [];
    var wholQnt;
    var qnt;
    var rec = invoice[index];
    if (rec['ByWeight'] == true) {
      wholQnt = rec['Qnt'].toString();
      qnt = '0';
    } else {
      wholQnt = (rec['Qnt'] / rec['MinorPerMajor']).floor().toString();
      qnt = (rec['Qnt'].remainder(rec['MinorPerMajor'])).toString();
    }
    var color = rec['IsPrepared'] ? Colors.green : Colors.red;
    wid.add(DataCell(Text(
        '${rec["ItemName"]} \n  الكمية الكلية : ${wholQnt} \n الكمية الجزئية : ${qnt} ',
        style: TextStyle(color: color))));
    wid.add(DataCell(Text('${rec["Price"]}', style: TextStyle(color: color))));

    return DataRow(
      cells: wid,
    );
  }

  bool itemInInv(rec) {
    bool found = false;
    int serial = rec![0]['Serial'];
    for (var item in invoice) {
      int itemSerial = int.parse(item['ItemSerial']);
      if (itemSerial == serial) {
        found = true;
        rec[0]['QntPrepare'] = item['QntPrepare'];
        rec[0]['Qnt'] = item['Qnt'];
        rec[0]['Color'] =
            item['Qnt'] == item['QntPrepare'] ? Colors.green : Colors.red;
      }
    }
    itemData = rec;
    return found;
  }

  void itemPrepared(serial, qnt) {
    for (var item in invoice) {
      int itemSerial = int.parse(item['ItemSerial']);
      if (itemSerial == serial) {
        item['IsPrepared'] = true;
        item['QntPrepare'] = qnt;
      }
    }
  }

  void _metaHandler(context) {
    //set the with expiry variable after finishing every thing
    //this variabl we will depend on him on the view to show the inputs
    // but we will check if expExisted is false too
    //we have three options
    // 1- item has only part qnt [qnt < minor]
    // 2- item has  whole qnt [qnt > minor]

    int minor = itemData[0]['MinorPerMajor'];
    int qnt = itemData[0]['Qnt'];
    if (qnt < minor) {
      // only part
      qtyController.text = "1";
      wholeQtyController.text = "0";
    } else {
      // only whole
      qtyController.text = "0";
      wholeQtyController.text = "1";
    }
    bool withExp = itemData[0]['WithExp'];
    var expirey = itemData[0]['Expirey'];
    withExp = withExp;
    if (!withExp) {
      submit(context);
    } else if (expirey != '0') {
      monthController.text = expirey.substring(0, 2);
      yearController.text = expirey.substring(2);
      expExisted = true;
      submit(context);
    }
  }

  void itemChanged(context, data) {
    final Map req = {"BCode": data.toString(), "StoreCode": 1};
    DocItemProvider().getItem(req).then((resp) {
      var item = resp;
      int serial = item![0]['Serial'];
      if (itemInInv(item)) {
        //set the default value of expirey date existed to false
        expExisted = false;
        itemNotFound = false;
        //check if item has partial qty to show the input
        // and hide it if item dosn't has it
        _metaHandler(context);
        //check if the item is with expiry

      } else {
        _fieldFocusChange(context, itemFocus, itemFocus);
        itemNotFound = true;
      }
      change(null, status: RxStatus.success());
    }, onError: (err) {
      item = [];
      change(null, status: RxStatus.error(err));
    });
  }

  String? validator(String? value) {
    if (value == null) {
      return 'هذا الحقل اجباري';
    }
    return null;
  }

  void submit(context) async {
    if (itemData == null && codeController.text != "") {
      itemChanged(context, codeController.text);
    }

    //now we finished every thing
    // now we need to validate that we dont need to show any another inputs if [
    // item foud && even we dont have to show qnt or the qnt input is set
    // && even item dont have expiration or the month and year inputs are filled
    // ]
    // first we will insert the item to db
    // and we will increase the quantity
    if (itemData != null &&
        !itemNotFound &&
        (!withExp ||
            (monthController.text != '' && yearController.text != ''))) {
      int serial = itemData[0]['Serial'];
      int qnt = (itemData[0]['MinorPerMajor'] *
              int.parse(wholeQtyController.text)) +
          int.parse(qtyController.text);
      Map req = {
        "QPrep": qnt,
        "ISerial": serial,
        "HSerial": int.parse(invoice[0]['BonSer'])
      };
      DocProvider().insertPrepareItem(req).then((resp) {
        if (resp != null) {
          codeController.text = "";
          qtyController.text = "";
          wholeQtyController.text = "";
          monthController.text = "";
          yearController.text = "";
          showQnt = false;
          withExp = false;

          if (resp[0]["Prepared"]) {
            itemPrepared(serial, qnt);
          }
        }
        itemData = null;
        _fieldFocusChange(context, itemFocus, itemFocus);
        change(null, status: RxStatus.success());
      });
    }

//
  }

  void qtyChanged(context, data) async {
    if (withExp) {
      _fieldFocusChange(context, qtyFocus, monthFocus);
      if (expDate != null) {
        submit(context);
      }
// _fieldFocusChange(context, qtyFocus, monthFocus)
    } else {
      submit(context);
    }
  }

  void wholeQtyChanged(context, data) async {
    _fieldFocusChange(context, wholeQtyFocus, qtyFocus);
  }

  void monthChanged(context, data) {
    _fieldFocusChange(context, monthFocus, yearFocus);
  }

  void yearChanged(context, data) {
    submit(context);
  }

  @override
  void onClose() {
    codeController.dispose();
    qtyController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.onClose();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
