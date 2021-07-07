class Account {
  int? serial;
  int? accountCode;
  String? accountName;

  Account({this.serial, this.accountCode, this.accountName});

  Account.fromJson(Map<String, dynamic> json) {
    serial = json['Serial'];
    accountCode = json['AccountCode'];
    accountName = json['AccountName'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Serial'] = serial;
    data['AccountCode'] = accountCode;
    data['AccountName'] = accountName;
    return data;
  }
}
