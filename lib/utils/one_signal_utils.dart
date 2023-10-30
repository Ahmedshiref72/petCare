import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../configs.dart';
import '../screens/auth/model/notification_model.dart';
import '../screens/booking_module/booking_detail/booking_detail_screen.dart';
import '../screens/booking_module/model/booking_data_model.dart';
import '../screens/dashboard/dashboard_res_model.dart';
import '../screens/shop/order/model/order_detail_model.dart';
import '../screens/shop/order/order_detail_screen.dart';
import 'app_common.dart';

Future<void> initOneSignal() async {
  ///Initialize
  OneSignal.initialize(ONESIGNAL_APP_ID);
  OneSignal.Notifications.requestPermission(true);
  OneSignal.User.pushSubscription.optIn();

  ///Handle Navigation
  OneSignal.Notifications.addClickListener((event) {
    if (event.notification.additionalData != null) {
      if (event.notification.additionalData != null) {
        final additionalData = event.notification.additionalData!['additional_data'];

        NotificationDetail nData = NotificationDetail.fromJson(additionalData);

        if (nData.id > 0) {
          if (nData.notificationGroup == "shop") {
            Get.to(() => OrderDetailScreen(), arguments: OrderListData(id: nData.id, orderCode: nData.orderCode));
          } else {
            Get.to(() => BookingDetailScreen(), arguments: BookingDataModel(id: nData.id, service: SystemService(name: nData.bookingServicesNames), payment: PaymentDetails(), training: Training()));
          }
        }
      }
    }
  });

  ///Save Player Id
  saveOneSignalPlayerId();
}

Future<void> saveOneSignalPlayerId() async {
  if (isLoggedIn.value) {
    await OneSignal.login(loginUserData.value.id.toString()).then((value) {
      if (OneSignal.User.pushSubscription.id.validate().isNotEmpty) {
        playerId(OneSignal.User.pushSubscription.id);
        log('PLAYERID: ${playerId.value}');
      }
    }).catchError((e) {
      log('Error saving subscription id - $e');
    });
  }
}
