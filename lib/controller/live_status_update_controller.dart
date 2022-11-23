import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:irctc/model/signin_response.dart';
import 'package:irctc/model/station_response.dart';
import 'package:irctc/model/train_info_request.dart';
import 'package:irctc/model/train_track_request.dart';
import 'package:irctc/model/train_track_response.dart';
import 'package:irctc/model/user_request.dart';
import 'package:irctc/service/api_manager.dart';
import 'package:irctc/service/db_helper.dart';
import 'package:irctc/service/endpoints.dart';
import 'package:irctc/service/shared_pref_manager.dart';
import 'package:irctc/support/colors.dart';
import 'package:irctc/support/constants.dart';
import 'package:irctc/support/string.dart';
import 'package:irctc/view/live_status_update_screen_ui.dart';
import 'package:irctc/view/sign_in_screen_ui.dart';
import 'package:irctc/widgets/progressbar.dart';
import 'package:location/location.dart' as l;
import 'package:rflutter_alert/rflutter_alert.dart';

class LiveStatusUpdateController extends GetxController {
  var type = "user".obs;
  var countryCode = "IN".obs;
  var checkTerms = false.obs;
  var checkTrainStation = false.obs;
  String? startTime, trainId, driverName, assistName;
  String? lastSync;
  String? nextStationName;
  var userName = "".obs;
  List<String> stationName = [];
  var stationResponse = StationResponse().obs;
  var trainTrackResponse = TrainTrackResponse().obs;
  final trainFormKey = GlobalKey<FormState>();
  final addLogFormKey = GlobalKey<FormState>();
  final advancedDrawerController = AdvancedDrawerController();
  final scrollController = ScrollController();
  DatabaseHelper? dbHelper;
  List<Map<String, dynamic>>? tableData;
  var isDeviceConnected = false;
  var subscription;
  String? stationId, initStationName;
  DropdownEditingController<String> dropdownEditingController =
      DropdownEditingController();

  TextEditingController reachingTimeController = TextEditingController();
  TextEditingController departureTimeController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController standardTimeController = TextEditingController();
  TextEditingController latTimeController = TextEditingController();
  TextEditingController longTimeController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController standardDepartureTimeController =
      TextEditingController();
  TextEditingController statusController = TextEditingController();
  l.Location location = new l.Location();
  l.LocationData? _currentPosition;
  DateTime? standardTime, departureTime;
  String? _address,
      _dateTime,
      _countryCode,
      _countryName,
      lat,
      lon,
      locationDetails;
  final List testList = [
    {'no': 1, 'keyword': 'No Data'},
    /*{'no': 2, 'keyword': 'black'},
      {'no': 3, 'keyword': 'red'}*/
  ];
  List<DropdownMenuItem<Object?>> dropdownStationItems = [];
  var selectedStation = StationList().obs;
  final FocusNode node = FocusNode();

