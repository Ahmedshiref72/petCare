import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/booking_module/payment_screen.dart';
import 'package:pawlly/utils/app_common.dart';
import 'package:pawlly/utils/empty_error_state_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/common_file_placeholders.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../payment_controller.dart';
import '../services/service_navigation.dart';
import 'booking_detail_controller.dart';

class BookingDetailScreen extends StatelessWidget {
  BookingDetailScreen({Key? key}) : super(key: key);
  final BookingDetailsController bookingController =
      Get.put(BookingDetailsController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: Hero(
        tag: '#${bookingController.bookingDetail.value.id}',
        child: Text(
          '#${bookingController.bookingDetail.value.id} - ${bookingController.bookingDetail.value.service.name}',
          style: primaryTextStyle(size: 16, decoration: TextDecoration.none),
        ),
      ),
      isLoading: bookingController.isLoading,
      body: RefreshIndicator(
        onRefresh: () async {
          bookingController.getBookingDetail(
              bookingId: bookingController.bookingDetail.value.id,
              showLoader: false);
          return await Future.delayed(const Duration(seconds: 2));
        },
        child: AnimatedScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Obx(
              () => bookingController.isLoading.value
                  ? const SizedBox()
                  : bookingController.bookingDetail.value.service.id.isNegative
                      ? NoDataWidget(
                          title: locale.value.noBookingDetailsFound,
                          imageWidget: const EmptyStateWidget(),
                          subTitle:
                              "${locale.value.thereAreCurrentlyNoDetails} \n${locale.value.bookingId} ${bookingController.bookingDetail.value.id}. ${locale.value.tryReloadOrCheckingLater}.",
                          retryText: locale.value.reload,
                          onRetry: () {
                            bookingController.getBookingDetail(
                                bookingId:
                                    bookingController.bookingDetail.value.id);
                          },
                        )
                          .paddingSymmetric(horizontal: 32)
                          .paddingTop(Get.height * 0.20)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            16.height,
                            Text(locale.value.customerInformation,
                                    style: primaryTextStyle())
                                .paddingSymmetric(horizontal: 16),
                            8.height,
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16),
                              decoration: boxDecorationDefault(
                                shape: BoxShape.rectangle,
                                color: context.cardColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (bookingController
                                      .bookingDetail.value.service.slug
                                      .contains(ServicesKeyConst.boarding)) ...[
                                    detailWidget(
                                        title: locale.value.dropOffDate,
                                        value: bookingController
                                                .bookingDetail
                                                .value
                                                .dropoffDateTime
                                                .isValidDateTime
                                            ? bookingController
                                                .bookingDetail
                                                .value
                                                .dropoffDateTime
                                                .dateInDMMMMyyyyFormat
                                            : ""),
                                    detailWidget(
                                        title: locale.value.dropOffTime,
                                        value: bookingController
                                                .bookingDetail
                                                .value
                                                .dropoffDateTime
                                                .isValidDateTime
                                            ? "At ${bookingController.bookingDetail.value.dropoffDateTime.timeInHHmmAmPmFormat}"
                                            : ""),
                                    detailWidget(
                                        title: locale.value.pickupDate,
                                        value: bookingController
                                                .bookingDetail
                                                .value
                                                .pickupDateTime
                                                .isValidDateTime
                                            ? bookingController
                                                .bookingDetail
                                                .value
                                                .pickupDateTime
                                                .dateInDMMMMyyyyFormat
                                            : ""),
                                    detailWidget(
                                        title: locale.value.pickupTime,
                                        value: bookingController
                                                .bookingDetail
                                                .value
                                                .pickupDateTime
                                                .isValidDateTime
                                            ? "At ${bookingController.bookingDetail.value.pickupDateTime.timeInHHmmAmPmFormat}"
                                            : ""),
                                  ],
                                  if (bookingController
                                      .bookingDetail.value.service.slug
                                      .contains(ServicesKeyConst.dayCare)) ...[
                                    detailWidget(
                                        title: locale.value.date,
                                        value: bookingController
                                                .bookingDetail
                                                .value
                                                .dayCareDate
                                                .isValidDateTime
                                            ? bookingController
                                                .bookingDetail
                                                .value
                                                .dayCareDate
                                                .dateInDMMMMyyyyFormat
                                            : ""),
                                    detailWidget(
                                      title: locale.value.dropOffTime,
                                      value: bookingController.bookingDetail
                                              .value.dropoffTime.isValidTime
                                          ? "At ${"1970-01-01 ${bookingController.bookingDetail.value.dropoffTime}".timeInHHmmAmPmFormat}"
                                          : "",
                                    ),
                                    detailWidget(
                                      title: locale.value.pickupTime,
                                      value: bookingController.bookingDetail
                                              .value.pickupTime.isValidTime
                                          ? "At ${"1970-01-01 ${bookingController.bookingDetail.value.pickupTime}".timeInHHmmAmPmFormat}"
                                          : "",
                                    ),
                                  ],
                                  if (!(bookingController
                                          .bookingDetail.value.service.slug
                                          .contains(
                                              ServicesKeyConst.boarding) ||
                                      bookingController
                                          .bookingDetail.value.service.slug
                                          .contains(
                                              ServicesKeyConst.dayCare))) ...[
                                    detailWidget(
                                        title: locale.value.date,
                                        value: bookingController
                                                .bookingDetail
                                                .value
                                                .serviceDateTime
                                                .isValidDateTime
                                            ? bookingController
                                                .bookingDetail
                                                .value
                                                .serviceDateTime
                                                .dateInDMMMMyyyyFormat
                                            : ""),
                                    detailWidget(
                                        title: locale.value.time,
                                        value: bookingController
                                                .bookingDetail
                                                .value
                                                .serviceDateTime
                                                .isValidDateTime
                                            ? "At ${bookingController.bookingDetail.value.serviceDateTime.timeInHHmmAmPmFormat}"
                                            : ""),
                                  ],
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(locale.value.petName,
                                          style: secondaryTextStyle()),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          CachedImageWidget(
                                            url: bookingController
                                                .bookingDetail.value.petImage,
                                            height: 20,
                                            width: 20,
                                            circle: true,
                                            radius: 20,
                                            fit: BoxFit.cover,
                                          ),
                                          8.width,
                                        ],
                                      ),
                                      Text(
                                          "${bookingController.bookingDetail.value.petName} (${bookingController.bookingDetail.value.breed})",
                                          textAlign: TextAlign.right,
                                          style: primaryTextStyle(size: 12)),
                                    ],
                                  ),
                                  8.height,
                                  detailWidget(
                                      title: locale.value.favoriteFood,
                                      value: bookingController.bookingDetail
                                              .value.food.isNotEmpty
                                          ? bookingController
                                              .bookingDetail.value.food.first
                                          : ""),
                                  detailWidget(
                                      title: locale.value.favoriteActivity,
                                      value: bookingController.bookingDetail
                                              .value.activity.isNotEmpty
                                          ? bookingController.bookingDetail
                                              .value.activity.first
                                          : ""),
                                  detailWidget(
                                      title: locale.value.reason,
                                      value: bookingController.bookingDetail
                                          .value.veterinaryReason),
                                  6.height,
                                ],
                              ),
                            ).paddingSymmetric(horizontal: 16),
                            32.height,
                            Text(locale.value.bookingInformation,
                                    style: primaryTextStyle())
                                .paddingSymmetric(horizontal: 16),
                            8.height,
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16),
                              decoration: boxDecorationDefault(
                                shape: BoxShape.rectangle,
                                color: context.cardColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  detailWidget(
                                      title: locale.value.service,
                                      value: bookingController.bookingDetail
                                          .value.veterinaryServiceName),
                                  detailWidget(
                                      title: locale.value.bookingStatus,
                                      value: getBookingStatus(
                                          status: bookingController
                                              .bookingDetail.value.status),
                                      textColor: getBookingStatusColor(
                                          status: bookingController
                                              .bookingDetail.value.status)),
                                  detailWidget(
                                      title: locale.value.paymentStatus,
                                      value: getBookingPaymentStatus(
                                          status: bookingController
                                              .bookingDetail
                                              .value
                                              .payment
                                              .paymentStatus
                                              .capitalizeFirstLetter()),
                                      textColor: getPriceStatusColor(
                                          paymentStatus: bookingController
                                              .bookingDetail
                                              .value
                                              .payment
                                              .paymentStatus)),
                                  detailWidget(
                                      title: locale.value.duration,
                                      value: bookingController
                                          .bookingDetail.value.duration
                                          .toFormattedDuration(
                                              showFullTitleHoursMinutes: true)),
                                  Row(
                                    children: [
                                      Text(
                                          getEmployeeRoleByServiceElement(
                                              appointment: bookingController
                                                  .bookingDetail.value),
                                          style: secondaryTextStyle()),
                                      const Spacer(),
                                      CachedImageWidget(
                                        url: bookingController
                                            .bookingDetail.value.employeeImage,
                                        height: 20,
                                        width: 20,
                                        circle: true,
                                        radius: 20,
                                        fit: BoxFit.cover,
                                      ),
                                      8.width,
                                      Text(
                                          bookingController
                                              .bookingDetail.value.employeeName,
                                          style: primaryTextStyle(size: 12)),
                                    ],
                                  ).visible(bookingController
                                      .bookingDetail.value.employeeName
                                      .trim()
                                      .isNotEmpty),
                                  8.height.visible(getAddressByServiceElement(
                                              appointment: bookingController
                                                  .bookingDetail.value)
                                          .isNotEmpty &&
                                      bookingController
                                          .bookingDetail.value.employeeName
                                          .trim()
                                          .isNotEmpty),
                                  detailWidget(
                                      title: locale.value.address,
                                      value: getAddressByServiceElement(
                                          appointment: bookingController
                                              .bookingDetail.value)),
                                  6.height,
                                ],
                              ),
                            ).paddingSymmetric(horizontal: 16),
                            additionalInfoWidget(context).visible(
                                bookingController
                                    .bookingDetail.value.note.isNotEmpty),
                            serviceInfoWidget(context).visible(bookingController
                                .bookingDetail.value.service.slug
                                .contains(ServicesKeyConst.training)),
                            Obx(() => medicalReportWidget()
                                .paddingSymmetric(horizontal: 16)
                                .visible(bookingController.bookingDetail.value
                                    .medicalReport.isNotEmpty)),
                            32.height,
                            Text(locale.value.paymentDetails,
                                    style: primaryTextStyle())
                                .paddingSymmetric(horizontal: 16),
                            8.height,
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16),
                              decoration: boxDecorationDefault(
                                shape: BoxShape.rectangle,
                                color: context.cardColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /* detailWidgetPrice(
                                    title: locale.value.price,
                                    value: bookingController.bookingDetail.value.price,
                                    textColor: textPrimaryColorGlobal,
                                  ),*/
                                  /// delete taxes
                                  /* ...List.generate(
                                    bookingController.bookingDetail.value.payment.taxs.length,
                                    (index) => detailWidgetPrice(
                                      title: bookingController.bookingDetail.value.payment.taxs[index].title,
                                      value: bookingController.bookingDetail.value.payment.taxs[index].value,
                                      textColor: isDarkMode.value ? textPrimaryColorGlobal : primaryColor,
                                      isSemiBoldText: true,
                                    ),
                                  ),*/
                                  detailWidgetPrice(
                                    title: locale.value.totalAmount,
                                    value: bookingController.bookingDetail.value
                                        .payment.totalAmount,
                                    textColor: getPriceStatusColor(
                                        paymentStatus: bookingController
                                            .bookingDetail
                                            .value
                                            .payment
                                            .paymentStatus),
                                  ),
                                  6.height,
                                ],
                              ),
                            ).paddingSymmetric(horizontal: 16),
                            Obx(() => additionalFacilityWidget(context).visible(
                                bookingController.facilities.isNotEmpty)),
                            Obx(() => payNowBtn(context)).visible(
                                bookingController.bookingDetail.value.payment
                                        .paymentStatus
                                        .toLowerCase()
                                        .contains(PaymentStatus.pending) &&
                                    bookingController.bookingDetail.value.status
                                        .toLowerCase()
                                        .contains(StatusConst.completed
                                            .toLowerCase())),
                            Obx(() => zoomVideoCallBtn(context).visible(
                                  bookingController.bookingDetail.value
                                          .joinVideoLink.isNotEmpty &&
                                      bookingController.bookingDetail.value
                                          .startVideoLink.isNotEmpty &&
                                      bookingController
                                          .bookingDetail.value.status
                                          .toLowerCase()
                                          .contains(StatusConst.confirmed
                                              .toLowerCase()),
                                )),
                            Obx(() => reviewPart(context).visible(
                                !bookingController.isLoading.value &&
                                    bookingController.bookingDetail.value.status
                                        .toLowerCase()
                                        .contains(StatusConst.completed
                                            .toLowerCase()))),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceInfoWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        32.height,
        Container(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          decoration: boxDecorationDefault(
            shape: BoxShape.rectangle,
            color: context.cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(bookingController.bookingDetail.value.training.name,
                          style: primaryTextStyle(size: 12))
                      .expand(),
                ],
              ),
              8.height,
              Row(
                children: [
                  Text(
                          bookingController
                              .bookingDetail.value.training.description,
                          textAlign: TextAlign.left,
                          style: secondaryTextStyle())
                      .expand(),
                ],
              ),
              6.height,
            ],
          ),
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }

  Widget additionalInfoWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        32.height,
        Container(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          decoration: boxDecorationDefault(
            shape: BoxShape.rectangle,
            color: context.cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(locale.value.additionalInformation,
                          style: primaryTextStyle(size: 12))
                      .expand(),
                ],
              ),
              8.height,
              Row(
                children: [
                  Text(bookingController.bookingDetail.value.note,
                          textAlign: TextAlign.left,
                          style: secondaryTextStyle())
                      .expand(),
                ],
              ),
              6.height,
            ],
          ),
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }

  Widget medicalReportWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        32.height,
        Text(locale.value.medicalReport, style: primaryTextStyle()),
        8.height,
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Loader(),
            ),
            GestureDetector(
              onTap: () {
                viewFiles(bookingController.bookingDetail.value.medicalReport);
              },
              behavior: HitTestBehavior.translucent,
              child: bookingController.bookingDetail.value.medicalReport.isImage
                  ? Container(
                      padding: const EdgeInsets.all(4),
                      decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: transparentColor),
                      child: CachedImageWidget(
                        url:
                            bookingController.bookingDetail.value.medicalReport,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        radius: 8,
                      ),
                    )
                  : CommonPdfPlaceHolder(
                      text: bookingController.bookingDetail.value.medicalReport
                          .split("/")
                          .last),
            ),
          ],
        )
      ],
    );
  }

  Widget reviewPart(BuildContext context) {
    return Obx(
      () => bookingController.hasReview.value
          ? bookingController.showWriteReview.value
              ? addEditReview(context)
              : yourReview(context)
          : bookingController.showWriteReview.value
              ? addEditReview(context)
              : rateEmpNow(context),
    );
  }

  Widget rateEmpNow(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          32.height,
          Text(locale.value.review, style: primaryTextStyle())
              .paddingSymmetric(horizontal: 16),
          8.height,
          AppButton(
            width: Get.width,
            text:
                "${locale.value.rate} ${bookingController.bookingDetail.value.employeeName}",
            textStyle: appButtonTextStyleGray,
            color: isDarkMode.value ? context.cardColor : lightSecondaryColor,
            onTap: () {
              bookingController
                  .showWriteReview(!bookingController.showWriteReview.value);
            },
          ).paddingSymmetric(horizontal: 16),
        ],
      ).visible(bookingController.yourReview.value.id.isNegative &&
          !bookingController.hasReview.value),
    );
  }

  Widget zoomVideoCallBtn(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          32.height,
          AppButton(
            width: Get.width,
            text: locale.value.zoomVideoCall,
            textStyle: appButtonTextStyleGray,
            color: isDarkMode.value ? context.cardColor : lightSecondaryColor,
            onTap: () {
              commonLaunchUrl(
                  bookingController.bookingDetail.value.joinVideoLink,
                  launchMode: LaunchMode.externalApplication);
            },
          ).paddingSymmetric(horizontal: 16),
        ],
      ),
    );
  }

  Widget payNowBtn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        32.height,
        AppButton(
          width: Get.width,
          text: locale.value.payNow,
          textStyle: appButtonTextStyleWhite,
          color: completedStatusColor,
          onTap: () async {
            paymentController = PaymentController(
              bookingService: bookingController.bookingDetail.value.service,
              isFromBookingDetail: true,
              bid: bookingController.bookingDetail.value.id,
              amount: bookingController.bookingDetail.value.payment.totalAmount,
              paymentID: bookingController.bookingDetail.value.payment.id,
              tax: bookingController.bookingDetail.value.payment.taxs
                  .map((e) => e.value)
                  .sumByDouble((p0) => p0),
            );
            paymentController
                .paymentOption(PaymentMethods.PAYMENT_METHOD_STRIPE);
            Get.to(() => const PaymentScreen())?.then((value) {
              if (value == true) {
                bookingController.getBookingDetail(
                    bookingId: bookingController.bookingDetail.value.id);
              }
            });
          },
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }

  Widget yourReview(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          32.height,
          Row(
            children: [
              Text(locale.value.yourReview, style: primaryTextStyle()),
              const Spacer(),
              GestureDetector(
                onTap: bookingController.handleEditReview,
                child: commonLeadingWid(
                    imgPath: Assets.iconsIcEditReview,
                    icon: Icons.edit_outlined,
                    size: 20),
              ),
              16.width,
              GestureDetector(
                onTap: () {
                  bookingController.deleteReviewHandleClick();
                },
                child: commonLeadingWid(
                    imgPath: Assets.iconsIcDeleteReview,
                    icon: Icons.delete_outline,
                    size: 20),
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
          8.height,
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: Get.width,
            decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        CachedImageWidget(
                          url: loginUserData.value.profileImage,
                          firstName: loginUserData.value.firstName,
                          lastName: loginUserData.value.lastName,
                          height: 46,
                          width: 46,
                          fit: BoxFit.cover,
                          circle: true,
                        ),
                        10.width,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(loginUserData.value.userName,
                                    style: primaryTextStyle()),
                              ],
                            ),
                            4.height,
                            Row(
                              children: [
                                RatingBarWidget(
                                  size: 15,
                                  disable: true,
                                  activeColor: getRatingBarColor(
                                      bookingController
                                          .yourReview.value.rating),
                                  rating: bookingController
                                      .yourReview.value.rating
                                      .toDouble(),
                                  onRatingChanged: (aRating) {
                                    bookingController.rating = 5;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                            bookingController
                                .yourReview
                                .value
                                .createdAt
                                .dateInyyyyMMddHHmmFormat
                                .timeAgoWithLocalization,
                            style: secondaryTextStyle()),
                      ],
                    ).expand(),
                  ],
                ),
                16.height,
                Text(bookingController.yourReview.value.reviewMsg,
                    style: secondaryTextStyle()),
              ],
            ),
          ).paddingSymmetric(horizontal: 16),
        ],
      ),
    );
  }

  Widget addEditReview(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          32.height,
          Row(
            children: [
              Text(
                  '${locale.value.yourReview}  ${locale.value.to}  ${bookingController.bookingDetail.value.employeeName}',
                  style: primaryTextStyle()),
              const Spacer(),
              GestureDetector(
                onTap: bookingController.showReview,
                child: commonLeadingWid(
                    imgPath: '', icon: Icons.close_outlined, size: 20),
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
          8.height,
          Text(locale.value.yourFeedbackWillImprove,
                  style: secondaryTextStyle())
              .paddingSymmetric(horizontal: 16),
          8.height,
          Row(
            children: [
              RatingBarWidget(
                size: 24,
                allowHalfRating: true,
                activeColor:
                    getRatingBarColor(bookingController.selectedRating.value),
                inActiveColor: ratingColor,
                rating: bookingController.selectedRating.value,
                onRatingChanged: (rating) {
                  bookingController.selectedRating(rating);
                },
              ).expand(),
            ],
          ).paddingSymmetric(horizontal: 16),
          8.height,
          AppTextField(
            controller: bookingController.reviewCont,
            textStyle: primaryTextStyle(size: 12),
            textFieldType: TextFieldType.MULTILINE,
            minLines: 5,
            decoration: inputDecoration(
              context,
              fillColor: context.cardColor,
              filled: true,
              hintText: locale.value.writeYourFeedbackHere,
            ),
          ).paddingSymmetric(horizontal: 16),
          16.height,
          AppButton(
            width: Get.width,
            text: locale.value.submit,
            textStyle: const TextStyle(color: containerColor),
            onTap: () {
              if (bookingController.selectedRating.value > 0) {
                bookingController.saveReview();
              } else {
                toast(locale.value.pleaseSelectRatings);
              }
            },
          ).paddingSymmetric(horizontal: 16),
          32.height,
        ],
      ),
    );
  }

  bool get showBookingDetail =>
      bookingController.bookingDetail.value.duration
          .toFormattedDuration(showFullTitleHoursMinutes: true)
          .isNotEmpty ||
      getAddressByServiceElement(
              appointment: bookingController.bookingDetail.value)
          .isNotEmpty;

  Widget additionalFacilityWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        32.height,
        Text(locale.value.additionalFacility, style: primaryTextStyle())
            .paddingSymmetric(horizontal: 16),
        AnimatedScrollView(
          children: [
            8.height,
            Container(
              decoration: boxDecorationDefault(
                shape: BoxShape.rectangle,
                color: context.cardColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: bookingController.facilities.map(
                  (element) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.height,
                        Text(element.name, style: primaryTextStyle()),
                        8.height,
                        Text(element.description, style: secondaryTextStyle()),
                        16.height,
                      ],
                    ).paddingSymmetric(horizontal: 16);
                  },
                ).toList(),
              ),
            ).paddingSymmetric(horizontal: 16),
          ],
        ),
      ],
    );
  }
}
