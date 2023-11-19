// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/new_update_dialog.dart';
import '../components/price_widget.dart';
import '../configs.dart';
import '../generated/assets.dart';
import '../main.dart';
import '../screens/auth/sign_in_sign_up/signin_screen.dart';
import 'app_common.dart';
import 'colors.dart';
import 'constants.dart';
import 'local_storage.dart';

String? get fontFamilyFontWeight600 =>
    GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600).fontFamily;
String? get fontFamilyFontBold =>
    GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold).fontFamily;
String? get fontFamilyFontWeight300 =>
    GoogleFonts.beVietnamPro(fontWeight: FontWeight.w300).fontFamily;
String? get fontFamilyFontWeight400 =>
    GoogleFonts.beVietnamPro(fontWeight: FontWeight.w400).fontFamily;

Widget get commonDivider => Column(
      children: [
        //4.height,
        Divider(
          indent: 3,
          height: 1,
          color: isDarkMode.value
              ? borderColor.withOpacity(0.1)
              : borderColor.withOpacity(0.5),
        ).paddingSymmetric(horizontal: 16),
        // 12.height,
      ],
    );

Widget get bottomSheetDivider => Column(
      children: [
        20.height,
        Divider(
          indent: 3,
          height: 0,
          color: isDarkMode.value
              ? borderColor.withOpacity(0.2)
              : borderColor.withOpacity(0.5),
        ),
        20.height,
      ],
    );

void handleRate() async {
  if (isAndroid) {
    if (getStringAsync(APP_PLAY_STORE_URL).isNotEmpty) {
      commonLaunchUrl(getStringAsync(APP_PLAY_STORE_URL),
          launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl(
          '${getSocialMediaLink(LinkProvider.PLAY_STORE)}${await getPackageName()}',
          launchMode: LaunchMode.externalApplication);
    }
  } else if (isIOS) {
    if (getStringAsync(APP_APPSTORE_URL).isNotEmpty) {
      commonLaunchUrl(getStringAsync(APP_APPSTORE_URL),
          launchMode: LaunchMode.externalApplication);
    }
  }
}

void hideKeyBoardWithoutContext() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void toggleThemeMode({required int themeId}) {
  if (themeId == THEME_MODE_SYSTEM) {
    Get.changeThemeMode(ThemeMode.system);
    isDarkMode(Get.isPlatformDarkMode);
  } else if (themeId == THEME_MODE_LIGHT) {
    Get.changeThemeMode(ThemeMode.light);
    isDarkMode(false);
  } else if (themeId == THEME_MODE_DARK) {
    Get.changeThemeMode(ThemeMode.dark);
    isDarkMode(true);
  }
  setValueToLocal(SettingsLocalConst.THEME_MODE, themeId);
  debugPrint('toggleDarkLightSwitch: $themeId');
  if (isDarkMode.value) {
    textPrimaryColorGlobal = Colors.white;
    textSecondaryColorGlobal = Colors.white70;
  } else {
    textPrimaryColorGlobal = primaryTextColor;
    textSecondaryColorGlobal = secondaryTextColor;
  }
  updateUi(true);
  updateUi(false);
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        fullLanguageCode: 'en-US',
        flag: Assets.flagsIcUs),
    LanguageDataModel(
        id: 2,
        name: 'Hindi',
        languageCode: 'hi',
        fullLanguageCode: 'hi-IN',
        flag: Assets.flagsIcIn),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        fullLanguageCode: 'ar-AR',
        flag: Assets.flagsIcAr),
    LanguageDataModel(
        id: 4,
        name: 'French',
        languageCode: 'fr',
        fullLanguageCode: 'fr-FR',
        flag: Assets.flagsIcFr),
    LanguageDataModel(
        id: 4,
        name: 'German',
        languageCode: 'de',
        fullLanguageCode: 'de-DE',
        flag: Assets.flagsIcDe),
  ];
}

