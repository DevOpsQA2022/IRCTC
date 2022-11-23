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
import 'package:irctc/view/pdf_screen_ui.dart';
import 'package:irctc/view/sign_in_screen_ui.dart';
import 'package:irctc/widgets/customize_text_field.dart';
import 'package:irctc/widgets/progressbar.dart';

import 'history_screen_ui.dart';
import 'live_status_update_screen_ui.dart';


class MainMenuScreen extends StatelessWidget {
  MainMenuScreen( {Key? key}) : super(key: key);

  final ManPowerUpdateController controller = Get.put(ManPowerUpdateController());

  @override
  Widget build(BuildContext context) {

   Size size = MediaQuery.of(context).size;

   var _crossAxisSpacing = 8;
   var _screenWidth = MediaQuery.of(context).size.width;
   var _crossAxisCount = 2;
   var _width = ( _screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
   var cellHeight = 60;
   var _aspectRatio = _width /cellHeight;
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
                  // ListTile(
                  //   onTap: () {
                  //     if(Constants.isFromHomeScreen){
                  //       Get.back();
                  //     }else{
                  //       controller.onAlertWithCustomContent(context);
                  //     }
                  //   },
                  //   leading: const Icon(Icons.arrow_back),
                  //   title: const Text(MyString.trainLiveStatus),
                  // ),
                  // ListTile(
                  //   onTap: () {
                  //     controller.advancedDrawerController.toggleDrawer();
                  //     controller.getTrainTrackData();
                  //     Get.to(() => HistoryScreen());
                  //
                  //   },
                  //   leading: const Icon(Icons.history),
                  //   title: const Text(MyString.viewLog),
                  // ),

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
          // body: Stack(
          //   children: <Widget>[
          //     Container(
          //       child: CustomPaint(
          //         painter: ShapesPainter(),
          //         child: Container(
          //           height: size.height / 2,
          //         ),
          //       ),
          //     ),
          //     Container(
          //       margin: EdgeInsets.only(top: 40),
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 20, right: 20),
          //         child: GridView.count(
          //           crossAxisCount: 2,
          //           children: <Widget>[
          //             createGridItem(0),
          //             createGridItem(1),
          //
          //           ],
          //         ),
          //       ),
          //     )
          //   ],
          // ),
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
                        child:   Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Card(
                              //   child: Container(
                              //     height: 60,
                              //     color: MyColors.kSecondaryColor,
                              //     child: const Center(
                              //       child: Text(
                              //         MyString.trainInfo,
                              //         style: TextStyle(
                              //             color: MyColors.kPrimaryColor,
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.bold),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(10.0),
                              //   child: CustomizeTextFormField(
                              //     labelText: "Search",
                              //     helperText:"",
                              //     onClick: () {},
                              //     onChange: (value) {},
                              //     onSave: (value) {},
                              //     controller:TextEditingController(),
                              //     validator:
                              //     ValidateInput.validateField,
                              //
                              //     isEnabled: false,
                              //     showSufix: true,
                              //     //validator: ValidateInput.validateEmail,
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 40,
                              // ),
                              // Container(
                              //   margin: const EdgeInsets.symmetric(
                              //       vertical: 20, horizontal: 20),
                              //   child: GridView.builder(
                              //     physics: NeverScrollableScrollPhysics(),
                              //     shrinkWrap: true,
                              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              //       crossAxisCount: 2,
                              //         childAspectRatio: _aspectRatio
                              //     ),
                              //     itemCount: 30,
                              //     itemBuilder: (context, index) {
                              //       return Row(
                              //         children: [
                              //           Icon(Icons.picture_as_pdf_rounded,color: Colors.red,),
                              //           Container(
                              //             child: Text("Chapter: "+(index+1).toString()),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   ),
                                      Container(
                                      margin: EdgeInsets.only(top: 40),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20, right: 20),
                                        child: SizedBox(
                                          // height: size.height/3,
                                          height: 300,
                                          child: GridView.count(
                                            crossAxisCount: 2,
                                            children: <Widget>[
                                              createGridItem(0),
                                              createGridItem(1),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                // child: Column(
                                //   children: [
                                //     CustomizeTextFormField(labelText:MyString.guardName,
                                //       helperText: MyString.guardName,
                                //       onClick: (){},
                                //       onChange: (value){},
                                //       onSave: (value){},
                                //       isEnabled: false,
                                //       controller: controller.guardNameController,
                                //       validator: ValidateInput.validateGuardName,
                                //       //validator: ValidateInput.validateEmail,
                                //     ),
                                //     const SizedBox(height: 20,),
                                //     // controller.checkTrainNumber.value?
                                //     //
                                //     // Focus(
                                //     //   focusNode:
                                //     //   controller.node,
                                //     //
                                //     //   child: Listener(
                                //     //     onPointerDown:
                                //     //         (_) {
                                //     //       FocusScope.of(
                                //     //           context)
                                //     //           .requestFocus(
                                //     //           controller.node);
                                //     //     },
                                //     //     child: DropdownBelow(
                                //     //
                                //     //         itemWidth:
                                //     //         MediaQuery.of(context).size.width * .75,
                                //     //         itemTextstyle: const TextStyle(
                                //     //             fontSize: 14,
                                //     //             fontFamily: 'PoppinsRegular',
                                //     //             color: MyColors.black),
                                //     //         boxTextstyle:controller.selectedTrain.value.trainId == null? const TextStyle(
                                //     //             fontSize: 14,
                                //     //             fontFamily: 'PoppinsRegular',
                                //     //             color: MyColors.gray):const TextStyle(
                                //     //             fontSize: 14,
                                //     //             fontFamily: 'PoppinsRegular',
                                //     //             color: MyColors.black),
                                //     //         boxPadding:
                                //     //         const EdgeInsets.fromLTRB(13, 10, 13, 12),
                                //     //         boxWidth:
                                //     //         MediaQuery.of(context).size.width * .75,
                                //     //         boxHeight: 48,
                                //     //         boxDecoration: BoxDecoration(
                                //     //             color: Colors.transparent,
                                //     //             borderRadius: const BorderRadius.all(
                                //     //                 Radius.circular(8.0)),
                                //     //             border: Border.all(
                                //     //                 width: 1, color: MyColors.borderColor)),
                                //     //         icon: const Icon(
                                //     //           Icons.arrow_drop_down,
                                //     //           color: MyColors.borderColor,
                                //     //         ),
                                //     //         hint: const Text(MyString.trainNumber),
                                //     //         value: controller.selectedTrain.value.trainId == null?null:controller.selectedTrain.value,
                                //     //         items: controller.dropdownTrainItems,
                                //     //         onChanged: controller.onChangeDropdownTrain,
                                //     //     ),
                                //     //   ),
                                //     // ):Container(),
                                //     controller.checkTrainNumber.value?
                                //     TextDropdownFormField(
                                //       onChanged:
                                //           (dynamic str) {
                                //         controller.onChangeDropDown(str.toString());
                                //         // _playerchosenValue =
                                //         //     str.toString();
                                //       },
                                //       options:controller.trainName,
                                //       labelText:
                                //       MyString.trainNumber,
                                //       controller: controller.dropdownEditingController,
                                //       dropdownHeight: 220,
                                //
                                //     ):Container(),
                                //     const SizedBox(
                                //       height: 20,
                                //     ),
                                //
                                //
                                //     CustomizeTextFormField(labelText:MyString.driverName,
                                //       helperText: MyString.driverName,
                                //       onClick: (){},
                                //       onChange: (value){},
                                //       onSave: (value){},
                                //       controller: controller.driverNameController,
                                //       validator: ValidateInput.validateDriverName,
                                //
                                //       //validator: ValidateInput.validateEmail,
                                //     ),
                                //     const SizedBox(
                                //       height: 20,
                                //     ),
                                //     CustomizeTextFormField(
                                //       labelText: MyString.assistanceName,
                                //       helperText: MyString.assistanceName,
                                //       onClick: () {},
                                //       onChange: (value) {},
                                //       onSave: (value) {},
                                //       inputAction: TextInputAction.done,
                                //       isLast: true,
                                //       controller: controller.assistanceNameController,
                                //       validator: ValidateInput.validateAssistanceName,
                                //       //validator: ValidateInput.validateEmail,
                                //     ),
                                //     const SizedBox(
                                //       height: 20,
                                //     ),
                                //
                                //
                                //     ElevatedButton(
                                //       style: ElevatedButton.styleFrom(
                                //           textStyle: const TextStyle(
                                //               color: MyColors.white,
                                //               fontWeight: FontWeight.bold),
                                //           primary: MyColors.kSecondaryColor,
                                //           minimumSize: Size(
                                //               MediaQuery.of(context).size.width * .60,
                                //               40)),
                                //       onPressed: () {
                                //         ProgressBar.instance.showProgressbar(context);
                                //         controller.updateTrainDetails(context);
                                //         // Get.to(() =>   LiveStatusUpdateScreen());
                                //
                                //       },
                                //       child: const Padding(
                                //         padding: EdgeInsets.all(4.0),
                                //         child: Text(MyString.submit),
                                //       ),
                                //     ),
                                //     const SizedBox(
                                //       height: 10,
                                //     ),
                                //
                                //   ],
                                // ),

                            ],
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

  Widget createGridItem(int position) {
    Color? color = Colors.white;
    var icondata = Icons.add;
    String? name;

    switch (position) {
      case 0:
        color = Colors.cyan;
        icondata = Icons.picture_as_pdf;
        name="Digital Essentials";
        break;
      case 1:
        color = Colors.deepPurple;

        icondata = Icons.menu_book;
        name="Digital Electronic Diary";
        break;

    }

    return Builder(builder: (context) {
      return Padding(
        padding:
        const EdgeInsets.only(left: 10.0, right: 10, bottom: 5, top: 5),
        child: Card(
          elevation: 10,
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(color: Colors.white),
          ),
          child: InkWell(
            onTap: () {
              if(position==0) {
                controller.selectedPdf.value='';
                Get.to(() => PDFScreen());
              }

            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    icondata,
                    size: 40,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name!,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
      ;
    });
  }
}
class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the paint color to be white
    paint.color = Colors.white;
    // Create a rectangle with size and width same as the canvas
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // draw the rectangle using the paint
    canvas.drawRect(rect, paint);
    paint.color = Colors.greenAccent[400]!;
    // create a path
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    // close the path to form a bounded shape
    path.close();
    canvas.drawPath(path, paint);
    /* // set the color property of the paint
    paint.color = Colors.deepOrange;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);
    // draw the circle with center having radius 75.0
    canvas.drawCircle(center, 75.0, paint);*/
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}