import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_treeview/flutter_treeview.dart' as tree;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:irctc/model/signin_response.dart';
import 'package:irctc/model/train_info_request.dart';
import 'package:irctc/model/train_response.dart' as t;
import 'package:irctc/model/train_track_response.dart';
import 'package:irctc/model/user_request.dart';
import 'package:irctc/service/api_manager.dart';
import 'package:irctc/service/endpoints.dart';
import 'package:irctc/service/shared_pref_manager.dart';
import 'package:irctc/support/colors.dart';
import 'package:irctc/support/constants.dart';
import 'package:irctc/support/string.dart';
import 'package:irctc/view/live_status_update_screen_ui.dart';
import 'package:irctc/view/sign_in_screen_ui.dart';
import 'package:irctc/widgets/progressbar.dart';
import 'package:location/location.dart' as l;
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../support/images.dart';

class ManPowerUpdateController extends GetxController {
  var type = "user".obs;
  var countryCode = "IN".obs;
  var checkTerms = false.obs;
  var checkTrainNumber = false.obs;
  var regionResponse = t.TrainResponse().obs;
  final manpowerFormKey = GlobalKey<FormState>();
  TextEditingController guardNameController = TextEditingController();
  TextEditingController driverNameController = TextEditingController();
  TextEditingController assistanceNameController = TextEditingController();
  l.Location location = new l.Location();
  final advancedDrawerController = AdvancedDrawerController();
  var userName = "".obs;
  var trainTrackResponse = TrainTrackResponse().obs;
  DropdownEditingController<String> dropdownEditingController=DropdownEditingController();

  l.LocationData? _currentPosition;
  List<String> trainName = [];
  String? _address,
      _dateTime,
      _countryCode,
      _countryName,
      _lat,
      _lon,
      selectedTrainNo,
      startTime,
      trainId;
  List<DropdownMenuItem<Object?>> dropdownTrainItems = [];
  final List testList = [
    {'no': 1, 'keyword': 'No Data'},
    /*{'no': 2, 'keyword': 'black'},
      {'no': 3, 'keyword': 'red'}*/
  ];

  // List<DropdownMenuItem<Object?>> dropdownTestItems = [];
  var selectedTrain = TrainList().obs;
  final FocusNode node = FocusNode();

  var docsOpen = false.obs;


  tree.ExpanderPosition expanderPosition = tree.ExpanderPosition.start;
  tree.ExpanderType expanderType = tree.ExpanderType.chevron;
  tree.ExpanderModifier expanderModifier = tree.ExpanderModifier.none;
  bool allowParentSelect = false;
  bool supportParentDoubleTap = false;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  String? selectedNode;
  var selectedPdf=''.obs;
  List<tree.Node>? nodes;
  var treeViewController = tree.TreeViewController().obs;
  List pdfList = [MyPDF.pdf1, MyPDF.pdf2,MyPDF.pdf3,MyPDF.pdf4,MyPDF.pdf5];
  PdfViewerController pdfViewerController = PdfViewerController();

