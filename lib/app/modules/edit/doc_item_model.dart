class DocItem {
  int? serial;
  String? itemName;
  int? minorPerMajor;
  double? pOSPP;
  int? pOSTP;
  bool? byWeight;

  DocItem(
      {this.serial,
      this.itemName,
      this.minorPerMajor,
      this.pOSPP,
      this.pOSTP,
      this.byWeight});

  DocItem.fromJson(Map<String, dynamic> json) {
    serial = json['Serial'];
    itemName = json['ItemName'];
    minorPerMajor = json['MinorPerMajor'];
    pOSPP = json['POSPP'];
    pOSTP = json['POSTP'];
    byWeight = json['ByWeight'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Serial'] = serial;
    data['ItemName'] = itemName;
    data['MinorPerMajor'] = minorPerMajor;
    data['POSPP'] = pOSPP;
    data['POSTP'] = pOSTP;
    data['ByWeight'] = byWeight;
    return data;
  }
}
