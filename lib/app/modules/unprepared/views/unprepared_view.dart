import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/unprepared_controller.dart';

class UnpreparedView extends GetView<UnpreparedController> {
  @override
  Widget build(BuildContext context) {
    controller.getItems();
    return Scaffold(
      appBar: AppBar(
        title: Text('مستندات لم يتم تحضيرها'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
              child: Container(
            alignment: Alignment.topCenter,
            
            child: controller.obx(
              (state) => state != null ?  DataTable(
                columns: controller.generateColumns(),
                rows: <DataRow>[
                  for (var i = 0; i < state.length; i++) controller.generateRows(state , i),
                ],
              ) : Text('لا يوجد مستندات مفتوحة'),
            ),
          ),
      )
    );
  }
}
