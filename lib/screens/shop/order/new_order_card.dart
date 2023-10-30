import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../components/price_widget.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../booking_module/services/service_navigation.dart';
import '../cart/model/cart_list_model.dart';
import 'model/order_detail_model.dart';
import 'order_detail_screen.dart';
import 'order_list_controller.dart';

class NewOrderCard extends StatelessWidget {
  final OrderListData getOrderData;
  final VoidCallback? onUpdateOrder;

  NewOrderCard({super.key, required this.getOrderData, this.onUpdateOrder});
  final OrderListController orderListController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: primaryColor,
                  borderRadius: radiusOnly(topLeft: defaultRadius),
                ),
                child: Text(
                  getOrderData.orderCode,
                  style: boldTextStyle(color: Colors.white, size: 12),
                ),
              ).visible(getOrderData.orderCode.isNotEmpty),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: secondaryColor,
                  borderRadius: radiusOnly(topRight: defaultRadius),
                ),
                child: PriceWidget(
                  price: getOrderData.totalAmount.validate(),
                  color: Colors.white,
                  size: 12,
                  isSemiBoldText: true,
                ),
              ),
            ],
          ),
          12.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedWrap(
                itemCount: getOrderData.productDetails.length,
                listAnimationType: ListAnimationType.None,
                itemBuilder: (context, index) {
                  CartListData orderListData = getOrderData.productDetails[index];

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedImageWidget(
                        url: orderListData.productImage.toString(),
                        height: 55,
                        width: 55,
                        fit: BoxFit.cover,
                        radius: defaultRadius,
                      ),
                      12.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderListData.productName, style: primaryTextStyle(fontFamily: fontFamilyFontWeight400), maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (orderListData.productVariationType.isNotEmpty)
                            Row(
                              children: [
                                Text('${orderListData.productVariationType}: ', style: secondaryTextStyle()),
                                Text(orderListData.productVariationName, style: primaryTextStyle(size: 14)),
                              ],
                            ),
                          Row(
                            children: [
                              Text(locale.value.qty, style: secondaryTextStyle()),
                              Text(orderListData.qty.toString(), style: primaryTextStyle(size: 14)),
                            ],
                          ),
                          Marquee(
                            child: Row(
                              children: [
                                PriceWidget(
                                  price: orderListData.taxIncludeProductPrice,
                                  isLineThroughEnabled: orderListData.isDiscount ? true : false,
                                  size: orderListData.isDiscount ? 12 : 14,
                                  color: orderListData.isDiscount ? secondaryTextColor : null,
                                ),
                                4.width,
                                if (orderListData.isDiscount) PriceWidget(price: orderListData.getProductPrice, size: 14),
                                if (orderListData.isDiscount) 8.width,
                                if (orderListData.isDiscount) Text('${orderListData.discountValue}% ${locale.value.off}', style: primaryTextStyle(color: greenColor)),
                              ],
                            ),
                          ),
                        ],
                      ).expand(),
                    ],
                  ).paddingOnly(left: 16, right: 16, top: 16);
                },
              ),
            ],
          ),
          8.height,
          Divider(color: context.dividerColor),
          2.height,
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(locale.value.deliveryStatus, style: secondaryTextStyle()),
                  Text(getOrderBookingStatus(status: getOrderData.deliveryStatus), style: primaryTextStyle(color: getOrderBookingStatusColor(status: getOrderData.deliveryStatus))),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(locale.value.payment, style: secondaryTextStyle()),
                  Text(getBookingPaymentStatus(status: getOrderData.paymentStatus), style: primaryTextStyle(color: getPriceStatusColor(paymentStatus: getOrderData.paymentStatus))),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
          if ((getOrderData.deliveryStatus == OrderStatusConst.ORDER_PLACED || getOrderData.deliveryStatus == OrderStatusConst.PROCESSING || getOrderData.deliveryStatus == OrderStatusConst.PENDING) && getOrderData.paymentStatus == 'unpaid')
            Column(
              children: [
                16.height,
                AppButton(
                  text: locale.value.cancelOrder,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: Get.width,
                  textStyle: appButtonTextStyleWhite,
                  color: primaryColor,
                  onTap: () {
                    showConfirmDialogCustom(
                      context,
                      title: locale.value.doYouWantToCancelOrder,
                      primaryColor: context.primaryColor,
                      positiveText: locale.value.yes,
                      negativeText: locale.value.cancel,
                      dialogType: DialogType.DELETE,
                      onAccept: (_) {
                        orderListController.orderUpdate(orderId: getOrderData.id, onUpdateOrder: onUpdateOrder);
                      },
                    );
                  },
                ).paddingSymmetric(horizontal: 16, vertical: 8),
              ],
            )
          else
            const Offstage(),
          16.height,
        ],
      ),
    ).onTap(() {
      hideKeyboard(context);
      Get.to(() => OrderDetailScreen(), arguments: getOrderData);
    }, borderRadius: radius(), highlightColor: Colors.transparent, splashColor: Colors.transparent).paddingOnly(bottom: 16);
  }
}
