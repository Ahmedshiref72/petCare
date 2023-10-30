import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/screens/shop/product/product_controller.dart';
import '../../../../components/price_widget.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_base.dart';
import '../../shop_dashboard/model/product_list_response.dart';

class ProductInfoComponent extends StatelessWidget {
  final ProductItemData productData;

  ProductInfoComponent({super.key, required this.productData});

  final ProductDetailController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(productData.name, style: primaryTextStyle(fontFamily: fontFamilyFontWeight600, size: 15)),
          if (productData.shortDescription.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                4.height,
                Text(productData.shortDescription, style: secondaryTextStyle()),
              ],
            ),
          if (productData.brandName.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Text('${productData.brandName}  ${locale.value.brand}', style: primaryTextStyle(fontFamily: fontFamilyFontWeight600, size: 16, color: secondaryColor)),
              ],
            ),
          16.height,
          Obx(
            () => Row(
              children: [
                PriceWidget(
                  price: productController.selectedVariationData.value.taxIncludeProductPrice,
                  isLineThroughEnabled: productData.isDiscount ? true : false,
                  isBoldText: productData.isDiscount ? false : true,
                  size: productData.isDiscount ? 14 : 16,
                  color: productData.isDiscount ? textSecondaryColorGlobal : null,
                ),
                if (productData.isDiscount) 4.width,
                if (productData.isDiscount)
                  PriceWidget(
                    price: productController.selectedVariationData.value.discountedProductPrice,
                  ),
                if (productData.isDiscount) 8.width,
                if (productData.isDiscount) Text('${productData.discountValue}%  ${locale.value.off}', style: primaryTextStyle(color: greenColor)),
              ],
            ),
          ),
          4.height,
          Text(locale.value.inclusiveOfAllTaxes, style: secondaryTextStyle(color: greenColor)),
          16.height,
          Row(
            children: [
              RatingBarWidget(
                onRatingChanged: (rating) {},
                disable: true,
                activeColor: getRatingColor(productData.rating.toInt()),
                inActiveColor: ratingBarColor,
                rating: productData.rating.toDouble(),
                size: 18,
              ),
              if (productData.rating != 0) 8.width,
              if (productData.rating != 0) Text('${productData.rating.toString()}  ${locale.value.ratings}', style: primaryTextStyle()),
            ],
          ),
        ],
      ),
    );
  }
}