Widget appCloseIconButton(BuildContext context,
    {required void Function() onPressed, double size = 12}) {
  return IconButton(
    iconSize: size,
    padding: EdgeInsets.zero,
    onPressed: onPressed,
    icon: Container(
      padding: EdgeInsets.all(size - 8),
      decoration: boxDecorationDefault(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(size - 4),
          border: Border.all(color: secondaryTextColor)),
      child: Icon(
        Icons.close_rounded,
        size: size,
      ),
    ),
  );
}

Widget commonLeadingWid(
    {required String imgPath,
    required IconData icon,
    Color? color,
    double size = 20}) {
  return Image.asset(
    imgPath,
    width: size,
    height: size,
    color: color,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) => Icon(
      icon,
      size: size,
      color: color ?? secondaryColor,
    ),
  );
}

Future<void> commonLaunchUrl(String address,
    {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('${locale.value.invalidUrl}: $address');
  });
}

void viewFiles(String url) {
  if (url.isNotEmpty) {
    commonLaunchUrl(url, launchMode: LaunchMode.externalApplication);
  }
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS) {
      commonLaunchUrl('tel://${url!}',
          launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl('tel:${url!}',
          launchMode: LaunchMode.externalApplication);
    }
  }
}

void launchMap(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl(Constants.googleMapPrefix + url!,
        launchMode: LaunchMode.externalApplication);
  }
}

void launchMail(String url) {
  if (url.validate().isNotEmpty) {
    launchUrl(mailTo(to: []), mode: LaunchMode.externalApplication);
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

/* String formatDate(String? dateTime, {String format = DateFormatConst.yyyy_MM_dd}) {
  return DateFormat(format).format(DateTime.parse(dateTime.validate()));
} */

///
/// Date format extension for format datetime in different formats,
/// e.g. 1) dd-MM-yyyy, 2) yyyy-MM-dd, etc...
///
extension DateData on String {
  /// Formats the given [DateTime] object in the [dd-MM-yy] format.
  ///
  /// Returns a string representing the formatted date.
  DateTime get dateInyyyyMMddFormat {
    try {
      return DateFormat(DateFormatConst.yyyy_MM_dd).parse(this);
    } catch (e) {
      return DateTime.now();
    }
  }

  String get dateInMMMMDyyyyFormat {
    try {
      return DateFormat(DateFormatConst.MMMM_D_yyyy)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dateInEEEEDMMMMAtHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.EEEE_D_MMMM_At_HH_mm_a)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dateInDMMMMyyyyFormat {
    try {
      return DateFormat(DateFormatConst.D_MMMM_yyyy)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dayFromDate {
    try {
      return dateInyyyyMMddHHmmFormat.day.toString();
    } catch (e) {
      return "";
    }
  }

  String get monthMMMFormat {
    try {
      return dateInyyyyMMddHHmmFormat.month.toMonthName(isHalfName: true);
    } catch (e) {
      return "";
    }
  }

  String get dateInMMMMDyyyyAtHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.MMMM_D_yyyy_At_HH_mm_a)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dateInddMMMyyyyHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.dd_MMM_yyyy_HH_mm_a)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      try {
        return "$dateInyyyyMMddHHmmFormat";
      } catch (e) {
        return this;
      }
    }
  }

  DateTime get dateInyyyyMMddHHmmFormat {
    try {
      return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(this);
    } catch (e) {
      try {
        return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(
            DateTime.parse(this)
                .toString()); //TODO: toLocal() Removed for UTC Time
      } catch (e) {
        log('dateInyyyyMMddHHmmFormat Error in $this: $e');
        return DateTime.now();
      }
    }
  }

  DateTime get dateInHHmm24HourFormat {
    return DateFormat(DateFormatConst.HH_mm24Hour).parse(this);
  }

  String get timeInHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.HH_mm12Hour)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  TimeOfDay get timeOfDay24Format {
    return TimeOfDay.fromDateTime(
        DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(this));
  }

  /* String get dateIndmmyhmaFormat {
    return DateFormat(DateFormatConst.yyyy_MM_dd).format(DateFormat(DateFormatConst.MMMM_D_yyyy).parse(this));
  } */

  bool get isValidTime {
    return DateTime.tryParse("1970-01-01 $this") != null;
  }

  bool get isValidDateTime {
    return DateTime.tryParse(this) != null;
  }

  bool get isAfterCurrentDateTime {
    return dateInyyyyMMddHHmmFormat.isAfter(DateTime.now());
  }

  bool get isToday {
    try {
      return "$dateInyyyyMMddFormat" == DateTime.now().formatDateYYYYmmdd();
    } catch (e) {
      return false;
    }
  }

  Duration toDuration() {
    final parts = split(':');
    try {
      if (parts.length == 2) {
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        return Duration(hours: hours, minutes: minutes);
      } else {
        return Duration.zero;
      }
    } catch (e) {
      return Duration.zero;
    }
  }

  String toFormattedDuration({bool showFullTitleHoursMinutes = false}) {
    try {
      final duration = toDuration();
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);

      String formattedDuration = '';
      if (hours > 0) {
        formattedDuration +=
            "$hours ${showFullTitleHoursMinutes ? 'hour' : 'hr'} ";
      }
      if (minutes > 0) {
        formattedDuration +=
            '$minutes ${showFullTitleHoursMinutes ? 'minute' : 'min'}';
      }
      return formattedDuration.trim();
    } catch (e) {
      return "";
    }
  }
}

