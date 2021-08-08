import 'package:elnozom/app/modules/list/doc_model.dart';
import 'package:elnozom/app/modules/list/doc_req_model.dart';
import 'package:elnozom/app/modules/list/providers/doc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ListController extends GetxController with StateMixin<List<dynamic>> {
  final localeStorage = GetStorage();
  final Map req = {"devNo": 1, "trSerial": Get.arguments.trSerial, "stCode": 1};
  final Map docNoReq = {
    "DevNo": 1,
    "TrSerial": Get.arguments.trSerial,
    "StoreCode": 1
  };

  List<String> columns = [
    "رقم",
    "الحساب",
    "تعديل",
  ];
  List<String> columnsKeys = [
    "DocNo",
    "AccountName",
    "edit",
  ];
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

// DataRow(
//                 cells: ListController().generateRows(data),
//               ),

  void createDoc() {
    if (Get.arguments.trSerial == 100) {
      Get.toNamed("/config", arguments: Get.arguments);
    } else {
      docNoReq['DevNo'] = localeStorage.read('device') != null
          ? int.parse(localeStorage.read('device'))
          : 1;
      docNoReq['StoreCode'] = localeStorage.read('store') != null
          ? int.parse(localeStorage.read('store'))
          : 1;
      DocProvider().getDocNo(docNoReq).then((resp) {
        Get.arguments.docNo = resp;
        if (Get.arguments.type != -1) {
          Get.toNamed("/config", arguments: Get.arguments);
        } else {
          Get.toNamed("/edit", arguments: Get.arguments);
        }
      }, onError: (err) {
        print(err);
      });
    }
  }

  void getItems() async {
    req['devNo'] = localeStorage.read('device') != null
        ? int.parse(localeStorage.read('device'))
        : 1;
    req['stCode'] = localeStorage.read('store') != null
        ? int.parse(localeStorage.read('store'))
        : 1;
    DocProvider().getDocs(req).then((resp) {
      change(resp, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void editDoc(doc , account) {
    Get.arguments.docNo = doc;
    Get.arguments.accSerial = account;
    Get.toNamed("/edit", arguments: Get.arguments);
  }

  DataRow generateRows(data, index) {
    
    List<DataCell> wid = [];
    for (var i = 0; i < columnsKeys.length; i++) {
      if (columnsKeys[i] == 'edit') {
        wid.add(DataCell(TextButton(
            onPressed: () => {editDoc(data[index]['DocNo'] , data[index]['AccontSerial'])},
            child: Text('تعديل'))));
      } else if (columnsKeys[i] == 'AccountName') {
        if (data[index][columnsKeys[i]] == '0') {
          wid.add(DataCell(Text('لا يوجد حساب')));
        } else {
          wid.add(DataCell(Text(data[index][columnsKeys[i]].toString())));
        }
      } else {
        wid.add(DataCell(Text(data[index][columnsKeys[i]].toString())));
      }
    }
    return DataRow(
      cells: wid,
    );
  }

  bool isLoading = true;
  @override
  void onInit() async {
    super.onInit();
    getItems();
  }
}
