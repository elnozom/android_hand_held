import 'package:elnozom/app/modules/edit/providers/doc_item_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:date_format/date_format.dart';
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
  DateTime? expDate = null;
  bool itemNotFound = false;
  bool expExisted = false;
  bool dateErr = false;
  bool withExp = false;
  bool qtyHidden = false;
  bool yearErr = false;
  bool qntErr = false;

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
    monthController.dispose();
    yearController.dispose();
    super.onClose();
  }

  void monthChanged(context, data) {
    if(data.length > 2){
      dateErr = true;
    }
    int intD = int.parse(data);
    if(intD > 12 || intD <=0){
      dateErr = true;
    }
    _fieldFocusChange(context, monthFocus, yearFocus);
  }

  void yearChanged(context, data) {
     if(!(data.length == 2 || data.length == 4)){
      dateErr = true;
    }
    int intD = int.parse(data);
    if(data.length == 2){
      if(intD > 21 || intD <=30){
        dateErr = true;
      }
    } else if(data.length == 4){
      if(intD > 2021 || intD <=2030){
        dateErr = true;
      }
    }
    _fieldFocusChange(context, monthFocus, yearFocus);
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
        expExisted = false;
        if (item![0]['WithExp']) {
          if (item![0]['Expirey'] != '0') {
            monthController.text = item![0]['Expirey'].substring(0, 2);
            yearController.text = item![0]['Expirey'].substring(2);
            expExisted = true;
          }
        }
        if (item![0]['MinorPerMajor'] == 1) {
          qtyHidden = true;
          qtyController.text = "0";
        } else {
          qtyHidden = false;
        }
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
      _fieldFocusChange(context, qtyFocus, monthFocus);
      if (expDate != null) {
        submit(context);
      }
// _fieldFocusChange(context, qtyFocus, monthFocus)
    } else {
      submit(context);
    }
  }

  void qtyWholeChanged(context, data) {
    if (!qtyHidden) {
      _fieldFocusChange(context, qtyWholeFocus, qtyFocus);
    }
    if (withExp && qtyHidden) {
      _fieldFocusChange(context, qtyWholeFocus, monthFocus);
    }

    if (!withExp && qtyHidden) {
      submit(context);
    }
  }

  String? validator(String? value) {
    if (value == null) {
      return 'هذا الحقل اجباري';
    }
    return null;
  }
DateTime? getDate(String str) {
  try {
    var date  = DateTime.parse(str);
    return date;
  } catch (e) {
    return null;
  }
}


  void submit(context) async {
    //validate the date is bigger than now

    // return error message if date is in the past

    // create date variable
    
    int qnt;
    qtyController.text == null ? 0 : qtyController.text;
    if (item![0]['ByWeight']) {
      qnt = int.parse(wholeQtyController.text);
    } else {
      int minor = item![0]['MinorPerMajor'];
      qnt = int.parse(wholeQtyController.text) * minor +
          int.parse(qtyController.text);
    }

    if (qnt == 0) {
      qntErr = true;
    } else {
      qntErr = false;
      var expD = monthController.text != "" ? '${monthController.text}/1/${yearController.text}' : null;
      yearChanged(context , yearController.text);
      monthChanged(context , monthController.text);
      if(!dateErr){

        final Map req = {
          "DNo": Get.arguments.docNo,
          "TrS": Get.arguments.trSerial,
          "AccS": Get.arguments.accSerial,
          "ItmS": item![0]['Serial'],
          "Qnt": qnt,
          "StCode": localeStorage.read('store') != null
              ? int.parse(localeStorage.read('store'))
              : 1,
          "StCode2": Get.arguments.toStore != null ? Get.arguments.toStore : 0,
          "InvNo": 0,
          "ItmBarCode": codeController.text,
          "DevNo": localeStorage.read('device') != null
              ? int.parse(localeStorage.read('device'))
              : 1,
          "ExpDate": expD
        };

        var resp = await DocItemProvider().insertItem(req);
        item = [];
        qtyController.clear();
        wholeQtyController.clear();
        codeController.clear();
        monthController.clear();
        yearController.clear();
        expDate = null;
        withExp = false;
        fetchItems();
        _fieldFocusChange(context, qtyFocus, itemFocus);
      }
    }
    print(Get.arguments);

//
  }

  void fetchItems() async {
    final Map req2 = {
      "DevNo": localeStorage.read('device') != null
          ? int.parse(localeStorage.read('device'))
          : 1,
      "TrSerial": Get.arguments.trSerial,
      "StoreCode": localeStorage.read('store') != null
          ? int.parse(localeStorage.read('store'))
          : 1,
      "DocNo": Get.arguments.docNo
    };
    var resp2 = await DocItemProvider().getItems(req2);
    change(resp2, status: RxStatus.success());
  }

  void closeDoc() async {
    final Map req2 = {
      "DevNo": localeStorage.read('device') != null
          ? int.parse(localeStorage.read('device'))
          : 1,
      "trans": Get.arguments.trSerial,
      "DocNo": Get.arguments.docNo
    };
    var resp2 = await DocItemProvider().closeDoc(req2);
    Get.toNamed('/home');
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  List<String> columns = [
    "المنتج",
    "اجرائات",
  ];
  List<String> columnsKeys = [
    "ItemName",
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
        wid.add(DataCell(RaisedButton(
            onPressed: () async {
              var req = {"Serial": data[index]['Serial']};
              await DocItemProvider().removeItem(req);
              fetchItems();
            },
            child: Text('حذف'))));
      } else if (columnsKeys[i] == 'ItemName') {
        var wholQnt;
        var qnt;
        if (data[index]['ByWeight'] == true) {
          wholQnt = data[index]['Qnt'].toString();
          qnt = 0;
        } else {
          wholQnt = (data[index]['Qnt'] / data[index]['MinorPerMajor'])
              .floor()
              .toString();
          qnt = (data[index]['Qnt'].remainder(data[index]['MinorPerMajor']))
              .toString();
        }
        wid.add(DataCell(Text(
            '${data[index][columnsKeys[i]].toString()} \n  الكمية الكلية : ${wholQnt} \n الكمية الجزئية : ${qnt} ')));
      } else {
        wid.add(DataCell(Text(data[index][columnsKeys[i]].toString())));
      }
    }

    return DataRow(
      cells: wid,
    );
  }
}