extension DateExtension on DateTime {
  /// Formats the given [DateTime] object in the [dd-MM-yy] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateDDMMYY() {
    final formatter = DateFormat(DateFormatConst.DD_MM_YY);
    return formatter.format(this);
  }

  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateYYYYmmdd() {
    final formatter = DateFormat(DateFormatConst.yyyy_MM_dd);
    return formatter.format(this);
  }

  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd_HH_mm] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateYYYYmmddHHmm() {
    final formatter = DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm);
    return formatter.format(this);
  }

  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd]+[DateFormatConst.HH_mm12Hour] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateddmmYYYYHHmmAMPM() {
    final formatter = DateFormat(DateFormatConst.DD_MM_YY);
    final timeInAMPM = DateFormat(DateFormatConst.HH_mm12Hour);
    return "${formatter.format(this)} ${timeInAMPM.format(this)}";
  }

  /*  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd]+[DateFormatConst.HH_mm_a] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateddmmYYYYHHmmAMPM() {
    final formatter = DateFormat("dd-MM-yyyy");
    final timeInAMPM = DateFormat(DateFormatConst.HH_mm_a);
    return "${formatter.format(this)} ${timeInAMPM.format(this)}";
  } */

  /// Formats the given [DateTime] object in the [DateFormatConst.HH_mm12Hour] format.
  ///
  /// Returns a string representing the formatted date.
  String formatTimeHHmmAMPM() {
    final formatter = DateFormat(DateFormatConst.HH_mm12Hour);
    return formatter.format(this);
  }

  /// Returns Time Ago
  String get timeAgoWithLocalization => formatTime(millisecondsSinceEpoch);
}

/// Splits a date string in the format "dd/mm/yyyy" into its constituent parts and returns a [DateTime] object.
///
/// If the input string is not a valid date format, this method returns `null`.
///
/// Example usage:
///
/// ```dart
/// DateTime? myDate = getDateTimeFromAboveFormat('27/04/2023');
/// if (myDate != null) {
///   print(myDate); // Output: 2023-04-27 00:00:00.000
/// }
/// ```
///
DateTime? getDateTimeFromAboveFormat(String date) {
  if (date.isValidDateTime) {
    return DateTime.tryParse(date);
  } else {
    List<String> dateParts = date.split('/');
    if (dateParts.length != 3) {
      debugPrint(
          'getDateTimeFromAboveFormat => Invalid date format => DATE: $date');
      return null;
    }
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    return DateTime.tryParse('$year-$month-$day');
  }
}

