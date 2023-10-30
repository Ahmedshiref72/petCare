import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../components/price_widget.dart';
import '../../cart/model/cart_list_model.dart';
import 'order_review_component.dart';

class AboutProductComponent extends StatelessWidget {
  final List<CartListData> orderList;
  final String? deliveryStatus;

  const AboutProductComponent({super.key, this.deliveryStatus, required this.orderList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.aboutProduct, style: primaryTextStyle()),
        8.height,
        AnimatedWrap(
          runSpacing: 16,
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            CartListData orderData = orderList[index];

            return Container(
              decoration: boxDecorationDefault(color: context.cardColor),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedImageWidget(
                        url: orderData.productImage,
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                        radius: defaultRadius,
                      ),
                      12.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderData.productName, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                          4.height,
                          Row(
                            children: [
                              Text(locale.value.qty, style: secondaryTextStyle(size: 13)),
                              Text(orderData.qty.toString(), style: primaryTextStyle()),
                            ],
                          ),
                          if (orderData.productVariationType.isNotEmpty)
                            Row(
                              children: [
                                Text('${orderData.productVariationType}: ', style: primaryTextStyle(size: 13)),
                                Text(orderData.productVariationName, style: primaryTextStyle()),
                              ],
                            ),
                          8.height,
                          PriceWidget(price: orderData.getProductPrice, size: 14),
                        ],
                      ).expand(),
                    ],
                  ),
                  OrderReviewComponent(
                    deliveryStatus: deliveryStatus,
                    productData: orderData,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
