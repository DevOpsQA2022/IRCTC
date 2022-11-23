import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:irctc/model/station_response.dart';
import 'package:irctc/model/train_track_response.dart';
import 'package:irctc/support/colors.dart';
import 'package:irctc/support/string.dart';


class HistoryCard extends StatelessWidget {
  TrainList trainList;
  StationResponse value;
  String? stationName;
  int? time;
  String startTime;
  HistoryCard( this.trainList, this.value, this.startTime,    {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    for(int i=0;i<value.stationList!.length;i++){
      if(trainList.stationId==value.stationList![i].stationId){
        stationName=value.stationList![i].stationName;
        time=value.stationList![i].time;
      }
    }
    return Card(
      elevation: 10,
      shadowColor: MyColors.black,
      color: MyColors.lightGray,
      child: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width * .95,
        //height: 50,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children:   [
                Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Station: ",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(stationName??""),

                  ],
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Scheduled Arrival: ",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(time != null?DateFormat('hh:mm a').format(DateFormat("hh:mm a").parse(startTime).add(Duration(minutes:time!))):""),

                  ],
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Actual Arrival: ",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(trainList.reachedTime??""),

                  ],
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Scheduled Departure Time: ",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(time != null?DateFormat('hh:mm a').format(DateFormat("hh:mm a").parse(startTime).add(Duration(minutes:time!+2))):""),

                  ],
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Actual Departure Time: ",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(trainList.departureTime??""),

                  ],
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Reason: ",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(trainList.reason!),

                  ],
                ),
                // IntrinsicHeight (
                //   child: Row(
                //     mainAxisAlignment:
                //     MainAxisAlignment.spaceAround,
                //     children: [
                //       Text(stationName!),
                //       const VerticalDivider(
                //         color: MyColors.gray,
                //         width: 1,
                //         thickness: 1,
                //       ),
                //       Text(DateFormat('hh:mm a').format(DateFormat("hh:mm a").parse(startTime).add(Duration(minutes:time!)))),
                //       const VerticalDivider(
                //         color: MyColors.gray,
                //         width: 1,
                //         thickness: 1,
                //       ),
                //       Text(trainList.reachedTime!),
                //       const VerticalDivider(
                //         color: MyColors.gray,
                //         width: 1,
                //         thickness: 1,
                //       ),
                //       Text(trainList.reason!),
                //
                //     ],
                //   ),
                // ),
                // ListTile(
                //   leading:Text(stationName!),
                //   title:  Text(DateFormat('hh:mm a').format(DateFormat("hh:mm a").parse(startTime).add(Duration(minutes:time!)))),
                //   subtitle: Text(trainList.reason!),
                //   trailing: Text(trainList.reachedTime!),
                //
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}