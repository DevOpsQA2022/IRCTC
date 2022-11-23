class TrainTrackRequest {
  String? latitude;
  String? longitude;
  String? reachedTime;
  String? departureTime;
  String? status;
  String? reason;
  int? trainId;
  int? userId;
  int? trainRecordId;
  int? stationId;
  int? loginId;

  TrainTrackRequest(
      {this.latitude,
        this.longitude,
        this.reachedTime,
        this.status,
        this.reason,
        this.trainId,
        this.userId,
        this.trainRecordId,
        this.departureTime,
        this.stationId,
        this.loginId});

  TrainTrackRequest.fromJson(Map<String, dynamic> json) {
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    reachedTime = json['ReachedTime'];
    status = json['Status'];
    reason = json['Reason'];
    trainId = json['TrainId'];
    userId = json['UserId'];
    trainRecordId = json['TrainRecordId'];
    stationId = json['StationId'];
    loginId = json['LoginId'];
    departureTime = json['DepartureTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['ReachedTime'] = this.reachedTime;
    data['Status'] = this.status;
    data['Reason'] = this.reason;
    data['TrainId'] = this.trainId;
    data['UserId'] = this.userId;
    data['TrainRecordId'] = this.trainRecordId;
    data['StationId'] = this.stationId;
    data['LoginId'] = this.loginId;
    data['DepartureTime'] = this.departureTime;
    print(data.toString());
    return data;
  }
}
