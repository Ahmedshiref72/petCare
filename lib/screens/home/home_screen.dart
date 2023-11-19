import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/dashboard/dashboard_res_model.dart';
import 'package:pawlly/screens/home/blog/blog_home_component.dart';
import 'package:pawlly/screens/home/event/event_list_screen.dart';
import 'package:pawlly/screens/home/event/your_events_components.dart';
import 'package:pawlly/screens/pet/my_pets_controller.dart';
import 'package:pawlly/utils/common_base.dart';

import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/empty_error_state_widget.dart';
import '../../utils/view_all_label_component.dart';
import '../auth/other/notification_screen.dart';
import '../shop/shop_dashboard/model/product_status_model.dart';
import '../shop/shop_dashboard/product_list_screen.dart';
import 'components/choose_service_components.dart';
import 'components/featured_product__home_component.dart';
import 'components/sliders_component.dart';
import 'components/upcoming_appointment_components.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      isLoading: homeScreenController.isLoading,
      body: RefreshIndicator(
        onRefresh: () async {
          homeScreenController.getDashboardDetail(isFromSwipRefresh: true);
          return await Future.delayed(const Duration(seconds: 2));
        },
        child: Obx(
          () => SnapHelperWidget(
            future: homeScreenController.getDashboardDetailFuture.value,
            initialData: homeScreenController
                    .dashboardData.value.systemService.isEmpty
                ? null
                : DashboardRes(data: homeScreenController.dashboardData.value),
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  homeScreenController.init();
                },
              ).paddingSymmetric(horizontal: 16);
            },
            loadingWidget: const LoaderWidget(),
            onSuccess: (dashboardData) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: GestureDetector(
                  onTap: () => hideKeyboard(context),
                  behavior: HitTestBehavior.translucent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      32.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              16.height,
                              Obx(
                                () => Text(
                                  '${locale.value.hello}, ${loginUserData.value.userName.isNotEmpty ? loginUserData.value.userName : locale.value.guest} 👋',
                                  style: primaryTextStyle(size: 20),
                                ),
                              ),
                              4.height,
                              Obx(
                                () => Text(
                                  '${locale.value.howS} $randomPetName ${locale.value.healthGoingOn}',
                                  style: secondaryTextStyle(),
                                ).visible(randomPetName.isNotEmpty),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Get.to(() => NotificationScreen());
                            },
                            icon: Assets.iconsIcUnselectedBell
                                .iconImage(color: darkGray, size: 24),
                          ).paddingTop(16).visible(isLoggedIn.value),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SlidersComponent(),
                            Obx(() => ChooseServiceComponents().visible(
                                homeScreenController.dashboardData.value
                                    .systemService.isNotEmpty)),
                            Obx(() => UpcomingAppointmentComponents().visible(
                                !homeScreenController.isRefresh.value &&
                                    homeScreenController.dashboardData.value
                                            .upcommingBooking.id >
                                        0)),
                            /*   PetStoreComponents(),*/
                            16.height,
                            ViewAllLabel(
                              label: locale.value.featuredProducts,
                              list: homeScreenController
                                  .dashboardData.value.featuresProduct,
                              onTap: () {
                                Get.to(
                                    () => ProductListScreen(
                                        title: locale.value.featuredProducts),
                                    arguments:
                                        ProductStatusModel(isFeatured: "1"));
                              },
                            ).paddingOnly(left: 16, right: 8).visible(
                                homeScreenController.dashboardData.value
                                    .featuresProduct.isNotEmpty),
                            Obx(
                              () => FeaturedProductsHomeComponent(
                                      homeScreenController:
                                          homeScreenController,
                                      isFromWishList: false)
                                  .paddingOnly(
                                    top: 10,
                                    left: 16,
                                    right: 16,
                                    bottom: 16,
                                  )
                                  .visible(homeScreenController.dashboardData
                                      .value.featuresProduct.isNotEmpty),
                            ),
                            16.height,
                            ViewAllLabel(
                              label: locale.value.upcomingEvents,
                              onTap: () {
                                Get.to(() => EventListScreen());
                              },
                            ).visible(homeScreenController.dashboardData.value.event.isNotEmpty).paddingOnly(left: 16, right: 8),
                            
                            Obx(() => YourEventsComponents(
                                  events: homeScreenController.dashboardData.value.event,
                                ).visible(homeScreenController.dashboardData.value.event.isNotEmpty)),

                            Obx(() => BlogHomeComponent().visible(homeScreenController.dashboardData.value.blog.isNotEmpty)),

                          ],
                        ).visible(!homeScreenController.isLoading.value),
                      ),
                      Obx(
                        () => NoDataWidget(
                          title: locale.value.noDashboardData,
                          subTitle: "${locale.value.thereIsSomethingMight}!",
                          titleTextStyle: primaryTextStyle(),
                          imageWidget: const EmptyStateWidget(),
                          retryText: locale.value.reload,
                          onRetry: () {
                            homeScreenController.init();
                          },
                        ).paddingSymmetric(horizontal: 32).visible(
                            !homeScreenController.isLoading.value &&
                                dashboardData.data.systemService.isEmpty),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String get randomPetName {
    try {
      if (myPetsScreenController.myPets.isNotEmpty) {
        return myPetsScreenController
            .myPets[Random().nextInt(myPetsScreenController.myPets.length)]
            .name;
      } else {
        return "";
      }
    } catch (e) {
      debugPrint('randomPetName E: $e');
      return "";
    }
  }
}
