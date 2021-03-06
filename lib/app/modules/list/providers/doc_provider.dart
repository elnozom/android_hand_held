import 'package:elnozom/app/modules/list/doc_req_model.dart';
import 'package:get/get.dart';

import '../doc_model.dart';
import 'package:elnozom/common/config.dart';

class DocProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Doc.fromJson(map);
      if (map is List) return map.map((item) => Doc.fromJson(item)).toList();
    };
    httpClient.baseUrl = '';
  }

  Future<int> getDocNo(Map data) async {
    final response = await post('${apiUrl}get-doc', data);
    return response.body;
  }

  Future<Response<Doc>> postDoc(Doc doc) async => await post('doc', doc);
  Future<Response> deleteDoc(int id) async => await delete('doc/$id');
  Future<List<dynamic>> getDocs(Map data) async {
    final response = await post('${apiUrl}get-docs', data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return response.body;
    }
  }

  Future<List<dynamic>> getUnPreparedDocs() async {
    final response = await get('${apiUrl}invoice/open');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return response.body;
    }
  }

  Future<List<dynamic>> insertPrepareItem(Map data) async {
    print("data");
    print(data);
    final response = await post('${apiUrl}invoice', data);
    if (response.status.hasError) {
      print(response.statusText.toString());
      return Future.error(response.statusText.toString());
    } else {
      print(response.body);

      return response.body;
    }
  }

  

  Future<List<dynamic>> getInv(Map data) async {
    final response = await get('${apiUrl}invoice?BCode=${data["BCode"]}');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return response.body;
    }
  }
}
