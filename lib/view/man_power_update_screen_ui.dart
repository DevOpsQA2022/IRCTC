import 'package:dropdown_below/dropdown_below.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:irctc/controller/man_power_update_controller.dart';
import 'package:irctc/controller/sign_in_controller.dart';
import 'package:irctc/support/colors.dart';
import 'package:irctc/support/constants.dart';
import 'package:irctc/support/images.dart';
import 'package:irctc/support/string.dart';
import 'package:irctc/support/validate_input.dart';
import 'package:irctc/view/sign_in_screen_ui.dart';
import 'package:irctc/widgets/customize_text_field.dart';
import 'package:irctc/widgets/progressbar.dart';

import 'history_screen_ui.dart';
import 'live_status_update_screen_ui.dart';


class ManPowerUpdateScreen extends StatelessWidget {
  String name;
  ManPowerUpdateScreen(this.name, {Key? key}) : super(key: key);

  final ManPowerUpdateController controller = Get.put(ManPowerUpdateController());

  @override
  Widget build(BuildContext context) {
    controller.guardNameController.text=name;

    // if(Get.isRegistered<SignInController>()){
    //   controller.guardNameController.text=controller.guardNameController.text.isEmpty?Get.find<SignInController>().usernameController.text:controller.guardNameController.text;
    // }else{
    //   Get.put(SignInController());
    //   controller.guardNameController.text=controller.guardNameController.text.isEmpty?Get.find<SignInController>().usernameController.text:controller.guardNameController.text;
    // }
    // controller.getLoc();

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
                    child: Text(controller.userName.value == "null"?Get.find<SignInController>().usernameController.text:controller.userName.value),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () {
                      if(Constants.isFromHomeScreen){
                        Get.back();
                      }else{
                        controller.onAlertWithCustomContent(context);
                      }
                    },
                    leading: const Icon(Icons.arrow_back),
                    title: const Text(MyString.trainLiveStatus),
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
          appBar: AppBar(

            actions: [
              IconButton(
                  onPressed: () {
                    controller.advancedDrawerController.showDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: MyColors.kSecondaryColor,
                  ))
            ],
            leadingWidth: 30,

            elevation: 0,
          ),
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: SafeArea(
                    child: Image.asset(MyImages.irctcLogo, width: 70),
                  ),
                ),
              ),

              Center(
                child: Card(
                  elevation: 50,
                  shadowColor: MyColors.black,
                  color: MyColors.white,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .85,
                    height: MediaQuery.of(context).size.height * .70,
                    child: Form(
                      key: controller.manpowerFormKey,
                      child: SingleChildScrollView(
                        child:  Obx(
                              () =>  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: Container(
                                  height: 60,
                                  color: MyColors.kSecondaryColor,
                                  child: const Center(
                                    child: Text(
                                      MyString.trainInfo,
                                      style: TextStyle(
                                          color: MyColors.kPrimaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  children: [
                                    CustomizeTextFormField(labelText:MyString.guardName,
                                      helperText: MyString.guardName,
                                      onClick: (){},
                                      onChange: (value){},
                                      onSave: (value){},
                                      isEnabled: false,
                                      controller: controller.guardNameController,
                                      validator: ValidateInput.validateGuardName,
                                      //validator: ValidateInput.validateEmail,
                                    ),
                                    const SizedBox(height: 20,),
                                    // controller.checkTrainNumber.value?
                                    //
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
                                    //
                                    //         itemWidth:
                                    //         MediaQuery.of(context).size.width * .75,
                                    //         itemTextstyle: const TextStyle(
                                    //             fontSize: 14,
                                    //             fontFamily: 'PoppinsRegular',
                                    //             color: MyColors.black),
                                    //         boxTextstyle:controller.selectedTrain.value.trainId == null? const TextStyle(
                                    //             fontSize: 14,
                                    //             fontFamily: 'PoppinsRegular',
                                    //             color: MyColors.gray):const TextStyle(
                                    //             fontSize: 14,
                                    //             fontFamily: 'PoppinsRegular',
                                    //             color: MyColors.black),
                                    //         boxPadding:
                                    //         const EdgeInsets.fromLTRB(13, 10, 13, 12),
                                    //         boxWidth:
                                    //         MediaQuery.of(context).size.width * .75,
                                    //         boxHeight: 48,
                                    //         boxDecoration: BoxDecoration(
                                    //             color: Colors.transparent,
                                    //             borderRadius: const BorderRadius.all(
                                    //                 Radius.circular(8.0)),
                                    //             border: Border.all(
                                    //                 width: 1, color: MyColors.borderColor)),
                                    //         icon: const Icon(
                                    //           Icons.arrow_drop_down,
                                    //           color: MyColors.borderColor,
                                    //         ),
                                    //         hint: const Text(MyString.trainNumber),
                                    //         value: controller.selectedTrain.value.trainId == null?null:controller.selectedTrain.value,
                                    //         items: controller.dropdownTrainItems,
                                    //         onChanged: controller.onChangeDropdownTrain,
                                    //     ),
                                    //   ),
                                    // ):Container(),
                                    controller.checkTrainNumber.value?
                                    TextDropdownFormField(
                                      onChanged:
                                          (dynamic str) {
                                        controller.onChangeDropDown(str.toString());
                                        // _playerchosenValue =
                                        //     str.toString();
                                      },
                                      options:controller.trainName,
                                      //labelText:MyString.trainNumber,
                                      controller: controller.dropdownEditingController,
                                      dropdownHeight: 220,

                                    ):Container(),
                                    const SizedBox(
                                      height: 20,
                                    ),


                                    CustomizeTextFormField(labelText:MyString.driverName,
                                      helperText: MyString.driverName,
                                      onClick: (){},
                                      onChange: (value){},
                                      onSave: (value){},
                                      controller: controller.driverNameController,
                                      validator: ValidateInput.validateDriverName,

                                      //validator: ValidateInput.validateEmail,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomizeTextFormField(
                                      labelText: MyString.assistanceName,
                                      helperText: MyString.assistanceName,
                                      onClick: () {},
                                      onChange: (value) {},
                                      onSave: (value) {},
                                      inputAction: TextInputAction.done,
                                      isLast: true,
                                      controller: controller.assistanceNameController,
                                      validator: ValidateInput.validateAssistanceName,
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
                                              MediaQuery.of(context).size.width * .60,
                                              40)),
                                      onPressed: () {
                                        ProgressBar.instance.showProgressbar(context);
                                        controller.updateTrainDetails(context);
                                        // Get.to(() =>   LiveStatusUpdateScreen());

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
            ],
          ),
        ),
      ),
    );
  }
}
