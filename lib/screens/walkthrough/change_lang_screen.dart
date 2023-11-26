import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/cached_image_widget.dart';
import 'package:pawlly/locale/app_localizations.dart';
import 'package:pawlly/locale/languages.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/screens/auth/other/settings_controller.dart';
import 'package:pawlly/utils/app_common.dart';
import 'package:pawlly/utils/colors.dart';
import 'package:pawlly/utils/local_storage.dart';

class ChangeLanguageScreen extends StatelessWidget {
  final Function onLanguageSelected;

  ChangeLanguageScreen({required this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.put(SettingsController());

    List<LanguageDataModel> filteredLanguageList = localeLanguageList
        .where((lang) => lang.languageCode == 'en' || lang.languageCode == 'ar')
        .toList();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: 600), // For better layout on large screens
              child: GridView.builder(
                shrinkWrap: true, // Make GridView take minimum space
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: filteredLanguageList.length,
                itemBuilder: (context, index) {
                  final element = filteredLanguageList[index];
                  return LanguageItem(
                    key: ValueKey(element.id), // Unique key for each item
                    element: element,
                    isSelected:
                        settingsController.selectedLang.value.id == element.id,
                    onSelect: () async {
                      await _onLanguageSelected(
                          element, settingsController, context);
                    },
                  );
                },
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          color: context.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: ElevatedButton(
              onPressed: () => onLanguageSelected(),
              style: ElevatedButton.styleFrom(
                primary: primaryColor, // Button color
                onPrimary: Colors.white, // Text color
              ),
              child: Text(locale.value.next),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLanguageSelected(LanguageDataModel newValue,
      SettingsController settingsController, BuildContext context) async {
    if (settingsController.selectedLang.value.id != newValue.id) {
      settingsController.selectedLang(newValue);
      settingsController.isLoading(true);
      await setValue(SELECTED_LANGUAGE_CODE, newValue.languageCode);
      selectedLanguageDataModel = newValue;
      settingsController.selectedLang(newValue);
      BaseLanguage temp = await const AppLocalizations()
          .load(Locale(newValue.languageCode.validate()));
      locale = temp.obs;
      setValueToLocal(SELECTED_LANGUAGE_CODE, newValue.languageCode.validate());
      selectedLanguageCode(newValue.languageCode!);
      updateUi(true);
      updateUi(false);
      Get.updateLocale(Locale(newValue.languageCode.validate()));
      settingsController.isLoading(false);
    }
  }
}

class LanguageItem extends StatelessWidget {
  final LanguageDataModel element;
  final bool isSelected;
  final VoidCallback onSelect;

  const LanguageItem({
    Key? key,
    required this.element,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (element.flag != null)
              CachedImageWidget(
                url: element.flag.validate(),
                height: 48,
                width: 48,
              ),
            SizedBox(width: 10),
            if (element.name != null)
              Text(
                element.name.validate(),
                style: primaryTextStyle(size: 18),
              ),
          ],
        ),
      ),
    );
  }
}
