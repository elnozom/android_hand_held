class DocReq {
  int? devNo;
  int? stCode;
  int? trSerial;

  DocReq({this.devNo, this.stCode, this.trSerial});

  DocReq.fromJson(Map<String, dynamic> json) {
    devNo = json['DevNo'];
    stCode = json['StCode'];
    trSerial = json['TrSerial'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['DevNo'] = devNo;
    data['StCode'] = stCode;
    data['TrSerial'] = trSerial;
    return data;
  }
}
