// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/cached_image_widget.dart';
import 'package:pawlly/screens/home/blog/blog_list_screen.dart';
import 'package:pawlly/screens/home/event/event_list_screen.dart';
import 'package:pawlly/utils/app_common.dart';

import '../../../components/app_scaffold.dart';
import '../../../generated/assets.dart';
import '../../../locale/app_localizations.dart';
import '../../../locale/languages.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/local_storage.dart';
import '../model/theme_mode_data_model.dart';
import '../password/change_password_screen.dart';
import 'about_us_screen.dart';
import 'settings_controller.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () {
          // Get.back(result: true);
          return Future(() => true);
        },
        child: AppScaffold(
          appBartitleText: locale.value.settings,
          hasLeadingWidget: isLoggedIn.value,
          leadingWidget: isLoggedIn.value
              ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_outlined,
                      color: Colors.grey, size: 20),
                )
              : null,
          body: Column(
            children: [
              commonDivider,
              8.height,
              Obx(
                () => SettingItemWidget(
                  title: locale.value.language,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  titleTextStyle: primaryTextStyle(),
                  leading: commonLeadingWid(
                    imgPath: Assets.iconsIcLanguage,
                    icon: Icons.language_outlined,
                    color: secondaryColor,
                  ),
                  trailing: DropdownButtonHideUnderline(
                    child: Container(
                      decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton(
                        elevation: 1,
                        dropdownColor: context.cardColor,
                        borderRadius: BorderRadius.circular(defaultRadius),
                        items: localeLanguageList.map((element) {
                          return DropdownMenuItem(
                            value: element,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (element.flag != null)
                                  CachedImageWidget(
                                    url: element.flag.validate(),
                                    height: 24,
                                    width: 24,
                                  ),
                                6.width,
                                if (element.name != null)
                                  Text(element.name.validate(),
                                      style: primaryTextStyle(size: 14)),
                              ],
                            ).paddingSymmetric(horizontal: 12),
                          );
                        }).toList(),
                        onChanged: (newValue) async {
                          if (newValue is LanguageDataModel) {
                            settingsController.selectedLang(newValue);
                            settingsController.isLoading(true);
                            await setValue(
                                SELECTED_LANGUAGE_CODE, newValue.languageCode);
                            selectedLanguageDataModel = newValue;
                            settingsController.selectedLang(newValue);
                            BaseLanguage temp = await const AppLocalizations()
                                .load(Locale(newValue.languageCode.validate()));
                            locale = temp.obs;
                            setValueToLocal(SELECTED_LANGUAGE_CODE,
                                newValue.languageCode.validate());
                            selectedLanguageCode(newValue.languageCode!);
                            updateUi(true);
                            updateUi(false);
                            Get.updateLocale(
                                Locale(newValue.languageCode.validate()));
                            settingsController.isLoading(false);
                          }
                        },
                        value: settingsController.selectedLang.value.id
                                    .validate() >
                                0
                            ? settingsController.selectedLang.value
                            : localeLanguageList.first,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => SettingItemWidget(
                  title: locale.value.appTheme,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  titleTextStyle: primaryTextStyle(),
                  leading: commonLeadingWid(
                      imgPath: Assets.iconsIcDarkMode,
                      icon: Icons.dark_mode_outlined,
                      color: secondaryColor),
                  trailing: DropdownButtonHideUnderline(
                    child: Container(
                      decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton(
                        elevation: 1,
                        dropdownColor: context.cardColor,
                        borderRadius: BorderRadius.circular(defaultRadius),
                        items: settingsController.themeModes.map((element) {
                          return DropdownMenuItem(
                            value: element,
                            child: Text(element.mode,
                                    style: primaryTextStyle(size: 13))
                                .paddingSymmetric(horizontal: 12),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue is ThemeModeData) {
                            settingsController.dropdownValue(newValue);
                            toggleThemeMode(
                                themeId:
                                    settingsController.dropdownValue.value.id);
                          }
                        },
                        value: !settingsController
                                .dropdownValue.value.id.isNegative
                            ? settingsController.dropdownValue.value
                            : settingsController.themeModes.first,
                      ),
                    ),
                  ),
                ),
              ),
          
          
              // SettingItemWidget(
              //   title: locale.value.upcomingEvents,
              //   onTap: () {
              //     Get.to(() => EventListScreen());
              //   },
              //   titleTextStyle: primaryTextStyle(),
              //   leading: const Icon(
              //     Icons.event,
              //     color: secondaryColor,
              //   ), //  commonLeadingWid(
              //   //     imgPath: Assets.iconsIcLock,
              //   //     icon: Icons.event_available_outlined,
              //   //     color: primaryColor),
              // ),
              // SettingItemWidget(
              //   title: locale.value.blogs,
              //   onTap: () {
              //     Get.to(() => BlogListScreen());
              //   },
              //   titleTextStyle: primaryTextStyle(),
              //   leading: const Icon(
              //     Icons.book_outlined,
              //     color: secondaryColor,
              //   ),
              //   //  commonLeadingWid(
              //   //     imgPath: Assets.iconsIcLock,
              //   //     icon: Icons.lock_outline_sharp,
              //   //     color: primaryColor),
              // ),
              SettingItemWidget(
                title: locale.value.changePassword,
                onTap: () {
                  Get.to(() => ChangePassword());
                },
                titleTextStyle: primaryTextStyle(),
                leading: commonLeadingWid(
                    imgPath: Assets.iconsIcLock,
                    icon: Icons.lock_outline_sharp,
                    color: secondaryColor),
              ).visible(isLoggedIn.value),
              SettingItemWidget(
                title: locale.value.deleteAccount,
                onTap: () {
                  ifNotTester(() async {
                    if (await isNetworkAvailable()) {
                      showConfirmDialogCustom(
                        context,
                        negativeText: locale.value.cancel,
                        positiveText: locale.value.delete,
                        onAccept: (_) {
                          settingsController.handleDeleteAccountClick();
                        },
                        dialogType: DialogType.DELETE,
                        title: locale.value.deleteAccountConfirmation,
                      );
                    } else {
                      toast(locale.value.yourInternetIsNotWorking);
                    }
                  });
                },
                titleTextStyle: primaryTextStyle(),
                leading: commonLeadingWid(
                    imgPath: Assets.iconsIcDelete,
                    icon: Icons.lock_outline_sharp,
                    color: secondaryColor),
              ).visible(isLoggedIn.value),
              SettingItemWidget(
                title: locale.value.rateApp,
                splashColor: transparentColor,
                onTap: () {
                  //    handleRate();
                },
                titleTextStyle: primaryTextStyle(),
                leading: commonLeadingWid(
                    imgPath: Assets.profileIconsIcStarOutlined,
                    icon: Icons.star_outline_rounded,
                    color: secondaryColor),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              ).visible(!isLoggedIn.value),
              SettingItemWidget(
                title: locale.value.aboutApp,
                splashColor: transparentColor,
                onTap: () {
                  Get.to(() => const AboutScreen());
                },
                titleTextStyle: primaryTextStyle(),
                leading: commonLeadingWid(
                    imgPath: Assets.profileIconsIcInfoOutlined,
                    icon: Icons.info_outline_rounded,
                    color: secondaryColor),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              ).visible(!isLoggedIn.value),
              SettingItemWidget(
                title: locale.value.signIn,
                onTap: () {
                  doIfLoggedIn(context, () {});
                },
                titleTextStyle: primaryTextStyle(),
                leading: commonLeadingWid(
                    imgPath: Assets.iconsIcLogin,
                    icon: Icons.login,
                    color: secondaryColor),
              ).visible(!isLoggedIn.value),
              /* Obx(
                  () => isLoggedIn.value
                      ? SettingSection(
                          title: Text(locale.value.dangerZone, style: boldTextStyle(color: redColor)),
                          headingDecoration: BoxDecoration(color: redColor.withOpacity(0.08)),
                          divider: const Offstage(),
                          items: [
                            8.height,
                            SettingItemWidget(
                              leading: Assets.iconsIcDeleteAccount.iconImage(size: 18),
                              paddingBeforeTrailing: 4,
                              title: locale.value.deleteAccount,
                              onTap: () {
                                showConfirmDialogCustom(
                                  context,
                                  negativeText: locale.value.cancel,
                                  positiveText: locale.value.delete,
                                  onAccept: (_) {
                                    settingsController.handleDeleteAccountClick();
                                  },
                                  dialogType: DialogType.DELETE,
                                  title: locale.value.deleteAccountConfirmation,
                                );
                              },
                            ).paddingOnly(left: 4),
                          ],
                        )
                      : const Offstage(),
                ), */
            ],
          ).visible(!updateUi.value),
        ),
      ),
    );
  }
}
