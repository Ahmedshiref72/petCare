import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/cached_image_widget.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/locale/app_localizations.dart';
import 'package:pawlly/locale/languages.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/screens/auth/other/settings_controller.dart';
import 'package:pawlly/utils/app_common.dart';
import 'package:pawlly/utils/colors.dart';
import 'package:pawlly/utils/common_base.dart';
import 'package:pawlly/utils/local_storage.dart';

class ChangeLanguageScreen extends StatelessWidget {
  final Function onLanguageSelected;

  ChangeLanguageScreen({required this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(title: Text(locale.value.chooseLanguage)),
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingItemWidget(
              title: '',
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              titleTextStyle: primaryTextStyle(),
              leading: commonLeadingWid(
                imgPath: Assets.iconsIcLanguage,
                icon: Icons.language_outlined,
                color: primaryColor,
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
                    value:
                        settingsController.selectedLang.value.id.validate() > 0
                            ? settingsController.selectedLang.value
                            : localeLanguageList.first,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 120),
              child: ElevatedButton(
                onPressed: () => onLanguageSelected(),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFf39231), // Button color
                  onPrimary: Colors.white, // Text color
                ),
                child: Text(locale.value.next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
