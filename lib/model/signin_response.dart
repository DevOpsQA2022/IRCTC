class SignInResponse {
  String? id;
  int? responseResult;
  String? responseMessage;

  SignInResponse(
      {this.id, this.responseResult, this.responseMessage,});

  SignInResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    responseResult = json['ResponseResult'];
    responseMessage = json['ResponseMessage'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['ResponseResult'] = this.responseResult;
    data['ResponseMessage'] = this.responseMessage;

    return data;
  }
}
