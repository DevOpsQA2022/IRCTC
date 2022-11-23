import 'dart:math';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
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
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'history_screen_ui.dart';
import 'live_status_update_screen_ui.dart';

class PDFScreen extends StatelessWidget {
  PDFScreen( {Key? key}) : super(key: key);
  final ManPowerUpdateController controller = Get.put(ManPowerUpdateController());




  @override
  Widget build(BuildContext context) {
    TreeViewTheme _treeViewTheme = TreeViewTheme(
      expanderTheme: ExpanderThemeData(
          type: controller.expanderType,
          modifier: controller.expanderModifier,
          position: controller.expanderPosition,
          // color: Colors.grey.shade800,
          size: 20,
          color: Colors.blue),
      labelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      parentLabelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        color: Colors.blue.shade700,
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: Colors.grey.shade800,
      ),
      colorScheme: Theme.of(context).colorScheme,
    );
    Size size = MediaQuery
        .of(context)
        .size;

    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 60;
    var _aspectRatio = _width / cellHeight;




    return Scaffold(
      key: controller.scaffoldState,
      backgroundColor: MyColors.kPrimaryColor,
      drawer: Container(
        // width: 450,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
               DrawerHeader(
                decoration: const BoxDecoration(
                  color: MyColors.kSecondaryColor,
                ),
                // child: Text('Admin'),
                 child: Image.asset(MyImages.irctcLogo, width: 70),
              ),
        // Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: CustomizeTextFormField(
        //       labelText: "Search",
        //       helperText:"",
        //       onClick: () {},
        //       onChange: (value) {},
        //       onSave: (value) {},
        //       controller:TextEditingController(),
        //       validator:
        //       ValidateInput.validateField,
        //
        //       isEnabled: false,
        //       showSufix: true,
        //       //validator: ValidateInput.validateEmail,
        //     ),
        //   ),
        //       const SizedBox(
        //         height: 10,
        //       ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Obx(
                      () => Container(
                    padding: EdgeInsets.all(20),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * .80,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10),
                            child: TreeView(
                              controller: controller.treeViewController.value,
                              allowParentSelect: controller.allowParentSelect,
                              supportParentDoubleTap: controller.supportParentDoubleTap,
                              onExpansionChanged: (key, expanded) =>
                                  controller.expandNode(key, expanded),
                              onNodeTap: (key) {
                                debugPrint('Selected: $key');
                                controller.selectedPdf.value=key;
                                controller.selectedNode = key;
                                controller.treeViewController.value =
                                    controller.treeViewController.value.copyWith(selectedKey: key);
                                controller.scaffoldState.currentState?.closeDrawer();
                                controller.notifyChildrens();
                                controller.refresh();
                              },
                              theme: _treeViewTheme,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(

        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         controller.advancedDrawerController.showDrawer();
        //       },
        //       icon: const Icon(
        //         Icons.menu,
        //         color: MyColors.kSecondaryColor,
        //       ))
        // ],
        leadingWidth: 30,

        elevation: 0,

      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       const DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.blue,
      //         ),
      //         child: Text('Drawer Header'),
      //       ),
      //       ListView.builder(
      //         itemCount: 10,
      //         shrinkWrap: true,
      //         itemBuilder: (context, index) {
      //           return ListTile(
      //             title: Text('Item ' + index.toString()),
      //             onTap: () {
      //               // Navigator.push(
      //               //   context,
      //               //   MaterialPageRoute(
      //               //       builder: (context) => const ThirdRoute()),
      //               // );
      //             },
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),

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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child:IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // controller.pdfViewerController.dispose();
                    controller.scaffoldState.currentState?.openDrawer();
                    // _scaffoldState.currentState!.openEndDrawer();
                  },
                ),
              ),
            ),
          ),
          Center(
            child: Card(
              elevation: 50,
              shadowColor: MyColors.black,
              color: MyColors.white,
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * .85,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .70,
                child: Column(
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
                    Center(
                      child: Card(
                        elevation: 50,
                        shadowColor: MyColors.black,
                        color: MyColors.white,
                        child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width *
                              .85,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height *
                              .68,
                          child: Form(
                            child:  Obx(
                                  () =>  Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: MediaQuery
                                          .of(
                                          context)
                                          .size
                                          .height *
                                          .68,
                                      // child: SfPdfViewer.network(
                                      //     'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf')
                                    child: controller.selectedPdf.value.isNotEmpty? pdf():SfPdfViewer.asset(MyPDF.pdf0) ,
                                  ),
                                ],
                              ),
                            ),
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

        ],

      ),

    );

  }

  pdf() {
    try {
      return SfPdfViewer.asset(controller.pdfList[Random().nextInt((controller.pdfList.length-1))],);
    } catch (e) {
      print(e);
    }
  }
  }