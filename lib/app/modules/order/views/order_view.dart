import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../controllers/order_controller.dart';

final _formKey = GlobalKey<FormBuilderState>();
void _onChanged(valid) {
  print('changed');
}

class Item {
  Item( this.serial,
        this.itemName,
        this.minorPerMajor,
        this.pOSPP,
        this.pOSTP,
        this.byWeight,
        this.withExp,
        this.itemHasAntherUnit,
        this.avrWait,
        this.expirey);
  final String serial,
          itemName,
          minorPerMajor,
          pOSPP,
          pOSTP,
          byWeight,
          withExp,
          itemHasAntherUnit,
          avrWait,
          expirey;
  @override
  String toString() => itemName;
}
class OrderView extends GetView<OrderController> {
  @override
  var genderOptions = ['male', 'female'];
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('OrderView'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'wholeQnt',
                              focusNode: controller.wholeQntNode,
                              decoration: InputDecoration(
                                labelText: 'الكمية الكلية',
                              ),
                              onSubmitted: (text) {
                                controller.wholeQntChanged(context, text);
                              },
                              // valueTransformer: (text) => num.tryParse(text),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.numeric(context),
                                FormBuilderValidators.min(context, .1),
                              ]),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'qnt',
                              focusNode: controller.qntNode,
                              decoration: InputDecoration(
                                labelText: 'الكمية الجرئية',
                              ),
                              onChanged: (text) {
                                controller.qntChanged(context, text);
                              },
                              // valueTransformer: (text) => num.tryParse(text),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.numeric(context),
                                FormBuilderValidators.min(context, 0),
                              ]),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                           controller.submit(context);
                          } else {
                            print("validation failed");
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
