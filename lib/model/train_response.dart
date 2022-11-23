class TrainResponse {
  String? id;
  List<TrainList>? trainList;

  TrainResponse({this.id, this.trainList});

  TrainResponse.fromJson(Map<String, dynamic> json) {
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
  int? trainId;
  String? trainNo;
  String? trainName;
  String? startTime;
  String? endTime;
  String? startPlace;
  String? endPlace;

  TrainList(
      {this.id,
        this.trainId,
        this.trainNo,
        this.trainName,
        this.startTime,
        this.endTime,
        this.startPlace,
        this.endPlace});

  TrainList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    trainId = json['TrainId'];
    trainNo = json['TrainNo'];
    trainName = json['TrainName'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    startPlace = json['StartPlace'];
    endPlace = json['EndPlace'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TrainId'] = this.trainId;
    data['TrainNo'] = this.trainNo;
    data['TrainName'] = this.trainName;
    data['StartTime'] = this.startTime;
    data['EndTime'] = this.endTime;
    data['StartPlace'] = this.startPlace;
    data['EndPlace'] = this.endPlace;
    return data;
  }
}
