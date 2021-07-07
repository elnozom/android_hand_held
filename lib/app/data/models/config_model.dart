class Config {
  int? trSerial;
  int? type;
  int? accType;
  int? docNo;
  int? accSerial;

  Config(
      {this.trSerial, this.type, this.accType, this.docNo, this.accSerial});

  Config.fromJson(Map<String, dynamic> json) {
    trSerial = json['trSerial'];
    type = json['type'];
    accType = json['accType'];
    docNo = json['docNo'];
    accSerial = json['accSerial'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['trSerial'] = trSerial;
    data['type'] = type;
    data['accType'] = accType;
    data['docNo'] = docNo;
    data['accSerial'] = accSerial;
    return data;
  }
}
