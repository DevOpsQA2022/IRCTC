class AddTrainInfoRequest {
  String? loginTime;
  String? logoutTime;
  String? latitude;
  String? longitude;
  String? logoutLatitude;
  String? logoutLongitude;
  String? guardName;
  String? driverName;
  String? assistanceName;
  int? trainId;
  int? userId;
  int? loginId;

  AddTrainInfoRequest(
      {this.loginTime,
        this.logoutTime,
        this.latitude,
        this.longitude,
        this.logoutLatitude,
        this.logoutLongitude,
        this.guardName,
        this.driverName,
        this.assistanceName,
        this.trainId,
        this.userId,
        this.loginId});

  AddTrainInfoRequest.fromJson(Map<String, dynamic> json) {
    loginTime = json['LoginTime'];
    logoutTime = json['LogoutTime'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    logoutLatitude = json['LogoutLatitude'];
    logoutLongitude = json['LogoutLongitude'];
    guardName = json['GuardName'];
    driverName = json['DriverName'];
    assistanceName = json['AssistanceName'];
    trainId = json['TrainId'];
    userId = json['UserId'];
    loginId = json['LoginId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoginTime'] = this.loginTime;
    data['LogoutTime'] = this.logoutTime;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['LogoutLatitude'] = this.logoutLatitude;
    data['LogoutLongitude'] = this.logoutLongitude;
    data['GuardName'] = this.guardName;
    data['DriverName'] = this.driverName;
    data['AssistanceName'] = this.assistanceName;
    data['TrainId'] = this.trainId;
    data['UserId'] = this.userId;
    data['LoginId'] = this.loginId;
    print(data.toString());
    return data;
  }
}
