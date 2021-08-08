import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/prepare_controller.dart';

class PrepareView extends GetView<PrepareController> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'ادخال الاصناف'),
    Tab(text: 'عرض الاصناف'),
  ];
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          controller.showBackAlertDialog(context);
          // await Get.offAllNamed('/home', arguments: Get.arguments);
          return true;
        },
        child: Scaffold(
            body: DefaultTabController(
                length: myTabs.length,
                child: Scaffold(
                  appBar: AppBar(
                      title: Text('مراجعة المستند'),
                      centerTitle: false,
                      actions: [
                        IconButton(
                          onPressed: () => {controller.closeDoc()},
                          icon: Text('غلق'),
                        )
                      ],
                      bottom: TabBar(
                        tabs: myTabs,
                      )),
                  body: controller.obx((state) => TabBarView(children: [
                        insert(context, controller),
                        viewItemsTable(state, controller),
                      ])),
                ))));
  }
}

Widget viewItemsTable(List<dynamic>? state, controller) {
  return SingleChildScrollView(
    child: Column(
      children: [
        DataTable(
          columns: controller.generateColumns(),
          dataRowHeight: 110,
          rows: <DataRow>[
            for (var i = 0; i < controller.invoice.length; i++)
              controller.generateRows(i),
          ],
        ),
      ],
    ),
  );
}

Widget insert(context, controller) {
  return Container(
    padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
    child: SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            focusNode: controller.itemFocus,
            controller: controller.codeController,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (data) => {controller.itemChanged(context, data)},
            decoration: const InputDecoration(labelText: 'ادخل كود '),
            validator: controller.validator,
          ),
          if (controller.itemNotFound) Text('لا يوجد صنف بهئا الكود'),
          if (controller.itemData != null)
            Text(
                '${controller.itemData[0]['ItemName']}..... المحتوي:${controller.itemData[0]['MinorPerMajor'].toString()}..... ${controller.itemData[0]['QntPrepare'].toString()}/${controller.itemData[0]['Qnt'].toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(color: controller.itemData[0]['Color'])),
         
            Row(
              children: [
                 if (controller.showWholeQnt) Expanded(
                  child: TextFormField(
                    focusNode: controller.wholeQtyFocus,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (data) =>
                        {controller.wholeQtyChanged(context, data)},
                    controller: controller.wholeQtyController,
                    textInputAction: TextInputAction.done,
                    decoration:
                        const InputDecoration(labelText: 'الكمية الكلية'),
                    validator: controller.validator,
                  ),
                ),
                 if (controller.showQnt) Expanded(
                  child: TextFormField(
                    focusNode: controller.qtyFocus,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (data) =>
                        {controller.qtyChanged(context, data)},
                    controller: controller.qtyController,
                    textInputAction: TextInputAction.done,
                    decoration:
                        const InputDecoration(labelText: 'الكمية الجزئية'),
                    validator: controller.validator,
                  ),
                ),
              ],
            ),
          if (controller.withExp && !controller.expExisted)
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextFormField(
                      focusNode: controller.monthFocus,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (data) =>
                          {controller.monthChanged(context, data)},
                      textInputAction: TextInputAction.next,
                      controller: controller.monthController,
                      decoration: const InputDecoration(
                          labelText: 'شهر انتهاء الصلاحية'),
                      validator: controller.validator,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    focusNode: controller.yearFocus,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (data) =>
                        {controller.yearChanged(context, data)},
                    controller: controller.yearController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                        labelText: 'سنة  انتهاء الصلاحية'),
                    validator: controller.validator,
                  ),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              child: Text('حفظ'),
              onPressed: () => controller.submit(context),
            ),
          )
        ],
      ),
    ),
  );
}
