class Doc {
  int? docNo;
  int? storeCode;
  int? accontSerial;
  int? transSerial;
  String? accountName;
  int? accountCode;

  Doc(
      {this.docNo,
      this.storeCode,
      this.accontSerial,
      this.transSerial,
      this.accountName,
      this.accountCode});

  Doc.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    storeCode = json['StoreCode'];
    accontSerial = json['AccontSerial'];
    transSerial = json['TransSerial'];
    accountName = json['AccountName'];
    accountCode = json['AccountCode'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['DocNo'] = docNo;
    data['StoreCode'] = storeCode;
    data['AccontSerial'] = accontSerial;
    data['TransSerial'] = transSerial;
    data['AccountName'] = accountName;
    data['AccountCode'] = accountCode;
    return data;
  }
}
