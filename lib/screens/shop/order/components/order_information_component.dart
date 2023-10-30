import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/booking_module/services/service_navigation.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../model/order_detail_model.dart';

class OrderInformationComponent extends StatelessWidget {
  final OrderListData orderData;

  const OrderInformationComponent({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.orderDetail, style: primaryTextStyle()),
        8.height,
        Container(
          decoration: boxDecorationDefault(color: context.cardColor),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              16.height,
              detailWidget(title: locale.value.orderDate, value: orderData.orderingDate),
              detailWidget(title: locale.value.deliveredOn, value: orderData.deliveringDate),
              detailWidget(title: locale.value.payment, value: orderData.paymentMethod.capitalizeFirstLetter()),
              detailWidget(title: locale.value.deliveryStatus, value: getOrderBookingStatus(status: orderData.deliveryStatus), textColor: getOrderBookingStatusColor(status: orderData.deliveryStatus)),
              6.height,
            ],
          ),
        ),
        16.height,
      ],
    );
  }
}
