import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import '../controllers/config_controller.dart';

class ConfigView extends GetView<ConfigController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('مستند جديد'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => {controller.create()},
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: controller.obx(
          (state) => SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: controller.formKey,
                child: !controller.isTransaction
                    ? Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            focusNode: controller.codeNode,
                            controller: controller.codeController,
                            decoration: const InputDecoration(
                                labelText: 'ادخل كود الحساب'),
                            onFieldSubmitted: (data) =>
                                {controller.codeSubmitted(context, data)},
                          ),
                          Text(controller.emp),
                          controller.notFound
                              ? Text('لا يوجد حساب بهذا الكود')
                              : SizedBox(height: 0),
                          controller.serialErr
                              ? Text('من فضلك اختر حساب')
                              : SizedBox(height: 0),
                          controller.showAutoComplete
                              ? Text('او')
                              : SizedBox(height: 0),
                          controller.showAutoComplete
                              ? SimpleAutoCompleteTextField(
                                  suggestions: controller.suggestions,
                                  suggestionsAmount: 5,
                                  controller: controller.nameController,
                                  textChanged: (text) =>
                                      controller.nameChanged(context, text),
                                  textSubmitted: (text) =>
                                      controller.nameSubmitted(context, text),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.black12,
                                      hintText: 'اختر الحساب'),
                                )
                              : SizedBox(height: 0),
                          controller.showInvCode
                              ? TextFormField(
                                  focusNode: controller.invCodeNode,
                                  keyboardType: TextInputType.number,
                                  controller: controller.invCodeController,
                                  decoration: const InputDecoration(
                                      labelText: 'ادخل كود الفاتورة'),
                                  onFieldSubmitted: (data) => {
                                    controller.invCodeSubmitted(context, data)
                                  },
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          controller.invErr
                              ? Text('لا توجد فاتور بهذا الكود')
                              : SizedBox(height: 0),
                          RaisedButton(
                            child: Text('حفظ'),
                            onPressed: () => {controller.create()},
                          )
                        ],
                      )
                    : Column(
                        children: [
                          if (controller.stores != [])
                            Text('اختر المخزن الاخر'),
                          if (controller.stores != [])
                            DropdownButton<String>(
                                isExpanded: true,
                                items: controller.stores
                                    .map((data) => DropdownMenuItem<String>(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                data.storeName,
                                              ),
                                            ],
                                          ),
                                          value: data.storeCode.toString(),
                                        ))
                                    .toList(),
                                value: controller.selectedOption,
                                onChanged: controller.storeChanged),
                          RaisedButton(
                            child: Text('حفظ'),
                            onPressed: () => {controller.create()},
                          )
                        ],
                      ),
              ),
            ),
          ),
        ));
  }
}
