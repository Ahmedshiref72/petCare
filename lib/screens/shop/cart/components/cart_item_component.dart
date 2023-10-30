import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../components/price_widget.dart';
import '../../../../utils/colors.dart';
import '../cart_controller.dart';
import '../model/cart_list_model.dart';

class CartItemComponent extends StatelessWidget {
  final CartListData cartListData;

  CartItemComponent({super.key, required this.cartListData});

  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedImageWidget(
                  url: cartListData.productImage,
                  height: 75,
                  width: 75,
                  fit: BoxFit.cover,
                  radius: defaultRadius,
                ),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cartListData.productName,
                          style: primaryTextStyle(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).expand(),
                        Container(
                          padding: EdgeInsets.zero,
                          height: 20,
                          width: 20,
                          decoration: boxDecorationDefault(shape: BoxShape.circle, border: Border.all(color: textSecondaryColorGlobal), color: context.cardColor),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.close_rounded, color: textSecondaryColorGlobal, size: 18),
                            onPressed: () async {
                              /// Remove Cart Api
                              cartController.removeCart(context: context, cartId: cartListData.id);
                            },
                          ),
                        ),
                      ],
                    ),
                    4.height,
                    if (cartListData.productDescription.isNotEmpty)
                      Text(
                        cartListData.productDescription,
                        style: secondaryTextStyle(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    4.height,
                    if (cartListData.productVariationValue.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            '${cartListData.productVariationType}: ',
                            style: secondaryTextStyle(size: 14),
                          ),
                          Text(
                            cartListData.productVariationName,
                            style: primaryTextStyle(size: 14),
                          ),
                        ],
                      ),
                  ],
                ).expand(),
              ],
            ),
            12.height,
            Row(
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  height: 26,
                  width: 74,
                  decoration: boxDecorationDefault(
                    color: borderColor,
                    border: Border.all(color: textSecondaryColor),
                    borderRadius: radius(5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.remove, color: textSecondaryColor, size: 14),
                        highlightColor: Colors.transparent,
                        onPressed: () async {
                          if (cartListData.qty.value > 1) {
                            cartListData.qty(cartListData.qty.value - 1);

                            /// update cart api
                            cartController.updateCartAPi(
                              cartId: cartListData.id,
                              productId: cartListData.productId,
                              productVariationId: cartListData.productVariationId,
                              qty: cartListData.qty.value - 1,
                            );
                          }
                        },
                      ).expand(),
                      Text('${cartListData.qty}', style: primaryTextStyle(color: Colors.black)),
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.add, color: textSecondaryColor, size: 14),
                        highlightColor: Colors.transparent,
                        onPressed: () async {
                          cartListData.qty(cartListData.qty.value + 1);

                          /// update cart api
                          cartController.updateCartAPi(
                            cartId: cartListData.id,
                            productId: cartListData.productId,
                            productVariationId: cartListData.productVariationId,
                            qty: cartListData.qty.value + 1,
                          );
                        },
                      ).expand(),
                    ],
                  ),
                ),
                16.width,
                if (!cartListData.productVariation.id.isNegative)
                  Marquee(
                    child: Row(
                      children: [
                        PriceWidget(
                          price: cartListData.productVariation.taxIncludeProductPrice,
                          isLineThroughEnabled: cartListData.isDiscount ? true : false,
                          size: cartListData.isDiscount ? 12 : 16,
                          color: cartListData.isDiscount ? textSecondaryColorGlobal : null,
                        ),
                        4.width,
                        if (cartListData.isDiscount) PriceWidget(price: cartListData.productVariation.discountedProductPrice),
                        if (cartListData.isDiscount) 8.width,
                        if (cartListData.isDiscount) Text('${cartListData.discountValue}%  ${locale.value.off}', style: primaryTextStyle(color: greenColor)),
                      ],
                    ),
                  ).expand(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
