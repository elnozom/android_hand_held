import 'package:elnozom/app/modules/list/doc_model.dart';
import 'package:elnozom/app/modules/list/doc_req_model.dart';
import 'package:elnozom/app/modules/list/providers/doc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class UnpreparedController extends GetxController with StateMixin<List<dynamic>> {
  //TODO: Implement UnpreparedController

  final localeStorage = GetStorage();
  

  List<String> columns = [
    "رقم",
    "الحساب",
    "كود الحساب",
  ];
  List<String> columnsKeys = [
    "DocNo",
    "AccName",
    "AccCode",
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

 
  void getItems() async {
     print('asdasd');
    DocProvider().getUnPreparedDocs().then((resp) {
      change(resp, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  DataRow generateRows(data, index) {
    
    List<DataCell> wid = [];
    for (var i = 0; i < columnsKeys.length; i++) {
      if (columnsKeys[i] == 'AccountName') {
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
    
  }
}
