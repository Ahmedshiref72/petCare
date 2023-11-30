import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/screens/booking_module/add_booking_forms/boarding_service_controller.dart';
import 'package:pawlly/screens/booking_module/add_booking_forms/daycare_service_controller.dart';
import 'package:pawlly/screens/booking_module/add_booking_forms/grooming_service_controller.dart';
import 'package:pawlly/screens/booking_module/add_booking_forms/training_service_controller.dart';
import 'package:pawlly/screens/booking_module/add_booking_forms/veterinery_service_controller.dart';
import 'package:pawlly/screens/booking_module/add_booking_forms/walking_service_controller.dart';
import 'package:pawlly/utils/colors.dart';

import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../dashboard/dashboard_res_model.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../pet/my_pets_controller.dart';
import '../add_booking_forms/boarding_service_screen.dart';
import '../add_booking_forms/daycare_service_screen.dart';
import '../add_booking_forms/grooming_service_screen.dart';
import '../add_booking_forms/training_service_screen.dart';
import '../add_booking_forms/veterinery_service_screen.dart';
import '../add_booking_forms/walking_service_screen.dart';
import '../booking_list/bookings_controller.dart';
import '../booking_success_screen.dart';
import '../model/booking_data_model.dart';

void navigateToService(SystemService service, {dynamic arguments}) {
  currentSelectedService(service);
  myPetsScreenController.init();
  if (service.id == 1) {
    Get.to(() => BoardingServicesScreen(),
        arguments: arguments, duration: const Duration(milliseconds: 800));
  } else if (service.id == 2) {
    Get.to(() => VeterineryServiceScreen(),
        arguments: arguments, duration: const Duration(milliseconds: 800));
  } else if (service.id == 3) {
    Get.to(() => GroomingScreen(),
        arguments: arguments, duration: const Duration(milliseconds: 800));
  } else if (service.id == 4) {
    Get.to(() => WalkingServiceScreen(),
        arguments: arguments, duration: const Duration(milliseconds: 800));
  } else if (service.id == 5) {
    Get.to(() => TrainingServiceScreen(),
        arguments: arguments, duration: const Duration(milliseconds: 800));
  } else if (service.id == 6) {
    Get.to(() => DayCareScreen(),
        arguments: arguments, duration: const Duration(milliseconds: 800));
  }
}

String getServiceKeyByServiceElement(SystemService service) {
  if (service.slug.contains(ServicesKeyConst.boarding)) {
    return ServicesKeyConst.boarding;
  } else if (service.slug.contains(ServicesKeyConst.veterinary)) {
    return ServicesKeyConst.veterinary;
  } else if (service.slug.contains(ServicesKeyConst.grooming)) {
    return ServicesKeyConst.grooming;
  } else if (service.slug.contains(ServicesKeyConst.walking)) {
    return ServicesKeyConst.walking;
  } else if (service.slug.contains(ServicesKeyConst.training)) {
    return ServicesKeyConst.training;
  } else if (service.slug.contains(ServicesKeyConst.dayCare)) {
    return ServicesKeyConst.dayCare;
  } else {
    return "";
  }
}

String getServiceIconByServiceElement(SystemService service) {
  if (service.slug.contains(ServicesKeyConst.boarding)) {
    return Assets.serviceIconsIcBoarding;
  } else if (service.slug.contains(ServicesKeyConst.veterinary)) {
    return Assets.serviceIconsIcVeterinary;
  } else if (service.slug.contains(ServicesKeyConst.grooming)) {
    return Assets.serviceIconsIcGrooming;
  } else if (service.slug.contains(ServicesKeyConst.walking)) {
    return Assets.serviceIconsIcWalking;
  } else if (service.slug.contains(ServicesKeyConst.training)) {
    return Assets.serviceIconsIcTraining;
  } else if (service.slug.contains(ServicesKeyConst.dayCare)) {
    return Assets.serviceIconsIcDaycare;
  } else {
    return Assets.serviceIconsIcDaycare;
  }
}