  @override
  void onInit() {
    super.onInit();
    // reachingTimeController = TextEditingController();
    // departureTimeController = TextEditingController();
    // reasonController = TextEditingController();
    // standardTimeController = TextEditingController();
    // standardDepartureTimeController = TextEditingController();
    // statusController = TextEditingController();
    statusController.text = "On Time";
    subscription ??= Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (result != ConnectivityResult.none) {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (isDeviceConnected) {
            autoUpdate();
          }
        } else {
          Constants.isAutoUpdate = false;
          isDeviceConnected = false;
        }
      });
    dbHelper = DatabaseHelper.instance;
    print(DateTime.now().toString());
    getLoc();
    getStation();
    getTrainTrackData();
    // getOfflineData();
  }


  List<DropdownMenuItem<Object?>> buildDropdownTestItems(
      List<StationList> stationList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in stationList) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i.stationName!),
        ),
      );
    }
    checkTrainStation.value = true;
    return items;
  }

  onChangeDropdownStation(selectedStation) {
    print(selectedStation);
    this.selectedStation.value = selectedStation;
    if (this.selectedStation.value.time != null) {
      standardTimeController.text = DateFormat('HH:mm').format(
          DateFormat("hh:mm a")
              .parse(startTime!)
              .add(Duration(minutes: this.selectedStation.value.time!)));
      standardDepartureTimeController.text = DateFormat('HH:mm').format(
          DateFormat("hh:mm a")
              .parse(startTime!)
              .add(Duration(minutes: this.selectedStation.value.time! + 2)));
    }
  }

  @override
  void onClose() {
    subscription.cancel();
    print("Marlen Franto");

  }

  void getStation() async {
    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.getStation)
          .then((response) => trainResponses(response))
          .catchError((onError) {
        stationResponse.value = Constants.stationResponse;
        for (int i = 0; i < stationResponse.value.stationList!.length; i++) {
          stationName.add(stationResponse.value.stationList![i].stationName!);
        }
        dropdownEditingController = DropdownEditingController(
            value: stationName[Constants.initDropDownValue]);
        oninitDropDown(stationName[Constants.initDropDownValue]);
        dropdownStationItems =
            buildDropdownTestItems(stationResponse.value.stationList!);

        print(onError);
      });
    } catch (e) {
      stationResponse.value = Constants.stationResponse;
      for (int i = 0; i < stationResponse.value.stationList!.length; i++) {
        stationName.add(stationResponse.value.stationList![i].stationName!);
      }
      dropdownEditingController = DropdownEditingController(
          value: stationName[Constants.initDropDownValue]);
      oninitDropDown(stationName[Constants.initDropDownValue]);
      dropdownStationItems =
          buildDropdownTestItems(stationResponse.value.stationList!);

      print(e);
    }
  }

  Future<void> trainResponses(dio.Response response) async {
    stationResponse.value = StationResponse.fromJson(response.data);
    Constants.stationResponse = StationResponse.fromJson(response.data);
    for (int i = 0; i < stationResponse.value.stationList!.length; i++) {
      stationName.add(stationResponse.value.stationList![i].stationName!);
    }
    dropdownEditingController = DropdownEditingController(
        value: stationName[Constants.initDropDownValue]);
    oninitDropDown(stationName[Constants.initDropDownValue]);
    dropdownStationItems =
        buildDropdownTestItems(stationResponse.value.stationList!);
  }

  void getTrainTrackData() async {
    try {
      UserRequest _userRequest = UserRequest();
      _userRequest.iDNo = int.parse(
          "${await SharedPrefManager.instance.getStringAsync(Constants.loginId)}");
      await ApiManager()
          .getDio()!
          .post(Endpoints.getUserTrainInfo, data: _userRequest)
          .then((response) => regionResponses(response))
          .catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> regionResponses(dio.Response response) async {
    trainTrackResponse.value = TrainTrackResponse.fromJson(response.data);
  }

  Future<void> getCountryNameAsync() async {
    await ApiManager()
        .getDio()!
        .post('https://geolocation-db.com/json/')
        .then((response) {
      Map data = jsonDecode(response.data);
      print(data);
      if (data["country_code"] != null && data["country_code"] != "") {
        countryCode.value = data["country_code"];
        _countryCode = data["country_code"];
        _countryName = data["country_name"];
        placeController.text = data["city"];
        latTimeController.text = data["latitude"];
        longTimeController.text = data["longitude"];
      } else {
        countryCode.value = "IN";
      }
    }).catchError((onError) {
      print(onError);
      // listener.onFailure(DioErrorUtil.handleErrors(onError));
    });
  }

  getLoc() async {
    startTime =
        "${await SharedPrefManager.instance.getStringAsync(Constants.startTime)}";
    lastSync =
        "${await SharedPrefManager.instance.getStringAsync(Constants.lastSync)}";
    userName.value =
        "${await SharedPrefManager.instance.getStringAsync(Constants.userName)}";
    trainId =
        "${await SharedPrefManager.instance.getStringAsync(Constants.trainNo)}";
    driverName =
        "${await SharedPrefManager.instance.getStringAsync(Constants.driverName)}";
    assistName =
        "${await SharedPrefManager.instance.getStringAsync(Constants.assistName)}";

    bool _serviceEnabled;
    l.PermissionStatus _permissionGranted;

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
    this.lat = lat!.toString();
    this.lon = lang!.toString();
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);
    Placemark place = placemarks[0];
    //print(placemarks);
    _countryCode = place.isoCountryCode;
    _countryName = place.country;
    String Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    countryCode.value = place.isoCountryCode!;
    locationDetails = place.subLocality.toString();
    latTimeController.text = lat.toString();
    longTimeController.text = lang.toString();
  }

  void showTimePickerDialog(BuildContext context) async {
    // MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true);
    standardTime = DateFormat("HH:mm").parse(reachingTimeController.text);
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: standardTime!.hour, minute: standardTime!.minute),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      final now = DateTime.now();

      reachingTimeController.text = DateFormat('HH:mm').format(
          DateTime(now.year, now.month, now.day, newTime.hour, newTime.minute));
      if (DateFormat("HH:mm")
          .parse(standardTimeController.text)
          .isAfter(DateFormat("HH:mm").parse(reachingTimeController.text))) {
        statusController.text = MyString.early;
      } else if (DateFormat("HH:mm")
          .parse(standardTimeController.text)
          .isBefore(DateFormat("HH:mm").parse(reachingTimeController.text))) {
        statusController.text = MyString.delayed;
      } else {
        statusController.text = "On Time";
      }
    }
  }

  void showDepartureTimePickerDialog(BuildContext context) async {
    departureTime = DateFormat("HH:mm").parse(departureTimeController.text);
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: departureTime!.hour, minute: departureTime!.minute),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      final now = DateTime.now();

      departureTimeController.text = DateFormat('HH:mm').format(
          DateTime(now.year, now.month, now.day, newTime.hour, newTime.minute));
      if (DateFormat("HH:mm")
          .parse(standardDepartureTimeController.text)
          .isAfter(DateFormat("HH:mm").parse(departureTimeController.text))) {
        statusController.text = MyString.early;
      } else if (DateFormat("HH:mm")
          .parse(standardDepartureTimeController.text)
          .isBefore(DateFormat("HH:mm").parse(departureTimeController.text))) {
        statusController.text = MyString.delayed;
      } else {
        statusController.text = "On Time";
      }
    }
  }

  Future<void> addTrainTrackInfo(BuildContext context) async {
    // var subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) async {
    //   if (result != ConnectivityResult.none) {
    //     isDeviceConnected = await InternetConnectionChecker().hasConnection;
    //   } else {
    //     isDeviceConnected = false;
    //   }
    // });
    getLoc();
    FocusScope.of(context).requestFocus(FocusNode());
    if (trainFormKey.currentState!.validate()) {
      if (stationId != null) {
        if (DateFormat("HH:mm")
            .parse(departureTimeController.text)
            .isAfter(DateFormat("HH:mm").parse(reachingTimeController.text))) {
          TrainTrackRequest _addTrainInfoRequest = TrainTrackRequest();
          try {
            _addTrainInfoRequest.latitude = lat;
            _addTrainInfoRequest.longitude = lon;
            _addTrainInfoRequest.reachedTime = reachingTimeController.text;
            _addTrainInfoRequest.departureTime = departureTimeController.text;
            _addTrainInfoRequest.status = statusController.text;
            _addTrainInfoRequest.reason = reasonController.text;
            _addTrainInfoRequest.stationId = int.parse(stationId!);
            _addTrainInfoRequest.loginId = int.parse(
                "${await SharedPrefManager.instance.getStringAsync(Constants.loginId)}");
            _addTrainInfoRequest.trainId = int.parse(
                "${await SharedPrefManager.instance.getStringAsync(Constants.trainID)}");
            _addTrainInfoRequest.userId = int.parse(
                "${await SharedPrefManager.instance.getStringAsync(Constants.userId)}");
            await dbHelper!.insert(_addTrainInfoRequest);

            tableData = await dbHelper!.queryAllRows(lastSync!);
            for (int i = 0; i < tableData!.length; i++) {
              //TrainTrackRequest.fromJson(allRows[0]);
              await ApiManager()
                  .getDio()!
                  .post(Endpoints.addTrainTrackInfo, data: tableData![i])
                  .then((response) => TrainDetailsResponses(response, context))
                  .catchError((onError) {
                //  getTrainTrackData();

                print(onError);
                reachingTimeController = TextEditingController();
                reasonController = TextEditingController();
                standardTimeController = TextEditingController();
                standardDepartureTimeController = TextEditingController();
                departureTimeController = TextEditingController();
                statusController = TextEditingController();
                statusController.text = "On Time";
                dropdownEditingController.dispose();
                print(nextStationName);
                dropdownEditingController =
                    DropdownEditingController(value: nextStationName);
                dropdownEditingController.notifyListeners();

                selectedStation = StationList().obs;
                ProgressBar.instance.stopProgressBar(context);
                onChangeDropDown(initStationName!);
                Fluttertoast.showToast(
                    msg: MyString.save,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: MyColors.kSecondaryColor,
                    textColor: MyColors.white,
                    fontSize: 16.0);
                // Get.deleteAll();
                // Get.offAll(() => LiveStatusUpdateScreen());
              });
            }
          } catch (e) {
            ProgressBar.instance.stopProgressBar(context);
            //getTrainTrackData();
            onChangeDropDown(initStationName!);

            // Get.deleteAll();
            // Get.offAll(() => LiveStatusUpdateScreen());
            // if(e is DatabaseException){
            //   _onAlertWithCustomContent(context,_addTrainInfoRequest);
            //   reachingTimeController = TextEditingController();
            //   reasonController = TextEditingController();
            //   standardTimeController = TextEditingController();
            //   standardDepartureTimeController = TextEditingController();
            //   departureTimeController = TextEditingController();
            //   statusController = TextEditingController();
            //   statusController.text = " ";
            //   dropdownEditingController.dispose();
            //   print(nextStationName);
            //   dropdownEditingController =
            //       DropdownEditingController(value: nextStationName);
            //   dropdownEditingController.notifyListeners();
            //
            //   selectedStation = StationList().obs;
            // }
            print(e);
          }
        } else {
          ProgressBar.instance.stopProgressBar(context);
          onAlertWithCustomContent(context);
          // Fluttertoast.showToast(
          //     msg: MyString.timeValidation,
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 5,
          //     backgroundColor: MyColors.kSecondaryColor,
          //     textColor: MyColors.white,
          //     fontSize: 16.0);

        }
      } else {
        ProgressBar.instance.stopProgressBar(context);
        Fluttertoast.showToast(
            msg: MyString.selectStation,
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
    SharedPrefManager.instance
        .setStringAsync(Constants.lastSync, DateTime.now().toString());
    ProgressBar.instance.stopProgressBar(context);
    if (_response.responseResult == 0) {
      // getTrainTrackData();
      dbHelper!.delete();
      reachingTimeController = TextEditingController();
      reasonController = TextEditingController();
      standardTimeController = TextEditingController();
      statusController = TextEditingController();
      standardDepartureTimeController = TextEditingController();
      departureTimeController = TextEditingController();
      statusController.text = "On Time";
      dropdownEditingController.dispose();
      print(nextStationName);
      dropdownEditingController =
          DropdownEditingController(value: nextStationName);
      selectedStation = StationList().obs;
      Fluttertoast.showToast(
          msg: MyString.save,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: MyColors.kSecondaryColor,
          textColor: MyColors.white,
          fontSize: 16.0);
      onChangeDropDown(initStationName!);
      // Get.deleteAll();
      // Get.offAll(() => LiveStatusUpdateScreen());

      // SharedPrefManager.instance.setStringAsync(
      //     Constants.trainID, selectedTrain.value.trainId!.toString());
      // SharedPrefManager.instance.setStringAsync(
      //     Constants.startTime, selectedTrain.value.startTime!);
      //
      //
      // Get.deleteAll();
      // Get.offAll(() => LiveStatusUpdateScreen());
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

  // void logout() {
  //   SharedPrefManager.instance.setStringAsync(
  //       Constants.userId,"");
  //   SharedPrefManager.instance.setStringAsync(
  //       Constants.userName,"");
  //   SharedPrefManager.instance.setStringAsync(
  //       Constants.loginId,"");
  //   SharedPrefManager.instance.setStringAsync(
  //       Constants.trainID,"");
  //   SharedPrefManager.instance.setStringAsync(
  //       Constants.startTime,"");
  // }

  Future<void> logout() async {
    getLoc();
    SharedPrefManager.instance.setStringAsync(Constants.userId, "");
    SharedPrefManager.instance.setStringAsync(Constants.userName, "");
    SharedPrefManager.instance.setStringAsync(Constants.driverName, "");
    SharedPrefManager.instance.setStringAsync(Constants.assistName, "");
    SharedPrefManager.instance.setStringAsync(Constants.loginId, "");
    SharedPrefManager.instance.setStringAsync(Constants.trainID, "");
    SharedPrefManager.instance.setStringAsync(Constants.startTime, "");
    try {
      AddTrainInfoRequest _addTrainInfoRequest = AddTrainInfoRequest();
      _addTrainInfoRequest.logoutTime = DateTime.now().toString();
      _addTrainInfoRequest.logoutLatitude = lat;
      _addTrainInfoRequest.logoutLongitude = lon;

      await ApiManager()
          .getDio()!
          .post(Endpoints.logout, data: _addTrainInfoRequest)
          .then((response) => logoutResponses(response))
          .catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> logoutResponses(dio.Response response) async {
    Get.deleteAll();
    Get.offAll(() => SignInScreen());
  }

  void onChangeDropDown(String string) {
    for (int i = 0; i < stationResponse.value.stationList!.length; i++) {
      if (string == stationResponse.value.stationList![i].stationName) {
        if (stationResponse.value.stationList!.length - 1 > i) {
          Constants.initDropDownValue = i + 1;
          stationResponse.value.stationList![i + 1].stationName;
        } else {
          Constants.initDropDownValue =
              stationResponse.value.stationList!.length - 1;

          nextStationName = stationResponse.value.stationList!.last.stationName;
        }
        stationId = stationResponse.value.stationList![i].stationId.toString();
        initStationName =
            stationResponse.value.stationList![i].stationName.toString();
        standardTime = DateFormat("hh:mm a").parse(startTime!).add(
            Duration(minutes: stationResponse.value.stationList![i].time!));
        departureTime = DateFormat("hh:mm a").parse(startTime!).add(
            Duration(minutes: stationResponse.value.stationList![i].time! + 2));
        standardTimeController.text = DateFormat('HH:mm').format(
            DateFormat("hh:mm a").parse(startTime!).add(Duration(
                minutes: stationResponse.value.stationList![i].time!)));
        reachingTimeController.text = DateFormat('HH:mm').format(
            DateFormat("hh:mm a").parse(startTime!).add(Duration(
                minutes: stationResponse.value.stationList![i].time!)));
        standardDepartureTimeController.text = DateFormat('HH:mm').format(
            DateFormat("hh:mm a").parse(startTime!).add(Duration(
                minutes: stationResponse.value.stationList![i].time! + 2)));
        departureTimeController.text = DateFormat('HH:mm').format(
            DateFormat("hh:mm a").parse(startTime!).add(Duration(
                minutes: stationResponse.value.stationList![i].time! + 2)));
      }
    }
  }

  void oninitDropDown(String string) {
    for (int i = 0; i < stationResponse.value.stationList!.length; i++) {
      if (string == stationResponse.value.stationList![i].stationName) {
        stationId = stationResponse.value.stationList![i].stationId.toString();
        initStationName =
            stationResponse.value.stationList![i].stationName.toString();
        standardTime = DateFormat("hh:mm a").parse(startTime!).add(
            Duration(minutes: stationResponse.value.stationList![i].time!));
        departureTime = DateFormat("hh:mm a").parse(startTime!).add(
            Duration(minutes: stationResponse.value.stationList![i].time! + 2));
        standardTimeController.text = DateFormat('HH:mm').format(
            DateFormat("hh:mm a").parse(startTime!).add(Duration(
                minutes: stationResponse.value.stationList![i].time!)));
        reachingTimeController.text = DateFormat('HH:mm').format(
            DateFormat("hh:mm a").parse(startTime!).add(Duration(
                minutes: stationResponse.value.stationList![i].time!)));
        standardDepartureTimeController.text = DateFormat('HH:mm').format(
            DateFormat("hh:mm a").parse(startTime!).add(Duration(
                minutes: stationResponse.value.stationList![i].time! + 2)));
        departureTimeController.text = DateFormat('HH:mm').format(
            DateFormat("hh:mm a").parse(startTime!).add(Duration(
                minutes: stationResponse.value.stationList![i].time! + 2)));
      }
    }
  }

  Future<void> addLogInfo(BuildContext context) async {
    // var subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) async {
    //   if (result != ConnectivityResult.none) {
    //     isDeviceConnected = await InternetConnectionChecker().hasConnection;
    //   } else {
    //     isDeviceConnected = false;
    //   }
    // });
    getLoc();
    if (addLogFormKey.currentState!.validate()) {
      try {
        TrainTrackRequest _addTrainInfoRequest = TrainTrackRequest();
        _addTrainInfoRequest.latitude = latTimeController.text;
        _addTrainInfoRequest.longitude = longTimeController.text;
        _addTrainInfoRequest.reason = noteController.text;
        _addTrainInfoRequest.status = placeController.text;
        _addTrainInfoRequest.loginId = int.parse(
            "${await SharedPrefManager.instance.getStringAsync(Constants.loginId)}");
        _addTrainInfoRequest.trainId = int.parse(
            "${await SharedPrefManager.instance.getStringAsync(Constants.trainID)}");
        _addTrainInfoRequest.userId = int.parse(
            "${await SharedPrefManager.instance.getStringAsync(Constants.userId)}");
        await dbHelper!.insert(_addTrainInfoRequest);

        tableData = await dbHelper!.queryAllRows(lastSync!);

        for (int i = 0; i < tableData!.length; i++) {
          //TrainTrackRequest.fromJson(allRows[0]);
          if (await InternetConnectionChecker().hasConnection) {
            dbHelper!.delete();

            await ApiManager()
                .getDio()!
                .post(Endpoints.addTrainTrackInfo, data: tableData![i])
                .then((response) => () {
                      // getTrainTrackData();

                      SharedPrefManager.instance.setStringAsync(
                          Constants.lastSync, DateTime.now().toString());
                      latTimeController = TextEditingController();
                      longTimeController = TextEditingController();
                      noteController = TextEditingController();
                      placeController = TextEditingController();
                      Navigator.pop(context);
                    })
                .catchError((onError) {
              // getTrainTrackData();
              Fluttertoast.showToast(
                  msg: MyString.save,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: MyColors.kSecondaryColor,
                  textColor: MyColors.white,
                  fontSize: 16.0);
              latTimeController = TextEditingController();
              longTimeController = TextEditingController();
              noteController = TextEditingController();
              placeController = TextEditingController();

              Navigator.pop(context);
              print(onError);
            });
          }else{
            Fluttertoast.showToast(
                msg: MyString.save,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: MyColors.kSecondaryColor,
                textColor: MyColors.white,
                fontSize: 16.0);
          }
        }
      } catch (e) {
        // getTrainTrackData();

        print(e);
      }
    } else {}
  }

  onAlertWithCustomContent(context) {
    Alert(
        context: context,
        style: const AlertStyle(
            titleStyle: TextStyle(
                color: MyColors.kSecondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
            descStyle: TextStyle(fontSize: 12)),
        title: MyString.timeValidation,
        //desc: MyString.conformSignOut,
        closeIcon: const Icon(
          Icons.cancel,
          color: MyColors.kSecondaryColor,
        ),
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

  // Future<void> updateLogInfo(TrainTrackRequest addTrainInfoRequest) async {
  //   // var subscription = Connectivity()
  //   //     .onConnectivityChanged
  //   //     .listen((ConnectivityResult result) async {
  //   //   if (result != ConnectivityResult.none) {
  //   //     isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //   //   } else {
  //   //     isDeviceConnected = false;
  //   //   }
  //   // });
  //   getLoc();
  //   try {
  //     await ApiManager()
  //         .getDio()!
  //         .post(Endpoints.addTrainTrackInfo, data: addTrainInfoRequest)
  //         .then((response) => resetData())
  //         .catchError((onError) {
  //       // getTrainTrackData();
  //       dbHelper!.delete();
  //       SharedPrefManager.instance
  //           .setStringAsync(Constants.lastSync, DateTime.now().toString());
  //       reachingTimeController = TextEditingController();
  //       reasonController = TextEditingController();
  //       standardTimeController = TextEditingController();
  //       statusController = TextEditingController();
  //       standardDepartureTimeController = TextEditingController();
  //       departureTimeController = TextEditingController();
  //       statusController.text = "On Time";
  //       dropdownEditingController.dispose();
  //       print(nextStationName);
  //       dropdownEditingController =
  //           DropdownEditingController(value: nextStationName);
  //       selectedStation = StationList().obs;
  //       // Get.deleteAll();
  //       // Get.offAll(() => LiveStatusUpdateScreen());
  //
  //       print(onError);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // resetData() {
  //   reachingTimeController = TextEditingController();
  //   reasonController = TextEditingController();
  //   standardTimeController = TextEditingController();
  //   statusController = TextEditingController();
  //   standardDepartureTimeController = TextEditingController();
  //   departureTimeController = TextEditingController();
  //   statusController.text = "On Time";
  //   dropdownEditingController.dispose();
  //   print(nextStationName);
  //   dropdownEditingController =
  //       DropdownEditingController(value: nextStationName);
  //   selectedStation = StationList().obs;
  //   // getTrainTrackData();
  //   // Get.deleteAll();
  //   // Get.offAll(() => LiveStatusUpdateScreen());
  // }

  Future<void> autoUpdate() async {
    // Constants.isAutoUpdate=false;


      tableData = await dbHelper!.queryAllRows(lastSync!);
      dbHelper!.delete();


      for (int i = 0; i < tableData!.length; ++i) {
        //TrainTrackRequest.fromJson(allRows[0]);
        SharedPrefManager.instance.setStringAsync(
            Constants.lastSync, DateTime.now().toString());
          await ApiManager()
              .getDio()!
              .post(Endpoints.addTrainTrackInfo, data: tableData![i])
              .then((response) => () {
                    // getTrainTrackData();

                    // Constants.isAutoUpdate=false;
                  })
              .catchError((onError) {
            // getTrainTrackData();

            print(onError);
          });

      }

  }
//
// void getOfflineData() async{
//   tableData = await dbHelper!.queryAllRows("null");
//   for (int i = 0; i < tableData!.length; i++) {
//     trainTrackResponse.value.trainList.add(tableData![i]);
//   }
// }


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
              Constants.isFromHomeScreen = false;
              Constants.initDropDownValue = 0;
              logout();
              Get.back();
            },
            child: const Text(
              "Ok",
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
          )
        ]).show();
  }


}
