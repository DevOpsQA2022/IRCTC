import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irctc/controller/sign_in_controller.dart';
import 'package:irctc/support/colors.dart';
import 'package:irctc/support/images.dart';
import 'package:irctc/support/string.dart';
import 'package:irctc/support/validate_input.dart';
import 'package:irctc/widgets/custom_password_field.dart';
import 'package:irctc/widgets/customize_text_field.dart';
import 'package:irctc/widgets/progressbar.dart';

import 'main_menu_screen_ui.dart';
import 'man_power_update_screen_ui.dart';


class SignInScreen extends StatelessWidget {
   SignInScreen({Key? key}) : super(key: key);

  final SignInController controller = Get.put(SignInController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:MyColors.kPrimaryColor,
      body: Stack(
        children: [
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: SafeArea(
                child: Image.asset(MyImages.irctcLogo, width: 100),
              ),
            ),
          ),
      Center(
        child: Card(
          elevation: 50,
          shadowColor: MyColors.black,
          color: MyColors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.width*.85,
            height: MediaQuery.of(context).size.height*.52,
            child:Form(
              key: controller.loginFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      child: Container(
                        height: 60,
                        color: MyColors.kSecondaryColor,
                        child:  const Center(
                          child: Text(MyString.signIn,style: TextStyle(
                              color: MyColors.kPrimaryColor,
                              fontSize: 20,fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40,),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20),
                        child: Column(
                          children: [
                            CustomizeTextFormField(labelText:MyString.username,
                              helperText: MyString.username,
                              onClick: (){},
                              onChange: (value){},
                              onSave: (value){},
                              controller: controller.usernameController,
                              validator: ValidateInput.validateUsername,
                            ),
                            const SizedBox(height: 20,),
                            CustomPasswordTextField(labelText:MyString.password,
                              helperText: MyString.password,
                              onChange: (value){},
                              onSave: (value){},
                              isPwdType: true,
                              inputAction: TextInputAction.done,
                              isLast: true,
                              controller: controller.passwordController,
                              validator: ValidateInput.validatePass,
                            ),
                            const SizedBox(height: 20,),
                            ElevatedButton(
                              style:ElevatedButton.styleFrom(textStyle: const TextStyle(color: MyColors.white,fontWeight: FontWeight.bold),primary: MyColors.kSecondaryColor,minimumSize: Size(MediaQuery.of(context).size.width*.75, 40) ),
                              onPressed: () {
                                ProgressBar.instance.showProgressbar(context);
                                controller.putLogin(context);
                                // Get.offAll(() =>  MainMenuScreen());

                                           },
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(MyString.signIn),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),


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
      ),
        ],
      ),
    );
  }
}
class Gender {
  final int id;
  final String name;

  Gender(
      this.id,
      this.name,
      );
}
List<Gender> getGender = <Gender>[
  Gender(
    1,
    "Male",
  ),
  Gender(
    2,
    "Female",
  ),
  Gender(
    3,
    "other",
  ),
];
