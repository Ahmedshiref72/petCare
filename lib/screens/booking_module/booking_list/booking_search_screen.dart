import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/loader_widget.dart';
import '../../../components/search_booking_widget.dart';
import '../../../main.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'booking_card.dart';
import 'bookings_controller.dart';

class BookingSearchScreen extends StatelessWidget {
  final BookingsController bookingsController = BookingsController();
  BookingSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      bookingsController.page(1);
      bookingsController.getBookingList(showloader: false);
    } catch (e) {
      debugPrint('handleSearch E: $e');
    }
    return AppScaffold(
      appBartitleText: locale.value.searchBookings,
      isLoading: bookingsController.isLoading,
      body: SizedBox(
        height: Get.height,
        child: Obx(
          () => Column(
            children: [
              8.height,
              SearchBookingWidget(
                bookingsController: bookingsController,
                onFieldSubmitted: (p0) {
                  bookingsController.isLoading(true);
                  bookingsController.isSearchText(bookingsController.searchCont.text.trim().isNotEmpty);
                  bookingsController.page(1);
                  bookingsController.getBookingList();
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              SnapHelperWidget(
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
              ).expand(),
            ],
          ),
        ),
      ),
    );
  }
}
