class SignInRequest {
  String? userName;
  String? userPassword;

  SignInRequest({this.userName, this.userPassword});

  SignInRequest.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    userPassword = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserName'] = this.userName;
    data['Password'] = this.userPassword;
    return data;
  }
}