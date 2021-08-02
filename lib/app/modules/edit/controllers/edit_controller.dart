import 'package:elnozom/app/modules/edit/providers/doc_item_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

class EditController extends GetxController with StateMixin<List<dynamic>> {
  final localeStorage = GetStorage();
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final wholeQtyController = TextEditingController();
  final qtyController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  final FocusNode itemFocus = FocusNode();
  final FocusNode qtyFocus = FocusNode();
  final FocusNode qtyWholeFocus = FocusNode();
  final FocusNode monthFocus = FocusNode();
  final FocusNode yearFocus = FocusNode();
  int? docNo = null;
  int? trSerial = null;
  DateTime? expDate = null;
  bool itemNotFound = false;
  bool withExp = false;
  bool yearErr = false;
  bool monthErr = false;
  var minorPerMajor = 1;
  List<dynamic>? item = [];
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    codeController.dispose();
    wholeQtyController.dispose();
    qtyController.dispose();
    super.onClose();
  }

  void monthChanged(context, data) {
    _fieldFocusChange(context, monthFocus, yearFocus);
  }

  void yearChanged(context, data) {
    submit(context);
  }

  void itemChanged(context, data) {
    final Map req = {"BCode": data.toString(), "StoreCode": 1};
    DocItemProvider().getItem(req).then((resp) {
      if (resp == null) {
        _fieldFocusChange(context, itemFocus, itemFocus);
        itemNotFound = true;
      } else {
        itemNotFound = false;
        _fieldFocusChange(context, itemFocus, qtyWholeFocus);
        item = resp;
        withExp = item![0]['WithExp'];
      }
      change(null, status: RxStatus.success());
    }, onError: (err) {
      item = [];
      change(null, status: RxStatus.error(err));
    });
  }

  void qtyChanged(context, data) async {
    if (withExp) {
      docNo = Get.arguments !=null ? Get.arguments.docNo : docNo;
      trSerial = Get.arguments !=null ? Get.arguments.trSerial : trSerial;
      final initialDate = DateTime.now();
      expDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: initialDate,
          initialEntryMode: DatePickerEntryMode.input,
          cancelText: "غلق",
          confirmText: "حفظ",
          initialDatePickerMode: DatePickerMode.year,
          // locale: Locale.fromSubtags(''),
          helpText: "من فضلك ادخل تاريخ الصلاحية",
          lastDate: DateTime(DateTime.now().year + 5));
      if (expDate != null) {
        submit(context);
      }
// _fieldFocusChange(context, qtyFocus, monthFocus)
    } else {
      submit(context);
    }
  }

  void qtyWholeChanged(context, data) {
    _fieldFocusChange(context, qtyWholeFocus, qtyFocus);
  }

  String? validator(String? value) {
    if (value == null) {
      return 'هذا الحقل اجباري';
    }
    return null;
  }

  void submit(context) async {
    //validate the date is bigger than now

    // return error message if date is in the past

    // create date variable
    if (withExp && expDate == null) {
      qtyChanged(context,qtyController.text);
    } else {
      int qnt;
      qtyController.text == null ? 0 : qtyController.text;
      if (item![0]['ByWeight']) {
        qnt = int.parse(wholeQtyController.text);
      } else {
        int minor = item![0]['MinorPerMajor'];
        qnt = int.parse(wholeQtyController.text) * minor +
            int.parse(qtyController.text);
      }
      print("Asdasd");
      // print(Get.arguments);

      final Map req = {
        "DNo": Get.arguments != null ? Get.arguments.docNo :  docNo ,
        "TrS": Get.arguments != null ? Get.arguments.trSerial : trSerial ,
        "AccS": 2,
        "ItmS": item![0]['Serial'],
        "Qnt": qnt,
        "StCode": 1,
        "StCode2": 2,
        "InvNo": 1353,
        "ItmBarCode": codeController.text,
        "DevNo": 1,
        "ExpDate":expDate !=null ? '${expDate!.month}/${expDate!.day}/${expDate!.year}' : null
      };
      print("Asdasd");

      print(req);
      var resp = await DocItemProvider().insertItem(req);
      item = [];
      qtyController.clear();
      wholeQtyController.clear();
      codeController.clear();
      expDate = null;
      fetchItems();
      _fieldFocusChange(context, qtyFocus, itemFocus);
    }

//
  }

  void fetchItems() async {
    final Map req2 = {
      "DevNo": 1,
      "TrSerial": Get.arguments != null ? Get.arguments.trSerial :  trSerial  ,
      "StoreCode": 1,
      "DocNo": Get.arguments != null ? Get.arguments.docNo :docNo
    };
    var resp2 = await DocItemProvider().getItems(req2);
    change(resp2, status: RxStatus.success());
  }

  void closeDoc() async {
    final Map req2 = {
      "DevNo": 1,
      "trans": Get.arguments.trSerial,
      "DocNo": Get.arguments.docNo
    };
    var resp2 = await DocItemProvider().closeDoc(req2);
    Get.toNamed('/home', arguments: Get.arguments);
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  List<String> columns = [
    "الاسم",
    "كلي",
    "جزئي",
    "اجرائات",
  ];
  List<String> columnsKeys = [
    "ItemName",
    "WholeQnt",
    "Qnt",
    "delete",
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
  DataRow generateRows(data, index) {
    List<DataCell> wid = [];
    for (var i = 0; i < columnsKeys.length; i++) {
      if (columnsKeys[i] == 'delete') {
        wid.add(DataCell(TextButton(
            onPressed: () async {
              var req = {"Serial": data[index]['Serial']};
              await DocItemProvider().removeItem(req);
              fetchItems();
            },
            child: Text('delete'))));
      } else if (columnsKeys[i] == 'WholeQnt') {
        if (data[index]['ByWeight'] == false) {
          wid.add(DataCell(Text(data[index]['Qnt'].toString())));
        } else {
          wid.add(DataCell(Text(
              (data[index]['Qnt'] / data[index]['MinorPerMajor']).toString())));
        }
      } else if (columnsKeys[i] == 'Qnt') {
        if (data[index]['ByWeight'] == false) {
          wid.add(DataCell(Text('0')));
        } else {
          wid.add(DataCell(Text(
              (data[index]['Qnt'].remainder(data[index]['MinorPerMajor']))
                  .toString())));
        }
      } else {
        wid.add(DataCell(Text(data[index][columnsKeys[i]].toString())));
      }
    }

    return DataRow(
      cells: wid,
    );
  }
}
