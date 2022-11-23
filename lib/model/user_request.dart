class UserRequest {
  int? iDNo;
  String? productCategory;
  String? suburb;
  String? keyWord;

  UserRequest({this.iDNo});

  UserRequest.fromJson(Map<String, dynamic> json) {
    iDNo = json['IDNo'];
    productCategory = json['ProductCategory'];
    suburb = json['Suburb'];
    keyWord = json['KeyWord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDNo'] = this.iDNo;
    data['ProductCategory'] = this.productCategory;
    data['Suburb'] = this.suburb;
    data['KeyWord'] = this.keyWord;
    print("Demo Test"+data.toString());
    return data;
  }
}
