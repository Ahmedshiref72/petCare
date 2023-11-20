// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/auth/services/auth_service_apis.dart';
import 'package:pawlly/screens/walkthrough/change_lang_screen.dart';

import '../../utils/app_common.dart';
import '../../utils/constants.dart';
import '../../utils/local_storage.dart';
import '../auth/model/login_response.dart';
import '../dashboard/dashboard_screen.dart';
import '../home/home_controller.dart';
import '../walkthrough/walkthrough_screen.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() {
    getAppConfigurations();
  }

  ///Get ChooseService List
  getAppConfigurations() {
    AuthServiceApis.getAppConfigurations().then((value) {
      appCurrency(value.currency);
      appConfigs(value);

      ///Navigation logic
      navigationLogic();
    }).onError((error, stackTrace) {
      toast(error.toString());

      ///Navigation logic
      navigationLogic();
    });
  }

void navigationLogic() {
  bool isFirstTime = getValueFromLocal(SharedPreferenceConst.FIRST_TIME) ?? false;
  bool isLoggedIn = getValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN) == true;

  if (!isFirstTime) {
    // If it's the user's first time, show the Change Language screen
    Get.offAll(() => ChangeLanguageScreen(onLanguageSelected: () {
      navigateToWalkthroughScreen();
    }));
  } else if (isLoggedIn) {
    // Logic for logged-in users
    navigateToDashboardScreen();
  } else {
    // Logic for non-logged-in users
    navigateToDashboardScreen();
  }
}

void navigateToWalkthroughScreen() {
  Get.offAll(() => WalkthroughScreen());
}

void navigateToDashboardScreen() {
  try {
    final userData = getValueFromLocal(SharedPreferenceConst.USER_DATA);
    isLoggedIn(true);
    loginUserData(UserData.fromJson(userData));
    Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
      Get.put(HomeScreenController());
    }));
  } catch (e) {
    debugPrint('SplashScreenController Err: $e');
    Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
      Get.put(HomeScreenController());
    }));
  }
}


}
