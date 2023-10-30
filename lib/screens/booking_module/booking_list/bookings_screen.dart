import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/booking_module/booking_list/booking_card.dart';

import '../../../components/app_scaffold.dart';
import '../../../components/bottom_selection_widget.dart';
import '../../../components/loader_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../services/service_navigation.dart';
import 'booking_search_screen.dart';
import 'bookings_controller.dart';
import '../../../main.dart';

class BookingsScreen extends StatelessWidget {
  BookingsScreen({Key? key}) : super(key: key);
  final BookingsController bookingsController = Get.put(BookingsController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.bookings,
      hasLeadingWidget: false,
      isLoading: bookingsController.isLoading,
      actions: [
        IconButton(
          onPressed: () async {
            doIfLoggedIn(context, () {
              hideKeyboard(context);
              Get.to(() => BookingSearchScreen());
            });
          },
          icon: commonLeadingWid(imgPath: Assets.iconsIcSearch, color: switchColor, icon: Icons.search_outlined, size: 22),
        ),
        IconButton(
          onPressed: () async {
            handleFilterClick(context);
          },
          icon: commonLeadingWid(imgPath: Assets.iconsIcFilter, color: switchColor, icon: Icons.filter_alt_outlined, size: 24),
        ),
      ],
      body: Obx(
        () => SnapHelperWidget(
          future: bookingsController.getBookings.value,
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                bookingsController.page(1);
                bookingsController.getBookingList();
              },
            ).paddingSymmetric(horizontal: 16);
          },
          loadingWidget: const LoaderWidget(),
          onSuccess: (booking) {
            return Obx(
              () => AnimatedListView(
                shrinkWrap: true,
                itemCount: booking.length,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                emptyWidget: NoDataWidget(
                  title: locale.value.noBookingsFound,
                  imageWidget: const EmptyStateWidget(),
                  subTitle: locale.value.thereAreCurrentlyNo,
                  retryText: locale.value.reload,
                  onRetry: () {
                    bookingsController.page(1);
                    bookingsController.isLoading(true);
                    bookingsController.getBookingList();
                  },
                ).paddingSymmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return BookingCard(
                    appointment: booking[index],
                    isFromHome: true,
                    onUpdateBooking: () {
                      booking.removeAt(index);
                    },
                  );
                },
                onNextPage: () async {
                  if (!bookingsController.isLastPage.value) {
                    bookingsController.page(bookingsController.page.value + 1);
                    bookingsController.getBookingList();
                  }
                },
                onSwipeRefresh: () async {
                  bookingsController.page(1);
                  bookingsController.getBookingList(showloader: false);
                  return await Future.delayed(const Duration(seconds: 2));
                },
              ),
            );
          },
        ),
      ).paddingTop(16),
    );
  }

  void handleFilterClick(BuildContext context) {
    doIfLoggedIn(context, () {
      serviceCommonBottomSheet(
        context,
        child: Obx(
          () => BottomSelectionSheet(
            heightRatio: 0.64,
            title: locale.value.filterBy,
            hideSearchBar: true,
            hintText: locale.value.searchForStatus,
            controller: TextEditingController(),
            hasError: false,
            isLoading: bookingsController.isLoading,
            isEmpty: allStatus.isEmpty,
            noDataTitle: locale.value.statusListIsEmpty,
            noDataSubTitle: locale.value.thereAreNoStatus,
            listWidget: statusListWid(context),
          ),
        ),
      );
    });
  }

  Widget statusListWid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.bookingStatus, style: secondaryTextStyle()),
        8.height,
        AnimatedWrap(
          runSpacing: 8,
          spacing: 6,
          itemCount: allStatus.length,
          listAnimationType: ListAnimationType.FadeIn,
          itemBuilder: (_, index) {
            return Obx(
              () => GestureDetector(
                onTap: () {
                  if (bookingsController.selectedStatus.contains(allStatus[index].status)) {
                    bookingsController.selectedStatus.remove(allStatus[index].status);
                  } else {
                    bookingsController.selectedStatus.add(allStatus[index].status);
                  }
                },
                child: Container(
                  width: Get.width / 3.71,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: boxDecorationDefault(
                    color: bookingsController.selectedStatus.contains(allStatus[index].status)
                        ? isDarkMode.value
                            ? primaryColor
                            : lightPrimaryColor
                        : isDarkMode.value
                            ? lightPrimaryColor2
                            : Colors.grey.shade100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        size: 14,
                        color: isDarkMode.value ? whiteColor : primaryColor,
                      ).visible(bookingsController.selectedStatus.contains(allStatus[index].status)),
                      4.width.visible(bookingsController.selectedStatus.contains(allStatus[index].status)),
                      Text(
                        getBookingStatus(status: allStatus[index].status),
                        style: secondaryTextStyle(
                          color: bookingsController.selectedStatus.contains(allStatus[index].status)
                              ? isDarkMode.value
                                  ? whiteColor
                                  : primaryColor
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        16.height,
        Text(locale.value.service, style: secondaryTextStyle()),
        8.height,
        AnimatedWrap(
          runSpacing: 8,
          spacing: 6,
          itemCount: serviceList.length,
          listAnimationType: ListAnimationType.FadeIn,
          itemBuilder: (_, index) {
            return Obx(
              () => GestureDetector(
                onTap: () {
                  if (bookingsController.selectedService.contains(serviceList[index].name)) {
                    bookingsController.selectedService.remove(serviceList[index].name);
                  } else {
                    bookingsController.selectedService.add(serviceList[index].name);
                  }
                },
                child: Container(
                  width: Get.width / 3.71,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: boxDecorationDefault(
                    color: bookingsController.selectedService.contains(serviceList[index].name)
                        ? isDarkMode.value
                            ? primaryColor
                            : lightPrimaryColor
                        : isDarkMode.value
                            ? lightPrimaryColor2
                            : Colors.grey.shade100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        size: 14,
                        color: isDarkMode.value ? whiteColor : primaryColor,
                      ).visible(bookingsController.selectedService.contains(serviceList[index].name)),
                      4.width.visible(bookingsController.selectedService.contains(serviceList[index].name)),
                      Text(
                        serviceList[index].name,
                        style: secondaryTextStyle(
                          color: bookingsController.selectedService.contains(serviceList[index].name)
                              ? isDarkMode.value
                                  ? whiteColor
                                  : primaryColor
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppButton(
              text: locale.value.clearFilter,
              textStyle: appButtonTextStyleGray,
              color: lightSecondaryColor,
              onTap: () {
                Get.back();
                bookingsController.selectedStatus.clear();
                bookingsController.selectedService.clear();
                bookingsController.page(1);
                bookingsController.getBookingList();
              },
            ).expand(),
            16.width,
            AppButton(
              text: locale.value.apply,
              textStyle: appButtonTextStyleWhite,
              onTap: () {
                if (bookingsController.selectedStatus.isEmpty && bookingsController.selectedService.isEmpty) {
                  toast(locale.value.pleaseSelectAnItem);
                } else {
                  Get.back();
                  bookingsController.page(1);
                  bookingsController.getBookingList();
                }
              },
            ).expand(),
          ],
        ),
      ],
    ).expand();
  }
}
