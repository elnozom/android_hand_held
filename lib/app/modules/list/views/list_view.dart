import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/list_controller.dart';

class ListView extends GetView<ListController> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          await Get.offAllNamed('/home', arguments: Get.arguments);
          return true;
        },
        child:  Scaffold(
        appBar: AppBar(
          title: Text('المستندات المفتوحة'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => {controller.createDoc()},
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: Container(
          alignment: Alignment.topCenter,
          
          child: controller.obx(
            (state) => state != null ?  DataTable(
              columns: controller.generateColumns(),
              rows: <DataRow>[
                for (var i = 0; i < state.length; i++) controller.generateRows(state , i),
              ],
            ) : Text('لا يوجد مستندات مفتوحة'),
          ),
        )));
  }
}