extension TimeExtension on TimeOfDay {
  /// Formats the given [TimeOfDay] object in the [DateFormatConst.HH_mm24Hour] format.
  ///
  /// Returns a string representing the formatted time.
  String formatTimeHHmm24Hour() {
    final timeIn24Hour = DateFormat(DateFormatConst.HH_mm24Hour);
    final tempDateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
    return timeIn24Hour.format(tempDateTime);
  }

  /// Formats the given [TimeOfDay] object in the [DateFormatConst.yyyy_MM_dd]+[DateFormatConst.HH_mm12Hour] format.
  ///
  /// Returns a string representing the formatted time.
  String formatTimeHHmmAMPM() {
    final timeInAMPM = DateFormat(DateFormatConst.HH_mm12Hour);
    final tempDateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
    return timeInAMPM.format(tempDateTime);
  }
}

TextStyle get appButtonTextStyleGray => secondaryTextStyle(
    color: secondaryColor,
    size: 14,
    fontFamily:
        GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500).fontFamily);
TextStyle get appButtonTextStyleWhite => secondaryTextStyle(
    color: Colors.white,
    size: 14,
    fontFamily:
        GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600).fontFamily);
TextStyle get appButtonPrimaryColorText => secondaryTextStyle(
    color: primaryColor,
    fontFamily:
        GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500).fontFamily);
TextStyle get appButtonFontColorText => secondaryTextStyle(
    color: Colors.grey,
    size: 14,
    fontFamily:
        GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500).fontFamily);

InputDecoration inputDecoration(BuildContext context,
    {Widget? prefixIcon,
    BoxConstraints? prefixIconConstraints,
    Widget? suffixIcon,
    String? labelText,
    String? hintText,
    double? borderRadius,
    bool? filled,
    Color? fillColor}) {
  return InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    hintText: hintText,
    hintStyle:
        secondaryTextStyle(size: 12, fontFamily: fontFamilyFontWeight300),
    labelStyle:
        secondaryTextStyle(size: 12, fontFamily: fontFamilyFontWeight300),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    prefixIconConstraints: prefixIconConstraints,
    suffixIcon: suffixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: borderColor, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: borderColor, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: borderColor, width: 0.0),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: primaryColor, width: 0.0),
    ),
    filled: filled,
    fillColor: fillColor,
  );
}

InputDecoration inputDecorationWithOutBorder(BuildContext context,
    {Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
    String? hintText,
    double? borderRadius,
    bool? filled,
    Color? fillColor}) {
  return InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    hintText: hintText,
    hintStyle:
        secondaryTextStyle(size: 12, fontFamily: fontFamilyFontWeight300),
    labelStyle:
        secondaryTextStyle(size: 12, fontFamily: fontFamilyFontWeight300),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: primaryColor, width: 0.0),
    ),
    filled: filled,
    fillColor: fillColor,
  );
}

Future<List<PlatformFile>> pickFiles(
    {FileType type = FileType.any, required BuildContext context}) async {
  List<PlatformFile> filePath0 = [];

  try {
    final ImageSource? source = await showImageSourceOptions(context);

    if (source != null) {
      final ImagePicker _picker = ImagePicker();
      final XFile? photo = await _picker.pickImage(source: source);

      if (photo != null) {
        File file = File(photo.path);
        filePath0.add(PlatformFile(
          path: file.path,
          name: file.uri.pathSegments.last,
          size: await file.length(),
          bytes: await file.readAsBytes(),
        ));
      }
    } else {
      FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
        type: type,
        allowMultiple: true,
        withData: true,
        onFileLoading: (FilePickerStatus status) => print(status.toString()),
      );

      if (filePickerResult != null) {
        filePath0.addAll(filePickerResult.files);
      }
    }
  } on PlatformException catch (e) {
    print('Unsupported operation: $e');
  } catch (e) {
    print(e.toString());
  }

  return filePath0;
}

Widget backButton({Object? result}) {
  return IconButton(
    onPressed: () {
      Get.back(result: result);
    },
    icon: const Icon(Icons.arrow_back_ios_new_outlined,
        color: Colors.grey, size: 20),
  );
}

