import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_controller.dart';
import 'package:elnozom/common/components/components.dart';

class EditView extends GetView<EditController> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'ادخال الاصناف'),
    Tab(text: 'عرض الاصناف'),
  ];
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          await Get.offAllNamed('/home');
          return true;
        },
        child: Scaffold(
            body: DefaultTabController(
                length: myTabs.length,
                child: Scaffold(
                  appBar: AppBar(
          title: Text('تعديل المستند'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => {controller.closeDoc()},
              icon: Text('غلق'),
            )
          ],
          bottom: TabBar(
                        tabs: myTabs,
                      )
        ),
                  
                  body: controller.obx((state) => TabBarView(children: [
                        insert(context, controller.item),
                        viewItemsTable(state),
                      ])),
                ))));
  }

  Widget viewItemsTable(List<dynamic>? state) {
    return state != null && state.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: [
                DataTable(
                  columns: controller.generateColumns(),
                  dataRowHeight: 110,
                  rows: <DataRow>[
                    for (var i = 0; i < state.length; i++)
                      controller.generateRows(state, i),
                  ],
                ),
              ],
            ),
          )
        : Text("الا يوجد اصناف");
  }

  Widget insert(context, data) {
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
            data.length > 0 && controller.codeController.text != ''
                ? Row(
                    children: [
                      Text(data[0]['ItemName'], textAlign: TextAlign.center),
                      Text('..... المحتوي:'),
                      Text(data[0]['MinorPerMajor'].toString(),
                          textAlign: TextAlign.center),
                    ],
                  )
                : Text(""),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextFormField(
                      focusNode: controller.qtyWholeFocus,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (data) =>
                          {controller.qtyWholeChanged(context, data)},
                      textInputAction: TextInputAction.next,
                      controller: controller.wholeQtyController,
                      decoration:
                          const InputDecoration(labelText: 'الكمية الكلية'),
                      validator: controller.validator,
                    ),
                  ),
                ),
                if (!controller.qtyHidden) Expanded(
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
            if(controller.qntErr) Text("من فضلك ادخل كمية"),
            controller.withExp && !controller.expExisted? Row(
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
                      decoration:
                          const InputDecoration(labelText: 'شهر انتهاء الصلاحية'),
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
                    decoration:
                        const InputDecoration(labelText: 'سنة  انتهاء الصلاحية'),
                    validator: controller.validator,
                  ),
                ),
              ],
            ): SizedBox(height: 0,),
            if(controller.dateErr) Text("من فضلك ادخل تاريخ صلاحية صحيح"),
            
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
}
