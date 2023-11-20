import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../components/price_widget.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../shop/cart/wishlist_controller.dart';
import '../../shop/product/product_detail_screen.dart';
import '../../shop/wishlist/wish_list_apis.dart';
import '../home_controller.dart';

class FeaturedProductsHomeComponent extends StatelessWidget {
  const FeaturedProductsHomeComponent({
    super.key,
    required this.homeScreenController,
    required this.isFromWishList,
  });

  final HomeScreenController homeScreenController;
  final bool isFromWishList;

  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      runSpacing: 16,
      spacing: 16,
      columnCount: 2,
      itemCount: homeScreenController.dashboardData.value.featuresProduct
          .take(6)
          .length,
      listAnimationType: ListAnimationType.FadeIn,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () async {
            Get.to(() => ProductDetail(),
                arguments: homeScreenController
                    .dashboardData.value.featuresProduct[index]);
          },
          child: Container(
            width: Get.width / 2 - 24,
            decoration: boxDecorationDefault(
              color: context.cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: radiusOnly(
                          topLeft: defaultRadius, topRight: defaultRadius),
                      child: CachedImageWidget(
                        url: homeScreenController.dashboardData.value
                            .featuresProduct[index].productImage,
                        width: Get.width,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      left: 8,
                      child: GestureDetector(
                        onTap: () {
                          if (isFromWishList) {
                            try {
                              WishlistController wLCont = Get.find();
                              doIfLoggedIn(context, () async {
                                wLCont.isLoading(true);
                                WishListApis.onTapFavourite(
                                        favdata: homeScreenController
                                            .dashboardData
                                            .value
                                            .featuresProduct[index])
                                    .whenComplete(
                                        () => wLCont.isLoading(false));
                              });
                            } catch (e) {
                              debugPrint('wLCont = Get.find(); E: $e');
                            }
                          } else {
                            doIfLoggedIn(context, () async {
                              WishListApis.onTapFavourite(
                                      favdata: homeScreenController
                                          .dashboardData
                                          .value
                                          .featuresProduct[index])
                                  .whenComplete(() =>
                                      homeScreenController.isLoading(false));
                            });
                          }
                        },
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: boxDecorationWithShadow(
                                    boxShape: BoxShape.rectangle,
                                    backgroundColor: context.cardColor,
                                    borderRadius: radius(18)),
                                child: Marquee(
                                    child: Text(locale.value.outOfStock,
                                        style: boldTextStyle(
                                            size: 12, color: primaryColor))),
                              ).visible(homeScreenController.dashboardData.value
                                      .featuresProduct[index].stockQty ==
                                  0),
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: boxDecorationWithShadow(
                                      boxShape: BoxShape.circle,
                                      backgroundColor: context.cardColor),
                                  child: homeScreenController
                                          .dashboardData
                                          .value
                                          .featuresProduct[index]
                                          .inWishlist
                                          .value
                                      ? const Icon(Icons.favorite,
                                          size: 15, color: redColor)
                                      : Icon(Icons.favorite,
                                          size: 15,
                                          color: textSecondaryColorGlobal)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        homeScreenController
                            .dashboardData.value.featuresProduct[index].name,
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    6.height,
                    Marquee(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (homeScreenController.dashboardData.value
                              .featuresProduct[index].isDiscount)
                            PriceWidget(
                                price: homeScreenController.dashboardData.value
                                    .featuresProduct[index].variationData
                                    .validate()
                                    .first
                                    .discountedProductPrice),
                          if (homeScreenController.dashboardData.value
                              .featuresProduct[index].isDiscount)
                            4.width,
                          PriceWidget(
                            price: homeScreenController
                                .dashboardData
                                .value
                                .featuresProduct[index]
                                .variationData
                                .first
                                .taxIncludeProductPrice,
                            isLineThroughEnabled: homeScreenController
                                    .dashboardData
                                    .value
                                    .featuresProduct[index]
                                    .isDiscount
                                ? true
                                : false,
                            isBoldText: homeScreenController.dashboardData.value
                                    .featuresProduct[index].isDiscount
                                ? false
                                : true,
                            size: homeScreenController.dashboardData.value
                                    .featuresProduct[index].isDiscount
                                ? 12
                                : 16,
                            color: homeScreenController.dashboardData.value
                                    .featuresProduct[index].isDiscount
                                ? textSecondaryColorGlobal
                                : null,
                          ).visible(homeScreenController.dashboardData.value
                              .featuresProduct[index].variationData.isNotEmpty),
                        ],
                      ),
                    ),
                    6.height,
                  ],
                ).paddingAll(16),
              ],
            ),
          ),
        );
      },
    );
  }
}
