class StationResponse {
  String? id;
  List<StationList>? stationList;

  StationResponse({this.id, this.stationList});

  StationResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    if (json['StationList'] != null) {
      stationList = <StationList>[];
      json['StationList'].forEach((v) {
        stationList!.add(new StationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.stationList != null) {
      data['StationList'] = this.stationList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StationList {
  String? id;
  int? stationId;
  String? stationName;
  int? time;

  StationList({this.id, this.stationId, this.stationName, this.time});

  StationList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    stationId = json['StationId'];
    stationName = json['StationName'];
    time = json['Time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['StationId'] = this.stationId;
    data['StationName'] = this.stationName;
    data['Time'] = this.time;
    return data;
  }
}
