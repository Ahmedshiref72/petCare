import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pawlly/locale/language_en.dart';
import 'package:pawlly/screens/shop/order/model/order_detail_model.dart';
import 'package:pawlly/screens/splash/splash_screen.dart';

import 'app_theme.dart';
import 'configs.dart';
import 'locale/app_localizations.dart';
import 'locale/languages.dart';
import 'screens/auth/model/notification_model.dart';
import 'screens/booking_module/booking_detail/booking_detail_screen.dart';
import 'screens/booking_module/model/booking_data_model.dart';
import 'screens/dashboard/dashboard_res_model.dart';
import 'screens/home/home_controller.dart';
import 'screens/shop/order/order_detail_screen.dart';
import 'utils/app_common.dart';
import 'utils/colors.dart';
import 'utils/common_base.dart';
import 'utils/constants.dart';
import 'utils/local_storage.dart';
import 'utils/one_signal_utils.dart';

Rx<BaseLanguage> locale = LanguageEn().obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  // locale.value.LanguageList = languageList();

  await GetStorage.init();
  //
  fontFamilyPrimaryGlobal =
      GoogleFonts.tajawal(fontWeight: FontWeight.w500).fontFamily;
  // textPrimarySizeGlobal = 24;
  textPrimarySizeGlobal = 14;
  textPrimaryColorGlobal = primaryTextColor;
  fontFamilySecondaryGlobal =
      GoogleFonts.tajawal(fontWeight: FontWeight.w400).fontFamily;
  // textSecondarySizeGlobal = 14;
  textSecondarySizeGlobal = 12;
  textSecondaryColorGlobal = secondaryTextColor;
  //
  defaultBlurRadius = 0;
  defaultRadius = 12;
  defaultSpreadRadius = 0;
  appButtonBackgroundColorGlobal = primaryColor;
  defaultAppButtonRadius = defaultRadius;
  defaultAppButtonElevation = 0;
  defaultAppButtonTextColorGlobal = Colors.white;
  print(Platform.localeName.split("_").first.toLowerCase());
  print('Platform.localeName.split("_").first.toLowerCase()');
  await initialize(aLocaleLanguageList: languageList());

  selectedLanguageCode(
      getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);
  BaseLanguage temp =
      await const AppLocalizations().load(Locale(selectedLanguageCode.value));
  locale = temp.obs;
  locale.value =
      await const AppLocalizations().load(Locale(selectedLanguageCode.value));

  try {
    final getThemeFromLocal = getValueFromLocal(SettingsLocalConst.THEME_MODE);
    if (getThemeFromLocal is int) {
      toggleThemeMode(themeId: getThemeFromLocal);
    } else {
      toggleThemeMode(themeId: THEME_MODE_SYSTEM);
    }
  } catch (e) {
    debugPrint('getThemeFromLocal from cache E: $e');
  }

  if (kReleaseMode) {
    Firebase.initializeApp().then((value) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
    });
  }

  initOneSignal();

  ///Handle Navigation
  OneSignal.Notifications.addClickListener((event) {
    try {
      if (event.notification.additionalData != null) {
        if (event.notification.additionalData != null) {
          final additionalData =
              event.notification.additionalData!['additional_data'];
          NotificationDetail nData =
              NotificationDetail.fromJson(additionalData);
          if (nData.id > 0) {
            if (nData.notificationGroup == "shop") {
              Get.to(() => OrderDetailScreen(),
                  arguments:
                      OrderListData(id: nData.id, orderCode: nData.orderCode));
            } else {
              Get.to(() => BookingDetailScreen(),
                  arguments: BookingDataModel(
                      id: nData.id,
                      service: SystemService(name: nData.bookingServicesNames),
                      payment: PaymentDetails(),
                      training: Training()));
            }
          }
        }
      }
    } catch (e) {
      log('addClickListener E: $e');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
      child: Obx(
        () => GetMaterialApp(
          navigatorKey: navigatorKey,
          title: APP_NAME,
          debugShowCheckedModeBanner: false,
          supportedLocales: LanguageDataModel.languageLocales(),
          localizationsDelegates: const [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) =>
              Locale(selectedLanguageCode.value),
          fallbackLocale: const Locale('el'),
          locale: Locale(selectedLanguageCode.value),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // themeMode: ThemeMode.system,
          themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          initialBinding: BindingsBuilder(() {
            isDarkMode.value
                ? setStatusBarColor(scaffoldDarkColor,
                    statusBarIconBrightness: Brightness.light,
                    statusBarBrightness: Brightness.light)
                : setStatusBarColor(context.scaffoldBackgroundColor,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light);
            if (isLoggedIn.value) {
              debugPrint('INITIALBINDING: called');
              Get.put<HomeScreenController>(HomeScreenController());
            }
          }),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