String getAddressByServiceElement({required BookingDataModel appointment}) {
  if (appointment.service.slug.contains(ServicesKeyConst.boarding)) {
    return petCenterDetail.value.addressLine1;
  } else if (appointment.service.slug.contains(ServicesKeyConst.veterinary)) {
    return petCenterDetail.value.addressLine1;
  } else if (appointment.service.slug.contains(ServicesKeyConst.grooming)) {
    return petCenterDetail.value.addressLine1;
  } else if (appointment.service.slug.contains(ServicesKeyConst.walking)) {
    return appointment.address;
  } else if (appointment.service.slug.contains(ServicesKeyConst.training)) {
    return petCenterDetail.value.addressLine1;
  } else if (appointment.service.slug.contains(ServicesKeyConst.dayCare)) {
    return appointment.address;
  } else {
    return "";
  }
}

(Map<String, dynamic>, List<PlatformFile>? files) getBookingReqByServiceType(
    {required String serviceType}) {
  try {
    if (serviceType.contains(ServicesKeyConst.boarding)) {
      BoardingServiceController bCont = Get.find();
      return (bCont.bookBoardingReq.toJson(), null);
    } else if (serviceType.contains(ServicesKeyConst.veterinary)) {
      VeterineryController vCont = Get.find();
      return (vCont.bookVeterinaryReq.toJson(), vCont.medicalReportfiles);
    } else if (serviceType.contains(ServicesKeyConst.grooming)) {
      GroomingController gCont = Get.find();
      return (gCont.bookGroomingReq.toJson(), null);
    } else if (serviceType.contains(ServicesKeyConst.walking)) {
      WalkingServiceController wCont = Get.find();
      return (wCont.bookWalkingReq.toJson(), null);
    } else if (serviceType.contains(ServicesKeyConst.training)) {
      TrainingController tCont = Get.find();
      return (tCont.bookTrainingReq.toJson(), null);
    } else if (serviceType.contains(ServicesKeyConst.dayCare)) {
      DayCareServiceController dCont = Get.find();
      return (dCont.bookDayCareReq.toJson(), null);
    } else {
      return ({}, null);
    }
  } catch (e) {
    log('getBookingReqByServiceType E: $e');
    return ({}, null);
  }
}

String getEmployeeRoleByServiceElement(
    {required BookingDataModel appointment}) {
  if (appointment.service.slug.contains(ServicesKeyConst.boarding)) {
    return locale.value.boarder;
  } else if (appointment.service.slug.contains(ServicesKeyConst.veterinary)) {
    return locale.value.veterinarian;
  } else if (appointment.service.slug.contains(ServicesKeyConst.grooming)) {
    return locale.value.groomer;
  } else if (appointment.service.slug.contains(ServicesKeyConst.walking)) {
    return locale.value.walker;
  } else if (appointment.service.slug.contains(ServicesKeyConst.training)) {
    return locale.value.trainer;
  } else if (appointment.service.slug.contains(ServicesKeyConst.dayCare)) {
    return locale.value.daycareTaker;
  } else {
    return "";
  }
}

Color getBookingStatusColor({required String status}) {
  if (status.toLowerCase().contains(StatusConst.pending)) {
    return pendingStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.upcoming)) {
    return upcomingStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.completed)) {
    return completedStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.confirmed)) {
    return confirmedStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.cancel)) {
    return cancelStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.reject)) {
    return cancelStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.inprogress)) {
    return inprogressStatusColor;
  } else {
    return defaultStatusColor;
  }
}

