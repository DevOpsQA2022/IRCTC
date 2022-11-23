import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:irctc/controller/live_status_update_controller.dart';
import 'package:irctc/support/colors.dart';
import 'package:irctc/support/string.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);
  final LiveStatusUpdateController controller =
      Get.put(LiveStatusUpdateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          iconTheme: const IconThemeData(color: MyColors.kSecondaryColor),
          //  automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text(
              MyString.viewLog,
              style: TextStyle(color: MyColors.kSecondaryColor, fontSize: 20),
            ),
          ),
          elevation: 0,
        ),
      ),
      body: Center(
        child: Card(
          elevation: 50,
          shadowColor: MyColors.black,
          color: MyColors.white,
          child: SingleChildScrollView(

            child: Obx(
              () => Column(
                children: [
//               Container(
//                 width: MediaQuery.of(context).size.width * .90,
//                 child: IntrinsicHeight(
//                   child: Row(
//                     mainAxisAlignment:
//                     MainAxisAlignment.spaceAround,
//                     children: const [
//                       Text("Station",style: TextStyle(fontWeight: FontWeight.bold),),
//                       const VerticalDivider(
//                         color: MyColors.gray,
//                         width: 1,
//                         thickness: 1,
//                       ),
//                       Text("Actual \nTime",style: TextStyle(fontWeight: FontWeight.bold),),
//                       const VerticalDivider(
//                         color: MyColors.gray,
//                         width: 1,
//                         thickness: 1,
//                       ),
//                       Text("Arrived \nTime",style: TextStyle(fontWeight: FontWeight.bold),),
//                       const VerticalDivider(
//                         color: MyColors.gray,
//                         width: 1,
//                         thickness: 1,
//                       ),
//                       Text("Reason",style: TextStyle(fontWeight: FontWeight.bold),),
//                     ],
//                   ),
//                 ),
//               ),
// SizedBox(height: 20,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .90,
                    height: MediaQuery.of(context).size.height * .75,
                    child: SingleChildScrollView(
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(MyString.guardName+" :",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(controller.userName.value,style: TextStyle(fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(MyString.driverName+" :",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(controller.driverName!,style: TextStyle(fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(MyString.trainNumber+" :",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(controller.trainId!,style: TextStyle(fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(MyString.assistanceName+" :",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(controller.assistName!,style: TextStyle(fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ],
                          ),



                          controller.trainTrackResponse.value.trainList != null&&
                          controller.stationResponse.value.stationList != null
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: createTable(
                                      MediaQuery.of(context).size.width * .90))
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: createEmptyTable(MediaQuery.of(context).size.width * .90)),

                          const SizedBox(height: 30,),
                          // controller.trainTrackResponse.value.trainList != null?
                          // ListView.builder(
                          //     shrinkWrap: true,
                          //     controller: controller.scrollController,
                          //     itemCount:
                          //     controller.trainTrackResponse.value.trainList!.length,
                          //     itemBuilder: (context, index) {
                          //       return  HistoryCard(controller.trainTrackResponse.value.trainList![index],controller.stationResponse.value,controller.startTime!);
                          //     }):Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createTable(double d) {
    List<TableRow> rows = [];
    rows.add(const TableRow(
        decoration: BoxDecoration(color: MyColors.kSecondaryColor),
        children: [
          Center(
              child: Text("Station ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
          Center(
              child: Text("Sch.Arr ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
          Center(
              child: Text("Act.Arr ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
          Center(
              child: Text("Sch.Dept ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
          Center(
              child: Text("Act.Dept ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
          Center(
              child: Text("Reason ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
        ]));
    for (int i = 0;
        i < controller.trainTrackResponse.value.trainList!.length;
        i++) {
      String? stationName;
      int? time;
      for (int j = 0;
          j < controller.stationResponse.value.stationList!.length;
          j++) {
        if (controller.trainTrackResponse.value.trainList![i].stationId ==
            controller.stationResponse.value.stationList![j].stationId) {
          stationName =
              controller.stationResponse.value.stationList![j].stationName;
          time = controller.stationResponse.value.stationList![j].time;
        }
      }
      rows.add(TableRow(children: [
        Center(
            child: Text(stationName ??
                controller.trainTrackResponse.value.trainList![i].status!)),
        Center(
            child: Text(time != null
                ? DateFormat('HH:mm').format(DateFormat("hh:mm a")
                    .parse(controller.startTime!)
                    .add(Duration(minutes: time)))
                : "")),
        Center(
            child: Text(
                controller.trainTrackResponse.value.trainList![i].reachedTime ??
                    "")),
        Center(
            child: Text(time != null
                ? DateFormat('HH:mm').format(DateFormat("hh:mm a")
                    .parse(controller.startTime!)
                    .add(Duration(minutes: time + 2)))
                : "")),
        Center(
            child: Text(controller
                    .trainTrackResponse.value.trainList![i].departureTime ??
                "")),
        Center(
            child: Text(
                controller.trainTrackResponse.value.trainList![i].reason!)),
      ]));
    }
    return Table(
      children: rows,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(),
      // defaultColumnWidth: FixedColumnWidth(d),
      columnWidths: {
        0: FixedColumnWidth(d / 4),
        1: FixedColumnWidth( d / 9),
        2: FixedColumnWidth( d / 9),
        3: FixedColumnWidth( d / 9),
        4: FixedColumnWidth( d / 9),
        5: FixedColumnWidth( d / 4),
      },
    );
  }

  Widget createEmptyTable(double d) {
    List<TableRow> rows = [];
    rows.add(const TableRow(
        decoration: BoxDecoration(color: MyColors.kSecondaryColor),
        children: [
          Center(
              child: Text("Station ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
          Center(
              child: Text("Sch.Arr ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
          Center(
              child: Text("Act.Arr ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
          Center(
              child: Text("Sch.Dept ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
          Center(
              child: Text("Act.Dept ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
          Center(
              child: Text("Reason ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor))),
        ]));

    return Table(
      children: rows,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(),
      columnWidths:  {
        0: FixedColumnWidth(d / 4),
        1: FixedColumnWidth( d / 9),
        2: FixedColumnWidth( d / 9),
        3: FixedColumnWidth( d / 9),
        4: FixedColumnWidth( d / 9),
        5: FixedColumnWidth( d / 4),
      },
    );
  }
}
