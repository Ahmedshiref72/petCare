import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/utils/app_common.dart';
import '../../../main.dart';
import '../../../models/employee_review_data.dart';
import '../model/booking_data_model.dart';
import '../../dashboard/dashboard_res_model.dart';
import '../services/booking_service_apis.dart';
import '../model/facilities_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';

class BookingDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasReview = false.obs;
  RxBool showWriteReview = false.obs;
  Rx<EmployeeReviewData> yourReview = EmployeeReviewData().obs;

  TextEditingController paymentMethod = TextEditingController();
  RxDouble selectedRating = (0.0).obs;
  TextEditingController reviewCont = TextEditingController();
  Rx<BookingDataModel> bookingArgumentData = BookingDataModel(service: SystemService(), payment: PaymentDetails(), training: Training()).obs;
  Rx<BookingDataModel> bookingDetail = BookingDataModel(service: SystemService(), payment: PaymentDetails(), training: Training()).obs;

  //Get Facility List
  RxList<FacilityModel> facilities = RxList();

  int rating = 0;

  @override
  void onInit() {
    // getFacilityList();
    if (Get.arguments is BookingDataModel) {
      bookingArgumentData(Get.arguments as BookingDataModel);
      bookingDetail(bookingArgumentData.value);
    }
    getBookingDetail(bookingId: bookingArgumentData.value.id);
    super.onInit();
  }

  ///Get Booking Detail
  getBookingDetail({required int bookingId, bool showLoader = true}) {
    if (showLoader) {
      isLoading(true);
    }
    BookingServiceApis.getBookingDetail(bookingId: bookingId).then((value) {
      bookingDetail(value.data);
      bookingDetail.value.id = bookingArgumentData.value.id;
      facilities(bookingDetail.value.additionalFacility);
      hasReview(value.customerReview != null);
      if (value.customerReview != null) {
        yourReview(value.customerReview);
      }
      isLoading(false);
    }).onError((error, stackTrace) {
      isLoading(false);
      toast(error.toString());
    });
  }

  deleteReviewHandleClick() {
    showConfirmDialogCustom(
      getContext,
      primaryColor: primaryColor,
      negativeText: locale.value.cancel,
      positiveText: locale.value.yes,
      onAccept: (_) {
        deleteReview();
      },
      dialogType: DialogType.DELETE,
      title: "Do you want to remove this review?",
    );
  }

  saveReview() async {
    isLoading(true);
    hideKeyBoardWithoutContext();

    Map<String, dynamic> req = {
      "id": yourReview.value.id.isNegative ? "" : yourReview.value.id,
      "employee_id": bookingDetail.value.employeeId,
      "rating": selectedRating.value,
      "review_msg": reviewCont.text.trim(),
    };

    await BookingServiceApis.updateReview(request: req).then((value) async {
      debugPrint('updateReview: ${value.toJson()}');
      showWriteReview(false);
      hasReview(true);
      yourReview(EmployeeReviewData(
        rating: selectedRating.value,
        userId: loginUserData.value.id,
        reviewMsg: reviewCont.text.trim(),
        username: loginUserData.value.userName,
        employeeId: bookingDetail.value.employeeId,
      ));
      getBookingDetail(bookingId: bookingArgumentData.value.id);
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void handleEditReview() {
    showWriteReview(true);
    reviewCont.text = yourReview.value.reviewMsg;
    selectedRating(yourReview.value.rating.toDouble());
  }

  void showReview() {
    showWriteReview(false);
  }

  deleteReview() async {
    isLoading(true);
    await BookingServiceApis.deleteReview(id: yourReview.value.id).then((value) async {
      debugPrint('updateReview: ${value.toJson()}');
      showWriteReview(false);
      hasReview(false);
      reviewCont.text = "";
      selectedRating(0);
      yourReview(EmployeeReviewData());
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }
}

Color getRatingBarColor(num starNumber) {
  // if (starNumber <= rating) {
  if (starNumber >= 3.6 || starNumber >= 5) {
    return ratingFirstColor;
  } else if (starNumber >= 3) {
    return ratingSecondColor;
  } else if (starNumber >= 2) {
    return ratingFifthColor;
  } else if (starNumber >= 1) {
    return ratingThirdColor;
  }
  return ratingFourthColor;
}