class CommonAppBar extends StatelessWidget {
  final String title;
  final Widget? action;
  final bool hasLeadingWidget;
  final Widget? leadingWidget;
  const CommonAppBar({
    super.key,
    required this.title,
    this.hasLeadingWidget = true,
    this.leadingWidget,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leadingWidget ??
            (hasLeadingWidget
                ? backButton()
                : const SizedBox(
                    height: 48,
                    width: 16,
                  )),
        8.width,
        Text(
          title,
          style: primaryTextStyle(size: 18),
        ),
        const Spacer(),
        action ?? const SizedBox(),
        8.width,
      ],
    );
  }
}

extension WidgetExt on Widget? {
  Container shadow() {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: this);
  }
}

extension StrEtx on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 14,
      width: size ?? 14,
      fit: fit ?? BoxFit.cover,
      color: color ?? (isDarkMode.value ? Colors.white : darkGray),
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(Assets.iconsIcNoPhoto,
            height: size ?? 14, width: size ?? 14);
      },
    );
  }

  String get firstLetter => isNotEmpty ? this[0] : '';
}

void ifNotTester(VoidCallback callback) {
  if (loginUserData.value.email != Constants.DEFAULT_EMAIL) {
    callback.call();
  } else {
    toast(locale.value.demoUserCannotBeGrantedForThis);
  }
}

void doIfLoggedIn(BuildContext context, VoidCallback callback) async {
  if (isLoggedIn.value) {
    callback.call();
  } else {
    bool? res = await Get.to(() => SignInScreen());
    debugPrint('doIfLoggedIn RES: $res');

    if (res ?? false) {
      callback.call();
    }
  }
}

void showNewUpdateDialog(BuildContext context,
    {required int currentAppVersionCode}) async {
  showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    barrierDismissible:
        currentAppVersionCode >= appConfigs.value.minimumForceUpdateCode,
    builder: (_) {
      return WillPopScope(
        onWillPop: () {
          return Future(() =>
              currentAppVersionCode >= appConfigs.value.minimumForceUpdateCode);
        },
        child: NewUpdateDialog(
            canClose: currentAppVersionCode >=
                appConfigs.value.minimumForceUpdateCode),
      );
    },
  );
}

Future<void> showForceUpdateDialog(BuildContext context) async {
  getPackageInfo().then((value) {
    if (isAndroid &&
        appConfigs.value.latestVersionUpdateCode >
            value.versionCode.validate().toInt()) {
      showNewUpdateDialog(context,
          currentAppVersionCode: value.versionCode.validate().toInt());
    }
  });
}

Color getRatingColor(int rating) {
  if (rating == 1 || rating == 2) {
    return ratingBarColor;
  } else if (rating == 3) {
    return const Color(0xFFff6200);
  } else if (rating == 4 || rating == 5) {
    return const Color(0xFF73CB92);
  } else {
    return ratingBarColor;
  }
}

Widget actionsWidget({required Widget widget, VoidCallback? onTap}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: boxDecorationWithShadow(
        boxShape: BoxShape.circle, backgroundColor: cardColor),
    child: widget,
  ).onTap(() {
    onTap?.call();
  },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent);
}

Widget detailWidget(
    {required String title, required String value, Color? textColor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: secondaryTextStyle()).expand(),
      Text(value,
              textAlign: TextAlign.right,
              style: primaryTextStyle(size: 12, color: textColor))
          .expand(),
    ],
  ).paddingBottom(10).visible(value.isNotEmpty);
}

Widget detailWidgetPrice(
    {required String title,
    required num value,
    Color? textColor,
    bool isSemiBoldText = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: secondaryTextStyle()),
      PriceWidget(
        price: value,
        color: textColor ?? black,
        size: 12,
        isSemiBoldText: isSemiBoldText,
      )
    ],
  ).paddingBottom(10);
}

Future<ImageSource?> showImageSourceOptions(BuildContext context) async {
  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.camera,
                color: primaryColor,
              ),
              title: Text(
                'Camera',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: Icon(
                Icons.image,
                color: primaryColor,
              ),
              title: Text(
                'Gallery',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      );
    },
  );
}
