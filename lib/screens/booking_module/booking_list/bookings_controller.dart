import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/screens/home/home_controller.dart';
import 'package:pawlly/utils/common_base.dart';

import '../model/booking_data_model.dart';
import '../services/booking_service_apis.dart';
import '../../../utils/constants.dart';

class BookingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  Rx<Future<RxList<BookingDataModel>>> getBookings = Future(() => RxList<BookingDataModel>()).obs;
  RxList<BookingDataModel> bookings = RxList();
  RxInt page = 1.obs;
  RxSet<String> selectedStatus = RxSet();
  RxSet<String> selectedService = RxSet();
  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;
  TextEditingController fromDateCont = TextEditingController();
  TextEditingController toDateCont = TextEditingController();

  @override
  void onInit() {
    getBookingList();
    super.onInit();
  }

  getBookingList({bool showloader = true, String search = ""}) {
    if (showloader) {
      isLoading(true);
    }
    getBookings(BookingServiceApis.getBookingList(
      filterByStatus: selectedStatus.join(","),
      filterByService: selectedService.join(","),
      page: page.value,
      search: searchCont.text.trim(),
      bookings: bookings,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    )).whenComplete(() => isLoading(false));
  }

  updateBooking({required int bookingId, required String status, VoidCallback? onUpdateBooking}) async {
    isLoading(true);
    hideKeyBoardWithoutContext();

    Map<String, dynamic> req = {
      "id": bookingId,
      "status": BookingStatusConst.CANCELLED,
    };

    await BookingServiceApis.updateBooking(request: req).then((value) async {
      if (onUpdateBooking != null) {
        onUpdateBooking.call();
        toast(locale.value.bookingCancelSuccessfully);
      }
      try {
        HomeScreenController hCont = Get.find();
        hCont.init();
      } catch (e) {
        debugPrint('onItemSelected Err: $e');
      }
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }
}
