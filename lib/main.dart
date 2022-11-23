import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:irctc/service/shared_pref_manager.dart';
import 'package:irctc/support/colors.dart';
import 'package:irctc/support/constants.dart';
import 'package:irctc/support/string.dart';
import 'package:irctc/view/live_status_update_screen_ui.dart';
import 'package:irctc/view/sign_in_screen_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? trainID= await SharedPrefManager.instance.getStringAsync(Constants.trainID);
  runApp( MyApp(trainID));
}

class MyApp extends StatelessWidget {
  String? trainID;
   MyApp(this.trainID, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) =>
          MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
      title: MyString.appName,
      debugShowCheckedModeBanner: false,
      enableLog: true,
      theme: ThemeData(
        appBarTheme:const AppBarTheme(color:MyColors.kPrimaryColor ) ,
        hoverColor: Colors.transparent,
        primaryColor: MyColors.kPrimaryColor,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: MyColors.kPrimaryColor,foregroundColor: MyColors.white),
        fontFamily: 'PoppinsRegular',
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      home:trainID == null || trainID!.isEmpty? SignInScreen():LiveStatusUpdateScreen(),
      // home:  NotificationSelectionScreen(),
      // home:  OTPScreen(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
