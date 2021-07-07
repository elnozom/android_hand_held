import 'package:get/get.dart';

import '../tab_model.dart';

class TabProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Tab.fromJson(map);
      if (map is List) return map.map((item) => Tab.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Tab?> getTab(int id) async {
    final response = await get('tab/$id');
    return response.body;
  }

  Future<Response<Tab>> postTab(Tab tab) async => await post('tab', tab);
  Future<Response> deleteTab(int id) async => await delete('tab/$id');
}
