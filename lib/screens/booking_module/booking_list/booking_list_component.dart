/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/booking_module/model/booking_data_model.dart';

import '../../../../components/loader_widget.dart';
import '../../../../main.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../home/blog/blog_controller.dart';
import '../../home/model/status_list_res.dart';
import '../services/booking_service_apis.dart';
import 'booking_card.dart';

class BookingListComponent extends StatelessWidget {
  BookingListComponent({Key? key}) : super(key: key);
   final BlogController blogController = Get.put(BlogController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => SnapHelperWidget<List<BookingDataModel>>(
            future: future.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  page = 1;
                  isLoading(true);
                  ifilterByStatus               Future.delayed(const Duration(seconds: 3), () {
                    isLoading(false);
                  });
                },
              );
            },
            loadingWidget: const LoaderWidget(),
            onSuccess: (bookingList) {
              return AnimatedListView(
                shrinkWrap: true,
                itemCount: bookingList.length,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                emptyWidget: NoDataWidget(
                  title: locale.value.noBookingsFound,
                  imageWidget: const EmptyStateWidget(),
                  subTitle: locale.value.thereAreCurrentlyNo,
                  retryText: locale.value.reload,
                  onRetry: () {
                    page = 1;
                    isLoading(true);
                    init();
                    Future.delayed(const Duration(seconds: 2), () {
                      isLoading(false);
                    });
                  },
                ).paddingSymmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return BookingCard(
                    appointment: bookingList[index],
                    onUpdateBooking: () {
                      bookingList.removeAt(index);
                      setState(() {});
                    },
                  );
                },
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    debugPrint('PAGE: $page');
                    isLoading(true);
                    init();
                    Future.delayed(const Duration(seconds: 2), () {
                      isLoading(false);
                    });
                  }
                },
                onSwipeRefresh: () async {
                  page = 1;
                  init();

                  return await Future.delayed(const Duration(seconds: 2));
                },
              );
            },
          ),
        ),
        Obx(() => const LoaderWidget().center().visible(isLoading.value)),
      ],
    );
  }
}
 */
