import 'package:elnozom/common/config.dart';
import 'package:get/get.dart';

import '../store_model.dart';

class StoreProvider extends GetConnect {
  @override
  

   Future<List<dynamic>> getStores() async {
    final response = await get('${apiUrl}cashtry/stores');
    return response.body;
  }
}
