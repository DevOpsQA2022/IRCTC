import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:irctc/model/signin_request.dart';
import 'package:irctc/model/signin_response.dart';
import 'package:irctc/service/api_manager.dart';
import 'package:irctc/service/db_helper.dart';
import 'package:irctc/service/dio_error_util.dart';
import 'package:irctc/service/endpoints.dart';
import 'package:irctc/service/exception_error_util.dart';
import 'package:irctc/service/shared_pref_manager.dart';
import 'package:irctc/support/colors.dart';
import 'package:irctc/support/constants.dart';
import 'package:irctc/support/string.dart';
import 'package:irctc/view/man_power_update_screen_ui.dart';
import 'package:irctc/widgets/progressbar.dart';
import 'package:dio/dio.dart' as dio;

import '../view/main_menu_screen_ui.dart';
import 'man_power_update_controller.dart';


class SignInController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // usernameController = TextEditingController();
    // passwordController = TextEditingController();
    Get.put(ManPowerUpdateController());

    // getCountryNameAsync();
  }

  @override
  void onClose() {

  }



  Future<void> putLogin(BuildContext context) async {
    if (loginFormKey.currentState!.validate()) {
      // FocusScope.of(context).requestFocus(FocusNode());
      try {
        SignInRequest _signinRequest = SignInRequest();
        _signinRequest.userName = usernameController.text;
        _signinRequest.userPassword = passwordController.text;


        await ApiManager()
            .getDio()!
            .post(Endpoints.signinUrl + Endpoints.userLogin,
            data: _signinRequest)
            .then((response) => registerResponse(response, context))
            .catchError((onError) {
          ProgressBar.instance.stopProgressBar(context);
          Fluttertoast.showToast(
              msg: MyString.enterValidCredentials,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: MyColors.kSecondaryColor,
              textColor: MyColors.white,
              fontSize: 16.0);
        });
      } catch (e) {
        ProgressBar.instance.stopProgressBar(context);
        Fluttertoast.showToast(
            msg: ExceptionErrorUtil.handleErrors(e).errorMessage!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: MyColors.kPrimaryColor,
            textColor: MyColors.white,
            fontSize: 16.0);
      }
    } else {
      ProgressBar.instance.stopProgressBar(context);
    }
  }

  Future<void> registerResponse(
      dio.Response response, BuildContext context) async {
    SignInResponse _response = SignInResponse.fromJson(response.data);
    ProgressBar.instance.stopProgressBar(context);
    if(_response.responseResult==0){
      SharedPrefManager.instance.setStringAsync(
          Constants.userId, _response.responseMessage!);
      SharedPrefManager.instance.setStringAsync(
          Constants.userName, usernameController.text);

      Constants.isFromHomeScreen = false;
      //Get.deleteAll();
      // Get.to(() => ManPowerUpdateScreen(usernameController.text));
      Get.offAll(() =>  MainMenuScreen());

    }else{
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

}
