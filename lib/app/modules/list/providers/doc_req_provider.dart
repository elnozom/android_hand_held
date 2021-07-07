import 'package:get/get.dart';

import '../doc_req_model.dart';

class DocReqProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return DocReq.fromJson(map);
      if (map is List) return map.map((item) => DocReq.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<DocReq?> getDocReq(int id) async {
    final response = await get('docreq/$id');
    return response.body;
  }

  Future<Response<DocReq>> postDocReq(DocReq docreq) async =>
      await post('docreq', docreq);
  Future<Response> deleteDocReq(int id) async => await delete('docreq/$id');
}
