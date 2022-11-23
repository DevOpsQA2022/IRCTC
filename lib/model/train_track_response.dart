class TrainTrackResponse {
  String? id;
  List<TrainList>? trainList;

  TrainTrackResponse({this.id, this.trainList});

  TrainTrackResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    if (json['TrainList'] != null) {
      trainList = <TrainList>[];
      json['TrainList'].forEach((v) {
        trainList!.add(new TrainList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.trainList != null) {
      data['TrainList'] = this.trainList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrainList {
  String? id;
  int? trainRecordId;
  String? latitude;
  String? longitude;
  String? reachedTime;
  String? departureTime;
  String? status;
  String? reason;
  int? trainId;
  int? userId;
  int? loginId;
  int? stationId;
  int? createdBy;
  int? modifiedBy;
  String? createdDate;
  String? modifiedDate;

  TrainList(
      {this.id,
        this.trainRecordId,
        this.latitude,
        this.longitude,
        this.reachedTime,
        this.departureTime,
        this.status,
        this.reason,
        this.trainId,
        this.userId,
        this.loginId,
        this.stationId,
        this.createdBy,
        this.modifiedBy,
        this.createdDate,
        this.modifiedDate});

  TrainList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    trainRecordId = json['TrainRecordId'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    reachedTime = json['ReachedTime'];
    status = json['Status'];
    reason = json['Reason'];
    trainId = json['TrainId'];
    userId = json['UserId'];
    loginId = json['LoginId'];
    stationId = json['StationId'];
    createdBy = json['CreatedBy'];
    modifiedBy = json['ModifiedBy'];
    createdDate = json['CreatedDate'];
    modifiedDate = json['ModifiedDate'];
    departureTime = json['DepartureTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TrainRecordId'] = this.trainRecordId;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['ReachedTime'] = this.reachedTime;
    data['Status'] = this.status;
    data['Reason'] = this.reason;
    data['TrainId'] = this.trainId;
    data['UserId'] = this.userId;
    data['LoginId'] = this.loginId;
    data['StationId'] = this.stationId;
    data['CreatedBy'] = this.createdBy;
    data['ModifiedBy'] = this.modifiedBy;
    data['CreatedDate'] = this.createdDate;
    data['ModifiedDate'] = this.modifiedDate;
    data['DepartureTime'] = this.departureTime;
    return data;
  }
}
