import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ValidateInput {


  static String? validatePassword(String? value) {
    String pattern =
        r'^(?=.*?[a-z])(?=.*?[0-9]).{7,}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "Enter Password";
    } else if (value.isNotEmpty && value.length <= 6) {
      return "Password must be in the following\nformat:\nMinimum Length: 7\nMinimum Numeric Characters: 1\nMinimum Alphabet Characters: 1";
    } else if (!regExp.hasMatch(value)) {
      // return "Strong Password is Required";
      return "Password must be in the following\nformat:\nMinimum Length: 7\nMinimum Numeric Characters: 1\nMinimum Alphabet Characters: 1";
    }
    return null;
  }
  static String? verifyFields(valueOne, String valueTwo) {
    if (valueOne.length == 0) {
      return "Confirm Password is Required";
    } else if(valueOne.toString()==valueTwo) {
      return null;
    } else {
      return 'Password and Confirm Password does not match';
    }
  }


  static String? validateMobile(String? value) {
    if(value!.isEmpty) {
      return 'Enter Phone Number';
    } else if (!GetUtils.isPhoneNumber(value)) {
      return 'Enter Valid Phone Number';
    } else {
      return null;
    }
  }


  static String? validateEmailMobiles(String value) {
    bool isEmail(String input) => RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(input);
    bool isPhone(String input) => RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$').hasMatch(input);

    if (!isEmail(value) && !isPhone(value)) {
      return 'Enter a valid Email or Phone Number.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if(value!.isEmpty) {
      return 'Enter Email';
    } else if (!GetUtils.isEmail(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }
  static String? validateUsername(String? value) {
    if(value!.isEmpty) {
      return 'Enter Username';
    }else {
      return null;
    }
  }

  static String? validateReason(String? value) {
    if(value!.isEmpty) {
      return 'Enter Reason';
    }else {
      return null;
    }
  }

  static String? validateGuardName(String? value) {
    if(value!.isEmpty) {
      return 'Enter Guard Name';
    }else {
      return null;
    }
  }
  static String? validateAssistanceName(String? value) {
    if(value!.isEmpty) {
      return 'Enter Assistance Name';
    }else {
      return null;
    }
  }

  static String? validateFirstName(String? value) {
    RegExp regExp = RegExp("[a-zA-Z]");

    if(value!.isEmpty) {
      return 'Enter First Name';
    }else if (!regExp.hasMatch(value)) {
      return "First Name should have at least one \nalphabet";
    }else {
      return null;
    }
  }
  static String? validateLastName(String? value) {
    if(value!.isEmpty) {
      return 'Enter Last Name';
    }else {
      return null;
    }
  }

  static String? validateReachingTime(String? value) {
    if(value!.isEmpty) {
      return 'Enter Reaching Time';
    }else {
      return null;
    }
  }

  static String? validateDepartureTime(String? value) {
    if(value!.isEmpty) {
      return 'Enter Departure Time';
    }else {
      return null;
    }
  }

  static String? validateDriverName(String? value) {
    if(value!.isEmpty) {
      return 'Enter Driver Name';
    }else {
      return null;
    }
  }

  static String? validatePass(String? value) {
    if(value!.isEmpty) {
      return 'Enter Password';
    }else {
      return null;
    }
  }


  static String? validateProductName(String? value) {
    if(value!.isEmpty) {
      return 'Enter Product Name';
    }else {
      return null;
    }
  }

  static String? validateSellerName(String? value) {
    if(value!.isEmpty) {
      return 'Enter Seller Name/company';
    }else {
      return null;
    }
  }

  static String? validateDescription(String? value) {
    if(value!.isEmpty) {
      return 'Enter Description';
    }else {
      return null;
    }
  }
  static String? validateNote(String? value) {
    if(value!.isEmpty) {
      return 'Enter Note';
    }else {
      return null;
    }
  }
  static String? validatePlace(String? value) {
    if(value!.isEmpty) {
      return 'Enter Place';
    }else {
      return null;
    }
  }

  static String? validateField(String? value) {

      return null;

  }

}
