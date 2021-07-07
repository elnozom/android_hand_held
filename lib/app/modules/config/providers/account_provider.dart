import 'package:get/get.dart';

import '../account_model.dart';
import 'package:elnozom/common/config.dart';

class AccountProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Account.fromJson(map);
      if (map is List)
        return map.map((item) => Account.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }
  Future<List<dynamic>?> getAccount(Map data) async {
    print('${apiUrl}get-account');
    final response = await post('${apiUrl}get-account' , data);
    if(response.status.hasError){
      print('error');
     return Future.error(response.statusText.toString());
   } else {
     return response.body;
   }
  }
  
}
