import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/home/home_controller.dart';
import 'package:pawlly/screens/shop/shop_dashboard/shop_dashboard_controller.dart';
import 'package:pawlly/utils/app_common.dart';

import '../../components/app_scaffold.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);
  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: locale.value.pressBackAgainToExitApp,
      child: AppScaffold(
        hideAppBar: true,
        body: Obx(() =>
            dashboardController.screen[dashboardController.currentIndex.value]),
        bottomNavBar: Obx(
          () => NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: context.cardColor,
              indicatorColor: primaryColor.withOpacity(0.1),
              labelTextStyle:
                  MaterialStateProperty.all(primaryTextStyle(size: 12)),
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: NavigationBar(
              selectedIndex: dashboardController.currentIndex.value,
              onDestinationSelected: (v) {
                if (!isLoggedIn.value && v == 1) {
                  doIfLoggedIn(context, () {
                    dashboardController.currentIndex(v);
                  });
                } else {
                  dashboardController.currentIndex(v);
                }
                try {
                  if (v == 0) {
                    HomeScreenController hCont = Get.find();
                    hCont.getDashboardDetail(isFromSwipRefresh: true);
                  } else if (v == 2) {
                    ShopDashboardController sCont = Get.find();
                    sCont.init();
                  }
                } catch (e) {
                  debugPrint('onItemSelected Err: $e');
                }
              },
              destinations: [
                tab(
                  iconData: Assets.navigationIcHomeOutlined
                      .iconImage(color: darkGray, size: 22),
                  activeIconData: Assets.navigationIcHomeFilled
                      .iconImage(color: primaryColor, size: 22),
                  tabName: locale.value.home,
                ),
                tab(
                  iconData: Assets.navigationIcCalendarOutlined
                      .iconImage(color: darkGray, size: 22),
                  activeIconData: Assets.navigationIcCalenderFilled
                      .iconImage(color: primaryColor, size: 22),
                  tabName: locale.value.bookings,
                ),
                tab(
                  iconData: Assets.navigationIcShopOutlined
                      .iconImage(color: darkGray, size: 22),
                  activeIconData: Assets.navigationIcShopFilled
                      .iconImage(color: primaryColor, size: 22),
                  tabName: locale.value.shop,
                ),
                tab(
                  iconData: (isLoggedIn.value
                          ? Assets.navigationIcUserOutlined
                          : Assets.profileIconsIcSettingOutlined)
                      .iconImage(color: darkGray, size: 22),
                  activeIconData: isLoggedIn.value
                      ? Assets.navigationIcUserFilled
                          .iconImage(color: primaryColor, size: 22)
                      : Icon(
                          Icons.settings,
                          color: primaryColor,
                          size: 22,
                        ),
                  tabName: isLoggedIn.value
                      ? locale.value.profile
                      : locale.value.settings,
                ),
              ],
            ),
          ).visible(!updateUi.value),
        ),
      ),
    );
  }

  NavigationDestination tab(
      {required Widget iconData,
      required Widget activeIconData,
      required String tabName}) {
    return NavigationDestination(
      icon: iconData,
      selectedIcon: activeIconData,
      label: tabName,
    );
  }
}
