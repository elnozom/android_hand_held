class Config {
  int? trSerial;
  int? type;
  int? accType;
  int? docNo;
  int? accSerial;
  int? toStore;

  Config(
      {this.trSerial,
      this.type,
      this.accType,
      this.docNo,
      this.accSerial,
      this.toStore});

  Config.fromJson(Map<String, dynamic> json) {
    trSerial = json['trSerial'];
    type = json['type'];
    accType = json['accType'];
    docNo = json['docNo'];
    accSerial = json['accSerial'];
    toStore = json['toStore'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['trSerial'] = trSerial;
    data['type'] = type;
    data['accType'] = accType;
    data['docNo'] = docNo;
    data['accSerial'] = accSerial;
    data['toStore'] = toStore;
    return data;
  }
}
