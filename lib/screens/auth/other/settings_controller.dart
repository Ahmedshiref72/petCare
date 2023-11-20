import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../home/home_controller.dart';
import '../model/theme_mode_data_model.dart';
import '../services/auth_service_apis.dart';

class SettingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPayment = false.obs;
  RxBool isTouchId = false.obs;

  Rx<LanguageDataModel> selectedLang = LanguageDataModel().obs;
  List<ThemeModeData> themeModes = [
    ThemeModeData(id: THEME_MODE_SYSTEM, mode: "System"),
    ThemeModeData(id: THEME_MODE_LIGHT, mode: "Light"),
    ThemeModeData(id: THEME_MODE_DARK, mode: "Dark")
  ];
  Rx<ThemeModeData> dropdownValue = ThemeModeData().obs;

  void handleDeleteAccountClick() {
    ifNotTester(() {
      isLoading(true);

      AuthServiceApis.deleteAccountCompletely().then((value) async {
        AuthServiceApis.clearData(isFromDeleteAcc: true);
        isLoading(false);
        toast(value.message);
        Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
          Get.put(HomeScreenController());
        }));
      }).catchError((e) {
        isLoading(false);
        toast(e.toString());
      });
    });
  }

  @override
  Future<void> onInit() async {
    try {
      final getThemeFromLocal =
          getValueFromLocal(SettingsLocalConst.THEME_MODE);
      if (getThemeFromLocal is int) {
        dropdownValue(themeModes.firstWhere(
          (element) => element.id == getThemeFromLocal,
          orElse: () => ThemeModeData(),
        ));
        toggleThemeMode(themeId: getThemeFromLocal);
      }
    } catch (e) {
      debugPrint('getThemeFromLocal from cache E: $e');
    }
    if (localeLanguageList.isNotEmpty) {
      selectedLanguageCode(
          getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);
      selectedLang(localeLanguageList.firstWhere(
        (element) => element.languageCode == selectedLanguageCode.value,
        orElse: () => LanguageDataModel(id: -1),
      ));
    }
    debugPrint('ISDARK: ${isDarkMode.value}');

    super.onInit();
  }
}