String getBookingStatus({required String status}) {
  if (status.toLowerCase().contains(StatusConst.pending)) {
    return locale.value.pending;
  } else if (status.toLowerCase().contains(StatusConst.completed)) {
    return locale.value.completed;
  } else if (status.toLowerCase().contains(StatusConst.confirmed)) {
    return locale.value.confirmed;
  } else if (status.toLowerCase().contains(StatusConst.cancel)) {
    return locale.value.cancelled;
  } else if (status.toLowerCase().contains(StatusConst.inprogress)) {
    return locale.value.inProgress;
  } else if (status.toLowerCase().contains(StatusConst.reject)) {
    return locale.value.rejected;
  } else {
    return "";
  }
}

String getBookingNotification({required String notification}) {
  if (notification.toLowerCase().contains(NotificationConst.newBooking)) {
    return locale.value.newBooking;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.completeBooking)) {
    return locale.value.completeBooking;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.rejectBooking)) {
    return locale.value.rejectBooking;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.cancelBooking)) {
    return locale.value.cancelBooking;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.acceptBooking)) {
    return locale.value.acceptBooking;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.changePassword)) {
    return locale.value.changePassword;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.forgetEmailPassword)) {
    return locale.value.forgetEmailPassword;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.orderPlaced)) {
    return locale.value.orderPlaced;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.orderPending)) {
    return locale.value.orderPending;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.orderProcessing)) {
    return locale.value.orderProcessing;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.orderDelivered)) {
    return locale.value.orderDelivered;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.orderCancelled)) {
    return locale.value.orderCancelled;
  } else {
    return "";
  }
}

String getOrderBookingStatus({required String status}) {
  if (status.toLowerCase().contains(OrderStatus.order_placed)) {
    return "${locale.value.order} ${locale.value.placed}";
  } else if (status.toLowerCase().contains(OrderStatus.Pending)) {
    return locale.value.pending;
  } else if (status.toLowerCase().contains(OrderStatus.Processing)) {
    return locale.value.processing;
  } else if (status.toLowerCase().contains(OrderStatus.Delivered)) {
    return locale.value.delivered;
  } else if (status.toLowerCase().contains(OrderStatus.Cancelled)) {
    return locale.value.cancelled;
  } else {
    return "";
  }
}

Color getOrderBookingStatusColor({required String status}) {
  if (status.toLowerCase().contains(OrderStatus.order_placed)) {
    return upcomingStatusColor;
  } else if (status.toLowerCase().contains(OrderStatus.Pending)) {
    return pendingStatusColor;
  } else if (status.toLowerCase().contains(OrderStatus.Processing)) {
    return completedStatusColor;
  } else if (status.toLowerCase().contains(OrderStatus.Delivered)) {
    return confirmedStatusColor;
  } else if (status.toLowerCase().contains(OrderStatus.Cancelled)) {
    return cancelStatusColor;
  } else {
    return defaultStatusColor;
  }
}

Color getPriceStatusColor({required String paymentStatus}) {
  if (paymentStatus.toLowerCase().contains(PaymentStatus.pending)) {
    return pricependingStatusColor;
  } else if (paymentStatus.toLowerCase().contains(PaymentStatus.PAID)) {
    return completedStatusColor;
  } else {
    return pricedefaultStatusColor;
  }
}

void onPaymentSuccess({required String bookingType}) async {
  reLoadBookingsOnDashboard();
  await Future.delayed(const Duration(milliseconds: 300));
  Get.offUntil(GetPageRoute(page: () => BookingSuccess()),
      (route) => route.isFirst || route.settings.name == '/$DashboardScreen');
}

void reLoadBookingsOnDashboard() {
  try {
    BookingsController bCont = Get.find();
    bCont.getBookingList();
  } catch (e) {
    log('E: $e');
  }
  try {
    DashboardController dashboardController = Get.find();
    dashboardController.currentIndex(1);
  } catch (e) {
    log('E: $e');
  }
}

String getBookingPaymentStatus({required String status}) {
  if (status.toLowerCase().contains(PaymentStatus.pending)) {
    return locale.value.pending;
  } else if (status.toLowerCase().contains(PaymentStatus.PAID)) {
    return locale.value.paid;
  } else {
    return "";
  }
}
