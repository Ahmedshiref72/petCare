import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/utils/view_all_label_component.dart';

import '../home_controller.dart';
import '../../booking_module/booking_list/booking_card.dart';

class UpcomingAppointmentComponents extends StatelessWidget {
  UpcomingAppointmentComponents({Key? key}) : super(key: key);
  final HomeScreenController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          ViewAllLabel(label: locale.value.upcomingAppointment, isShowAll: false),
          8.height,
          Obx(
            () => BookingCard(
              appointment: homeScreenController.dashboardData.value.upcommingBooking,
              isFromHome: true,
            ),
          ),
        ],
      ),
    );
  }
}
