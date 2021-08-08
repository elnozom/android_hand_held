import 'package:get/get.dart';

import '../models/config_model.dart';

class ConfigProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Config.fromJson(map);
      if (map is List) return map.map((item) => Config.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Config?> getConfig(int id) async {
    final response = await get('config/$id');
    return response.body;
  }

  Future<Response<Config>> postConfig(Config config) async =>
      await post('config', config);
  Future<Response> deleteConfig(int id) async => await delete('config/$id');
}