  @override
  void onInit() {
    super.onInit();

    nodes = [
      tree.Node(
        label: 'General Rules',
        key: 'General Rules',
        expanded: docsOpen.value,
        icon: docsOpen.value ? Icons.folder_open : Icons.folder,
        children: [
          for (int i = 1; i <= 18; i++)
            tree.Node(
              label: 'Chapter $i.pdf',
              key: 'General Rules Chapter $i',
              icon: Icons.picture_as_pdf_rounded,
              iconColor: Colors.red,
            ),
        ],
      ),
      tree.Node(
        label: 'Accident Manual',
        key: 'Accident Manual',
        expanded: docsOpen.value,
        icon: docsOpen.value ? Icons.folder_open : Icons.folder,
        children: [
          for (int i = 1; i <= 10; i++)
            tree.Node(
              label: 'Chapter $i.pdf',
              key: 'Accident Manual Chapter $i',
              icon: Icons.picture_as_pdf_rounded,
              iconColor: Colors.red,
            ),
        ],
      ),
      tree.Node(
        label: 'Block working Manual',
        key: 'Block working Manual',
        expanded: docsOpen.value,
        icon: docsOpen.value ? Icons.folder_open : Icons.folder,
        children: [
          for (int i = 1; i <= 2; i++)
            tree.Node(
              label: 'Part $i.pdf',
              key: 'Block working Part $i',
              icon: Icons.picture_as_pdf_rounded,
              iconColor: Colors.red,
            ),
        ],
      ),
      tree.Node(
        label: 'Operating Manual',
        key: 'Operating Manual',
        expanded: docsOpen.value,
        icon: docsOpen.value ? Icons.folder_open : Icons.folder,
        children: [
          for (int i = 1; i <= 27; i++)
            tree.Node(
              label: 'Chapter $i.pdf',
              key: 'Operating Manual Chapter $i',
              icon: Icons.picture_as_pdf_rounded,
              iconColor: Colors.red,
            ),
        ],
      ),
      tree.Node(
        label: 'BPC Manual',
        key: 'BPC Manual',
        expanded: docsOpen.value,
        icon: docsOpen.value ? Icons.folder_open : Icons.folder,
        children: [
          for (int i = 1; i <= 10; i++)
            tree.Node(
              label: 'Chapter $i.pdf',
              key: 'BPC Manual Chapter $i',
              icon: Icons.picture_as_pdf_rounded,
              iconColor: Colors.red,
            ),
        ],
      ),
      tree.Node(
        label: 'Working Time Table',
        key: 'Working Time Table',
        expanded: docsOpen.value,
        icon: docsOpen.value ? Icons.folder_open : Icons.folder,
        children: [
          tree.Node(
            label: 'Chennai Division',
            key: 'Chennai Division',
            expanded: docsOpen.value,
            icon: docsOpen.value ? Icons.folder_open : Icons.folder,
            children: [
              for (int i = 1; i <= 10; i++)
                tree.Node(
                  label: 'Section $i.pdf',
                  key: 'Chennai Division Section $i',
                  icon: Icons.picture_as_pdf_rounded,
                  iconColor: Colors.red,
                ),
            ],
          ),
          tree.Node(
            label: 'Madurai division',
            key: 'Madurai division',
            expanded: docsOpen.value,
            icon: docsOpen.value ? Icons.folder_open : Icons.folder,
            children: [
              for (int i = 1; i <= 9; i++)
                tree.Node(
                  label: 'Section $i.pdf',
                  key: 'Madurai division Section $i',
                  icon: Icons.picture_as_pdf_rounded,
                  iconColor: Colors.red,
                ),
            ],
          ),
          tree.Node(
            label: 'Palghat Division',
            key: 'Palghat Division',
            expanded: docsOpen.value,
            icon: docsOpen.value ? Icons.folder_open : Icons.folder,
            children: [
              for (int i = 1; i <= 5; i++)
                tree.Node(
                  label: 'Section $i.pdf',
                  key: 'Palghat Division Section $i',
                  icon: Icons.picture_as_pdf_rounded,
                  iconColor: Colors.red,
                ),
            ],
          ),
          tree.Node(
            label: 'Salem Division',
            key: 'Salem Division',
            expanded: docsOpen.value,
            icon: docsOpen.value ? Icons.folder_open : Icons.folder,
            children: [
              for (int i = 1; i <= 10; i++)
                tree.Node(
                  label: 'Section $i.pdf',
                  key: 'Salem Division Section $i',
                  icon: Icons.picture_as_pdf_rounded,
                  iconColor: Colors.red,
                ),
            ],
          ),
          tree.Node(
            label: 'Tiruchichirappalli Division',
            key: 'Tiruchichirappalli Division',
            expanded: docsOpen.value,
            icon: docsOpen.value ? Icons.folder_open : Icons.folder,
            children: [
              for (int i = 1; i <= 10; i++)
                tree.Node(
                  label: 'Section $i.pdf',
                  key: 'Tiruchichirappalli Section $i',
                  icon: Icons.picture_as_pdf_rounded,
                  iconColor: Colors.red,
                ),
            ],
          ),
          tree.Node(
            label: 'Trivandrum Division',
            key: 'Trivandrum Division',
            expanded: docsOpen.value,
            icon: docsOpen.value ? Icons.folder_open : Icons.folder,
            children: [
              for (int i = 1; i <= 8; i++)
                tree.Node(
                  label: 'Section $i.pdf',
                  key: 'Trivandrum Section $i',
                  icon: Icons.picture_as_pdf_rounded,
                  iconColor: Colors.red,
                ),
            ],
          ),
        ],
      ),
      tree.Node(
        label: 'Troubling Shooting Guide',
        key: 'Troubling Shooting Guide',
        expanded: docsOpen.value,
        icon: docsOpen.value ? Icons.folder_open : Icons.folder,
        children: [
          tree.Node(
            label: 'Wagon',
            key: 'Wagon',
            icon: Icons.picture_as_pdf_rounded,
            iconColor: Colors.red,
          ),
          tree.Node(
            label: 'Locos',
            key: 'Locos',
            icon: Icons.picture_as_pdf_rounded,
            iconColor: Colors.red,
          ),
        ],
      ),
      tree.Node(
        label: 'Divisional Circulars',
        key: 'Divisional Circulars',
        expanded: docsOpen.value,
        icon: docsOpen.value ? Icons.folder_open : Icons.folder,
        children: [
          tree.Node(
            label: 'MAS',
            key: 'MAS',
            icon: Icons.picture_as_pdf_rounded,
            iconColor: Colors.red,
          ),
          tree.Node(
            label: 'MDU',
            key: 'MDU',
            icon: Icons.picture_as_pdf_rounded,
            iconColor: Colors.red,
          ),
          tree.Node(
            label: 'PGT',
            key: 'PGT',
            icon: Icons.picture_as_pdf_rounded,
            iconColor: Colors.red,
          ),
          tree.Node(
            label: 'SA',
            key: 'SA',
            icon: Icons.picture_as_pdf_rounded,
            iconColor: Colors.red,
          ),
          tree.Node(
            label: 'TPJ',
            key: 'TPJ',
            icon: Icons.picture_as_pdf_rounded,
            iconColor: Colors.red,
          ),
          tree.Node(
            label: 'TVC',
            key: 'TVC',
            icon: Icons.picture_as_pdf_rounded,
            iconColor: Colors.red,
          ),
        ],
      ),
      tree.Node(
        label: 'Other Manuals1',
        key: 'Other Manuals1',
        icon: Icons.picture_as_pdf_rounded,
        iconColor: Colors.red,
      ),
      tree.Node(
        label: 'Other Manuals 2',
        key: 'Other Manuals 2',
        icon: Icons.picture_as_pdf_rounded,
        iconColor: Colors.red,
      ),
    ];
    treeViewController.value = tree.TreeViewController(
      children: nodes!,
      selectedKey: selectedNode,
    );
    // guardNameController = TextEditingController();
    // driverNameController = TextEditingController();
    // assistanceNameController = TextEditingController();
    // dropdownTrainItems = buildDropdownTestItems(testList);
    // scaffoldState.currentState?.openDrawer();
    // Future.delayed(Duration(seconds: 5), () {
    //   scaffoldState.currentState?.openDrawer();
    // });
    getLoc();
    // getTrain();
    // Timer.run(() => scaffoldState.currentState?.openDrawer());
  }

