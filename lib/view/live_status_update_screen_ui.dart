import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:irctc/controller/live_status_update_controller.dart';
import 'package:irctc/controller/man_power_update_controller.dart';
import 'package:irctc/controller/sign_in_controller.dart';
import 'package:irctc/support/colors.dart';
import 'package:irctc/support/constants.dart';
import 'package:irctc/support/images.dart';
import 'package:irctc/support/string.dart';
import 'package:irctc/support/validate_input.dart';
import 'package:irctc/view/man_power_update_screen_ui.dart';
import 'package:irctc/widgets/customize_text_field.dart';
import 'package:irctc/widgets/progressbar.dart';

import 'history_screen_ui.dart';

class LiveStatusUpdateScreen extends StatelessWidget {
  LiveStatusUpdateScreen({Key? key}) : super(key: key);

  final LiveStatusUpdateController controller =
      Get.put(LiveStatusUpdateController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: AdvancedDrawer(
        backdropColor: MyColors.kSecondaryColor,
        controller: controller.advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: true,
        // openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 0.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: SafeArea(
          child: Container(
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 128.0,
                    height: 128.0,
                    margin: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 24.0,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: MyColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      MyImages.irctcLogo,
                    ),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    child: Text(controller.userName.value),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  ListTile(
                    onTap: () {
                      Get.put(SignInController());

                      //controller.getTrainTrackData();
                      Constants.isFromHomeScreen = true;
                      controller.advancedDrawerController.toggleDrawer();
                      Get.put(ManPowerUpdateController());
                      Get.find<ManPowerUpdateController>().getUserInfo();
                      Get.find<ManPowerUpdateController>().getTrainTrackData();
                      Get.to(() =>
                          ManPowerUpdateScreen(controller.userName.value));
                    },
                    leading: const Icon(Icons.arrow_back),
                    title: const Text(MyString.trainInfo),
                  ),
                  ListTile(
                    onTap: () {
                      controller.advancedDrawerController.toggleDrawer();
                      controller.getTrainTrackData();
                      Get.to(() => HistoryScreen());
                    },
                    leading: const Icon(Icons.history),
                    title: const Text(MyString.viewLog),
                  ),
                  ListTile(
                    onTap: () {
                      controller.advancedDrawerController.toggleDrawer();


                      controller.onAlertForSignOut(context);
                      // controller.dbHelper!.delete();
                      // controller.dbHelper!.close();
                    },
                    leading: const Icon(Icons.logout),
                    title: const Text(MyString.signOut),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: MyColors.kPrimaryColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: AppBar(
              // backgroundColor: MyColors.kSecondaryColor,
              leading: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Image.asset(MyImages.irctcLogo, width: 100),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      controller.noteController = TextEditingController();
                      controller.placeController.text =
                          (controller.locationDetails ?? "");
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Scaffold(
                            appBar: PreferredSize(
                              preferredSize: const Size.fromHeight(80.0),
                              child: AppBar(
                                iconTheme: const IconThemeData(
                                    color: MyColors.kSecondaryColor),
                                // automaticallyImplyLeading: false,
                                title: const Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    MyString.addLog,
                                    style: TextStyle(
                                        color: MyColors.kSecondaryColor,
                                        fontSize: 20),
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
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .85,
                                  height:
                                      MediaQuery.of(context).size.height * .70,
                                  child: Form(
                                    key: controller.addLogFormKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            CustomizeTextFormField(
                                              labelText: controller.latTimeController.text.isEmpty?"Latitude":"",
                                              helperText:controller.latTimeController.text.isEmpty?"Latitude":"",
                                              onClick: () {},
                                              onChange: (value) {},
                                              onSave: (value) {},
                                              controller:
                                                  controller.latTimeController,
                                              validator:
                                                  ValidateInput.validateField,
                                              isEnabled: false,
                                              //validator: ValidateInput.validateEmail,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CustomizeTextFormField(
                                              labelText: controller.longTimeController.text.isEmpty?"Longitude":"",
                                              helperText: controller.longTimeController.text.isEmpty?"Longitude":"",
                                              onClick: () {},
                                              onChange: (value) {},
                                              onSave: (value) {},
                                              controller:
                                                  controller.longTimeController,
                                              validator:
                                                  ValidateInput.validateField,
                                              isEnabled: false,
                                              //validator: ValidateInput.validateEmail,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CustomizeTextFormField(
                                              labelText: MyString.place,
                                              helperText: MyString.place,
                                              onClick: () {},
                                              onChange: (value) {},
                                              onSave: (value) {},
                                              controller:
                                                  controller.placeController,
                                              validator:
                                                  ValidateInput.validatePlace,
                                              // isEnabled: false,
                                              //validator: ValidateInput.validateEmail,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CustomizeTextFormField(
                                              labelText: MyString.note,
                                              helperText: MyString.note,
                                              onClick: () {},
                                              onChange: (value) {},
                                              onSave: (value) {},
                                              minLines: 5,
                                              maxLines: 8,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              inputAction:
                                                  TextInputAction.newline,
                                              controller:
                                                  controller.noteController,
                                              validator:
                                                  ValidateInput.validateNote,
                                              //validator: ValidateInput.validateEmail,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  textStyle: const TextStyle(
                                                      color: MyColors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  primary:
                                                      MyColors.kSecondaryColor,
                                                  minimumSize: Size(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .60,
                                                      40)),
                                              onPressed: () {
                                                if (controller
                                                    .addLogFormKey.currentState!
                                                    .validate()) {
                                                  controller
                                                      .addLogInfo(context);
                                                  Navigator.pop(context);
                                                }

                                                //Get.to(() =>   OTPScreen());
                                                //Get.to(() =>   const NotificationSelectionScreen());
                                                // ProgressBar.instance.showProgressbar(context);
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Text(MyString.submit),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.location_on,
                      color: MyColors.kSecondaryColor,
                    )),
                IconButton(
                    onPressed: () {
                      controller.advancedDrawerController.showDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: MyColors.kSecondaryColor,
                    ))
              ],
              leadingWidth: 30,
              title: const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  MyString.trainLiveStatus,
                  style:
                      TextStyle(color: MyColors.kSecondaryColor, fontSize: 20),
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .85,
                height: MediaQuery.of(context).size.height * .85,
                child: Form(
                  key: controller.trainFormKey,
                  child: SingleChildScrollView(
                    child: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: Column(
                              children: [
                                // controller.checkTrainStation.value?
                                // Focus(
                                //   focusNode:
                                //   controller.node,
                                //
                                //   child: Listener(
                                //     onPointerDown:
                                //         (_) {
                                //       FocusScope.of(
                                //           context)
                                //           .requestFocus(
                                //           controller.node);
                                //     },
                                //     child: DropdownBelow(
                                //       itemWidth:
                                //           MediaQuery.of(context).size.width * .75,
                                //       itemTextstyle: const TextStyle(
                                //           fontSize: 14,
                                //           fontFamily: 'PoppinsRegular',
                                //           color: MyColors.black),
                                //       boxTextstyle: controller.selectedStation.value.stationName == null? const TextStyle(
                                //           fontSize: 14,
                                //           fontFamily: 'PoppinsRegular',
                                //           color: MyColors.gray):const TextStyle(
                                //           fontSize: 14,
                                //           fontFamily: 'PoppinsRegular',
                                //           color: MyColors.black),
                                //       boxPadding:
                                //           const EdgeInsets.fromLTRB(13, 10, 13, 12),
                                //       boxWidth: MediaQuery.of(context).size.width * .75,
                                //       boxHeight: 48,
                                //       boxDecoration: BoxDecoration(
                                //           color: Colors.transparent,
                                //           borderRadius: const BorderRadius.all(
                                //               Radius.circular(8.0)),
                                //           border: Border.all(
                                //               width: 1, color: MyColors.borderColor)),
                                //       icon: const Icon(
                                //         Icons.arrow_drop_down,
                                //         color: MyColors.borderColor,
                                //       ),
                                //       hint: const Text(MyString.stationName),
                                //       value: controller.selectedStation.value.stationName == null?null:controller.selectedStation.value,
                                //       items: controller.dropdownStationItems,
                                //       onChanged: controller.onChangeDropdownStation,
                                //     ),
                                //   ),
                                // ):Container(),
                                controller.checkTrainStation.value
                                    ? TextDropdownFormField(
                                        onChanged: (dynamic str) {
                                          controller
                                              .onChangeDropDown(str.toString());
                                          // _playerchosenValue =
                                          //     str.toString();
                                        },
                                        options: controller.stationName,
                                        //labelText: MyString.stationName,
                                        controller: controller
                                            .dropdownEditingController,
                                        dropdownHeight: 220,
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomizeTextFormField(
                                  labelText: MyString.standardTime,
                                  helperText: MyString.standardTime,
                                  onClick: () {},
                                  onChange: (value) {},
                                  onSave: (value) {},
                                  controller: controller.standardTimeController,
                                  validator: ValidateInput.validateField,
                                  isEnabled: false,
                                  //validator: ValidateInput.validateEmail,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomizeTextFormField(
                                  labelText: MyString.reachingTime,
                                  helperText: MyString.reachingTime,
                                  onClick: () {
                                    controller.showTimePickerDialog(context);
                                  },
                                  onChange: (value) {},
                                  onSave: (value) {},
                                  inputFormatter: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp("[0-9:]")),
                                    LengthLimitingTextInputFormatter(5),
                                    // DateFormatter()
                                  ],
                                  keyboardType:TextInputType.text ,
                                  controller: controller.reachingTimeController,
                                  validator: ValidateInput.validateReachingTime,
                                  //validator: ValidateInput.validateEmail,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomizeTextFormField(
                                  labelText: MyString.standardDepartureTime,
                                  helperText: MyString.standardDepartureTime,
                                  onClick: () {},
                                  onChange: (value) {},
                                  onSave: (value) {},
                                  controller: controller
                                      .standardDepartureTimeController,
                                  validator: ValidateInput.validateField,
                                  isEnabled: false,
                                  //validator: ValidateInput.validateEmail,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomizeTextFormField(
                                  labelText: MyString.departureTime,
                                  helperText: MyString.departureTime,
                                  onClick: () {
                                    controller
                                        .showDepartureTimePickerDialog(context);
                                  },
                                  onChange: (value) {

                                  },
                                  onSave: (value) {},
                                  inputFormatter: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp("[0-9:]")),
                                    LengthLimitingTextInputFormatter(5),
                                    // DateFormatter()
                                  ],
                                  keyboardType:TextInputType.text ,
                                  controller:
                                      controller.departureTimeController,
                                  validator:
                                      ValidateInput.validateDepartureTime,

                                  //validator: ValidateInput.validateEmail,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                CustomizeTextFormField(
                                  labelText: "",
                                  helperText: "",
                                  onClick: () {},
                                  onChange: (value) {},
                                  onSave: (value) {},
                                  isEnabled: false,
                                  controller: controller.statusController,
                                  validator: ValidateInput.validateField,
                                  //validator: ValidateInput.validateEmail,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomizeTextFormField(
                                  labelText:
                                      controller.statusController.text == "On Time"
                                          ? ""
                                          : controller.statusController.text ==
                                                  MyString.delayed
                                              ? MyString.reasonForDelay
                                              : MyString.reasonForEarly,
                                  helperText:
                                      controller.statusController.text == "On Time"
                                          ? ""
                                          : controller.statusController.text ==
                                                  MyString.delayed
                                              ? MyString.reasonForDelay
                                              : MyString.reasonForEarly,
                                  onClick: () {},
                                  onChange: (value) {},
                                  onSave: (value) {},
                                  minLines: 5,
                                  maxLines: 8,
                                  keyboardType: TextInputType.multiline,
                                  inputAction: TextInputAction.newline,
                                  controller: controller.reasonController,
                                  validator:
                                      controller.statusController.text == "On Time"
                                          ? ValidateInput.validateField
                                          : ValidateInput.validateReason,
                                  //validator: ValidateInput.validateEmail,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(
                                          color: MyColors.white,
                                          fontWeight: FontWeight.bold),
                                      primary: MyColors.kSecondaryColor,
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width *
                                              .60,
                                          40)),
                                  onPressed: () {
                                    //Get.to(() =>   OTPScreen());
                                    //Get.to(() =>   const NotificationSelectionScreen());
                                    ProgressBar.instance
                                        .showProgressbar(context);
                                    controller.addTrainTrackInfo(context);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(MyString.submit),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 2) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      //cText += ':';

      if ( dd > 23) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += ':';
      }
    }else if (pLen == 3) {
      int dd = int.parse(cText.substring(0, 2));
      //cText += ':';

      if ( dd > 23) {
        // Remove char
        cText = cText.substring(0, 2);
      } else {
        // Add a / char
        cText += ':';
      }
      // Days cannot be greater than 31
      // int dd = int.parse(cText.substring(0, 2));
      // cText += ':';

      // if ( dd > 23) {
      //   // Remove char
      //   cText = cText.substring(0, 1);
      // } else {
      //   // Add a / char
      //   cText += ':';
      // }
    }/* else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += ':';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + ':';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + ':' + cText.substring(pLen, pLen + 1);
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = cText.substring(0, 5) + ':';
      } else {
        // Insert / char
        cText = cText.substring(0, 5) + ':' + cText.substring(5, 6);
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }*/

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
