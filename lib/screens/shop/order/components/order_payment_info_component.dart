import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/utils/colors.dart';

import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../model/order_detail_model.dart';

class OrderPaymentInfoComponent extends StatelessWidget {
  final OrderListData orderData;

  const OrderPaymentInfoComponent({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.priceDetails, style: primaryTextStyle()),
        8.height,
        Container(
          decoration: boxDecorationDefault(color: context.cardColor),
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Subtotal
              detailWidgetPrice(title: locale.value.subtotal, value: orderData.subTotalAmount, textColor: textPrimaryColorGlobal),

              /// Total Tax Amount
              detailWidgetPrice(title: locale.value.tax, value: orderData.totalTaxAmount, textColor: textPrimaryColorGlobal),

              /// Delivery Charge
              detailWidgetPrice(title: locale.value.deliveryCharge, value: orderData.logisticCharge, textColor: textPrimaryColorGlobal),

              /// Payment Status
              detailWidget(title: locale.value.paymentStatus, value: orderData.paymentStatus.capitalizeFirstLetter()),
              detailWidgetPrice(title: locale.value.total, value: orderData.totalAmount, textColor: primaryColor),
            ],
          ),
        ),
        16.height,
        Text(locale.value.shippingDetail, style: primaryTextStyle()),
        8.height,
        Container(
          width: Get.width,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          decoration: boxDecorationDefault(color: context.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Marquee(child: Text(orderData.userName.capitalizeFirstLetter(), style: primaryTextStyle())).paddingBottom(8).visible(orderData.userName.trim().isNotEmpty),
              Marquee(child: Text(orderData.addressLine1.capitalizeFirstLetter(), style: secondaryTextStyle())).visible(orderData.addressLine1.trim().isNotEmpty),
              Marquee(child: Text(orderData.addressLine2.capitalizeFirstLetter(), style: secondaryTextStyle())).visible(orderData.addressLine2.trim().isNotEmpty),
              10.height,
              Marquee(child: Text(orderData.city.capitalizeFirstLetter(), style: secondaryTextStyle())).visible(orderData.city.trim().isNotEmpty),
              10.height,
              Marquee(child: Text('${orderData.state.capitalizeFirstLetter()} - ${orderData.postalCode}', style: secondaryTextStyle())).visible(orderData.state.trim().isNotEmpty),
              10.height,
              Marquee(
                child: RichTextWidget(
                  list: [
                    TextSpan(text: '${locale.value.contactNumber}: ', style: secondaryTextStyle()),
                    TextSpan(text: orderData.phoneNo, style: primaryTextStyle(size: 12)),
                  ],
                ).visible(orderData.phoneNo.trim().isNotEmpty),
              ),
              10.height,
              Marquee(
                child: RichTextWidget(
                  list: [
                    TextSpan(text: locale.value.alternativeContactNumber, style: secondaryTextStyle()),
                    TextSpan(text: orderData.alternativePhoneNo, style: primaryTextStyle(size: 12)),
                  ],
                ).visible(orderData.alternativePhoneNo.trim().isNotEmpty),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
