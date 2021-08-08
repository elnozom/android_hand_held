import 'dart:convert';

import 'package:elnozom/app/modules/edit/doc_item_model.dart';
import 'package:get/get.dart';
import 'package:elnozom/common/config.dart';

class DocItemProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = '${apiUrl}';
  }

  Future<List<dynamic>?> getItem(Map data) async {
    final response = await post('${apiUrl}get-item' , data);
    if(response.status.hasError){
     return Future.error(response.statusText.toString());
   } else {
     return response.body;
   }
  }

  Future<bool> removeItem(Map data) async {
    final response = await post('${apiUrl}delete-item' , data);
    if(response.status.hasError){
     return Future.error(response.statusText.toString());
   } else {
     return true;
   }
  }

  Future<bool> insertItem(Map data) async {
    final response = await post('${apiUrl}insert-item' , data);
    if(response.status.hasError){
     return Future.error(response.statusText.toString());
   } else {
     return true;
   }
  }
  Future<List<dynamic>?> getItems(Map data) async {
    final response = await post('${apiUrl}get-doc-items' , data);
    if(response.status.hasError){
     return Future.error(response.statusText.toString());
   } else {
     return response.body;
   }
  }
  
  Future<List<dynamic>?> closePrepareDoc(Map data) async {
    final response = await post('${apiUrl}invoice/close' , data);
    if(response.status.hasError){
     return Future.error(response.statusText.toString());
   } else {
     return response.body;
   }
  
  }

  Future<bool> closeDoc(Map data) async {
    final response = await post('${apiUrl}close-doc' , data);
    if(response.status.hasError){
     return Future.error(response.statusText.toString());
   } else {
     return true;
   }
  }
}
