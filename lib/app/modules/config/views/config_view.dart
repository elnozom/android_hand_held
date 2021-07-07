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
          (state) => Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.codeController,
                    decoration:
                        const InputDecoration(labelText: 'ادخل كود الحساب'),
                    onFieldSubmitted: (data) =>
                        {controller.codeSubmitted(context, data)},
                  ),
                  controller.notFound
                      ? Text('لا يوجد حساب بهذا الكود')
                      : SizedBox(height: 0),

                  controller.serialErr
                      ? Text('من فضلك اختر حساب')
                      : SizedBox(height: 0),
                  Text('او'),
                  SimpleAutoCompleteTextField(
                    suggestions: controller.suggestions,
                    controller: controller.nameController,
                    textChanged: (text) =>
                        controller.nameChanged(context, text),
                    textSubmitted: (text) =>
                        controller.nameSubmitted(context, text),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        hintText: 'اختر الحساب'),
                  ),
                  RaisedButton(
                    child: Text('حفظ'),
                    onPressed: () => {controller.create()},
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