  List<DropdownMenuItem<Object?>> buildDropdownTestItems(
      List<t.TrainList> regionList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in regionList) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i.trainNo!),
        ),
      );
    }
    checkTrainNumber.value = true;
    return items;
  }

  onChangeDropdownTrain(selectedTrain) {
    print(selectedTrain);
    this.selectedTrain.value = selectedTrain;
    // this.selectedTest = selectedTest.regionName;
  }

  @override
  void onClose() {

  }

  void getTrain() async {
    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.getUserTrain)
          .then((response) => regionResponses(response))
          .catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> regionResponses(dio.Response response) async {
    regionResponse.value = t.TrainResponse.fromJson(response.data);
    for (int i = 0; i < regionResponse.value.trainList!.length; i++) {
      trainName.add(regionResponse.value.trainList![i].trainNo!);
    }

    dropdownTrainItems =
        buildDropdownTestItems(regionResponse.value.trainList!);
  }
  expandNode(String key, bool expanded) {
    String msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    debugPrint(msg);
    tree.Node? node = treeViewController.value.getNode(key) ;
    if (node != null) {
      List<tree.Node> updated;
      updated = treeViewController.value.updateNode(
          key,
          node.copyWith(
            expanded: expanded,
            icon: expanded ? Icons.folder_open : Icons.folder,
          ));

      docsOpen.value = expanded;
      treeViewController.value = treeViewController.value.copyWith(children: updated);

      notifyChildrens();
      refresh();
    }
  }
  Future<void> getCountryNameAsync() async {
    await ApiManager()
        .getDio()!
        .post('https://geolocation-db.com/json/')
        .then((response) {
      Map data = jsonDecode(response.data);
      print(data);

      _lat = data["latitude"];
      _lon = data["longitude"];
    }).catchError((onError) {
      print(onError);
      // listener.onFailure(DioErrorUtil.handleErrors(onError));
    });
  }

  getLoc() async {
    userName.value =
        "${await SharedPrefManager.instance.getStringAsync(Constants.userName)}";
    bool _serviceEnabled;
    l.PermissionStatus _permissionGranted;
    await Permission.locationWhenInUse.request();
    await Permission.locationAlways.request();
    var status = await Permission.locationAlways.status;
    if (status.isDenied) {
      await Permission.locationAlways.request();
    }
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print("Marlen");
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        getCountryNameAsync();
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == l.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != l.PermissionStatus.granted) {
        getCountryNameAsync();
        return;
      }
    }

    _currentPosition = await location.getLocation();
    // _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);
    location.onLocationChanged.listen((l.LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      _currentPosition = currentLocation;
      // _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);

      DateTime now = DateTime.now();
      _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
      _getAddress(_currentPosition!.latitude, _currentPosition!.longitude);
      // _getAddress(_currentPosition!.latitude, _currentPosition!.longitude)
      //     .then((value) {
      //     _address = "${value.first.addressLine}";
      // });
    });
  }

  Future<void> _getAddress(double? lat, double? lang) async {
    _lat = lat!.toString();
    _lon = lang!.toString();
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);
    Placemark place = placemarks[0];
    //print(placemarks);
    _countryCode = place.isoCountryCode;
    _countryName = place.country;
    String Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    countryCode.value = place.isoCountryCode!;
  }

  Future<void> getUserInfo() async {
    print("Marlen Franto");
    guardNameController.text =
        "${await SharedPrefManager.instance.getStringAsync(Constants.userName)}";
    driverNameController.text =
        "${await SharedPrefManager.instance.getStringAsync(Constants.driverName)}";
    assistanceNameController.text =
        "${await SharedPrefManager.instance.getStringAsync(Constants.assistName)}";
    selectedTrainNo =
    "${await SharedPrefManager.instance.getStringAsync(Constants.trainID)}";
    dropdownEditingController=DropdownEditingController(value: "${await SharedPrefManager.instance.getStringAsync(Constants.trainNo)}");
    //_addTrainInfoRequest.trainId = int.parse(selectedTrainNo!);
  }

  Future<void> updateTrainDetails(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (manpowerFormKey.currentState!.validate()) {
      if (selectedTrainNo != null) {
        try {
          AddTrainInfoRequest _addTrainInfoRequest = AddTrainInfoRequest();
          _addTrainInfoRequest.loginTime = DateTime.now().toString();
          _addTrainInfoRequest.latitude = _lat;
          _addTrainInfoRequest.longitude = _lon;
          _addTrainInfoRequest.guardName = guardNameController.text;
          _addTrainInfoRequest.driverName = driverNameController.text;
          _addTrainInfoRequest.assistanceName = assistanceNameController.text;
          _addTrainInfoRequest.trainId = int.parse(selectedTrainNo!);
          _addTrainInfoRequest.userId = int.parse(
              "${await SharedPrefManager.instance.getStringAsync(Constants.userId)}");
          if (!Constants.isFromHomeScreen) {
            await ApiManager()
                .getDio()!
                .post(Endpoints.addTrainInfo, data: _addTrainInfoRequest)
                .then((response) => TrainDetailsResponses(response, context))
                .catchError((onError) {
              print(onError);
              ProgressBar.instance.stopProgressBar(context);
            });
          } else {
            ProgressBar.instance.stopProgressBar(context);
            Get.deleteAll();
            Get.off(() => LiveStatusUpdateScreen());
          }
        } catch (e) {
          print(e);
          ProgressBar.instance.stopProgressBar(context);
        }
      } else {
        ProgressBar.instance.stopProgressBar(context);
        Fluttertoast.showToast(
            msg: MyString.selectTrain,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: MyColors.kSecondaryColor,
            textColor: MyColors.white,
            fontSize: 16.0);
      }
    } else {
      ProgressBar.instance.stopProgressBar(context);
    }
  }

  Future<void> TrainDetailsResponses(
      dio.Response response, BuildContext context) async {
    SignInResponse _response = SignInResponse.fromJson(response.data);
    ProgressBar.instance.stopProgressBar(context);
    if (_response.responseResult == 0) {
      SharedPrefManager.instance
          .setStringAsync(Constants.driverName, driverNameController.text);
      SharedPrefManager.instance
          .setStringAsync(Constants.assistName, assistanceNameController.text);
      SharedPrefManager.instance
          .setStringAsync(Constants.trainID, selectedTrainNo!);
      SharedPrefManager.instance
          .setStringAsync(Constants.startTime, startTime!);
      SharedPrefManager.instance.setStringAsync(Constants.trainNo, trainId!);


      SharedPrefManager.instance
          .setStringAsync(Constants.loginId, _response.responseMessage!);
      Get.deleteAll();
      Get.offAll(() => LiveStatusUpdateScreen());
    } else {
      Fluttertoast.showToast(
          msg: _response.responseMessage!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: MyColors.kPrimaryColor,
          textColor: MyColors.white,
          fontSize: 16.0);
    }
  }

  void onChangeDropDown(String string) {
    for (int i = 0; i < regionResponse.value.trainList!.length; i++) {
      if (string == regionResponse.value.trainList![i].trainNo) {
        selectedTrainNo = regionResponse.value.trainList![i].trainId.toString();
        trainId = regionResponse.value.trainList![i].trainNo.toString();
        startTime = regionResponse.value.trainList![i].startTime.toString();
      }
    }
  }

  void getTrainTrackData() async {
    try {
      UserRequest _userRequest = UserRequest();
      _userRequest.iDNo = int.parse(
          "${await SharedPrefManager.instance.getStringAsync(Constants.loginId)}");
      await ApiManager()
          .getDio()!
          .post(Endpoints.getUserTrainInfo, data: _userRequest)
          .then((response) => trainTrackResponses(response))
          .catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> trainTrackResponses(dio.Response response) async {
    trainTrackResponse.value = TrainTrackResponse.fromJson(response.data);
  }

  onAlertWithCustomContent(context) {
    Alert(
        context: context,
        style: const AlertStyle(titleStyle: TextStyle(color: MyColors.kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 16),descStyle: TextStyle(fontSize: 12)),
        title: MyString.existingData,
        //desc: MyString.conformSignOut,
        closeIcon: const Icon(Icons.cancel,color: MyColors.kSecondaryColor,),

        buttons: [
          // DialogButton(
          //   color: MyColors.red,
          //   onPressed: (){ Get.back();},
          //   child: const Text(
          //     "Cancel",
          //     style: TextStyle(color: MyColors.white, fontSize: 16),
          //   ),
          // ),
          DialogButton(
            color: MyColors.kSecondaryColor,
            onPressed: () async {
              Get.back();
            },
            child: const Text(
              "Ok",
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
          )
        ]).show();
  }


  onAlertForSignOut(context) {
    Alert(
        context: context,
        style: const AlertStyle(
            titleStyle: TextStyle(
                color: MyColors.kSecondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
            descStyle: TextStyle(fontSize: 12)),
        title: MyString.conformSignOut,
        //desc: MyString.conformSignOut,
        closeIcon: const Icon(
          Icons.cancel,
          color: MyColors.kSecondaryColor,
        ),
        buttons: [
          DialogButton(
            color: MyColors.red,
            onPressed: (){ Get.back();},
            child: const Text(
              "Cancel",
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
          ),
          DialogButton(
            color: MyColors.kSecondaryColor,
            onPressed: () async {
              Constants.isFromHomeScreen=false;
              Get.deleteAll();
              Get.offAll(() => SignInScreen());
            },
            child: const Text(
              "Ok",
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
          )
        ]).show();
  }


}
