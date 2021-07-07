import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('الاعدادات'),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.topRight,
            child: Column(
              children: [
                controller.obx((state) => controller.stores != []
                    ? DropdownButton<String>(
                        isExpanded: true,
                        items: controller.stores
                            .map((data) => DropdownMenuItem<String>(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                        onChanged: controller.storeChanged)
                    : Text(state.toString())),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: controller.deviceController,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (data) =>
                      {controller.deviceChanged(data)},
                  decoration: const InputDecoration(labelText: 'الجهاز'),
                ),

                RaisedButton(onPressed: (){
                  controller.submit();
                  
                }  ,child:Text('حفظ'))
              ],
            )));
  }
}
