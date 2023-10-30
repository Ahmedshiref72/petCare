// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/screens/shop/shop_dashboard/model/category_model.dart';
import 'package:pawlly/screens/shop/shop_dashboard/shop_dashboard_controller.dart';

import '../../../components/loader_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../cart/wishlist_screen.dart';
import 'components/best_seller_product_components.dart';
import 'components/cart_icon_btn.dart';
import 'components/dashboard_category_components.dart';
import 'components/dashboard_featured_components.dart';
import 'components/deals_components.dart';
import 'shop_search_screen.dart';

class ShopDashboardScreen extends StatelessWidget {
  ShopDashboardScreen({super.key});

  final ShopDashboardController shopDashboardController = Get.put(ShopDashboardController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: shopDashboardController.isLoading,
      appBartitleText: locale.value.shop,
      hasLeadingWidget: false,
      actions: [
        IconButton(
          onPressed: () async {
            doIfLoggedIn(context, () {
              hideKeyboard(context);
              Get.to(() => ShopSearchScreen());
            });
          },
          icon: commonLeadingWid(imgPath: Assets.iconsIcSearch, color: switchColor, icon: Icons.search_outlined, size: 22),
        ),
        IconButton(
          onPressed: () async {
            doIfLoggedIn(context, () {
              Get.to(() => WishListScreen());
            });
          },
          icon: const Icon(Icons.favorite_border_outlined, color: switchColor, size: 25),
        ),
        const CartIconBtn(),
      ],
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            shopDashboardController.getShopDashboardDetail(isFromSwipRefresh: true);
            return await Future.delayed(const Duration(seconds: 2));
          },
          child: SnapHelperWidget<DashboardShopRes>(
            future: shopDashboardController.getDashboardDetailFuture.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  shopDashboardController.init();
                },
              ).paddingSymmetric(horizontal: 16);
            },
            loadingWidget: const LoaderWidget(),
            onSuccess: (shopDashboardRes) {
              if (shopDashboardRes.shopDashData.category.validate().isEmpty) {
                return NoDataWidget(
                  title: locale.value.atThisTimeThere,
                  retryText: locale.value.reload,
                  imageWidget: const EmptyStateWidget(),
                  onRetry: () {
                    shopDashboardController.isLoading(true);
                    shopDashboardController.init();
                  },
                );
              }
              return AnimatedScrollView(
                listAnimationType: ListAnimationType.FadeIn,
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  /*  SearchBarWidget(
                    productListController: ProductListController(),
                    onTap: () {
                      hideKeyboard(context);
                      Get.to(() => ShopSearchScreen());
                    },
                  ).paddingSymmetric(horizontal: 16),*/
                  8.height,
                  DashboardCategoryComponents(productCategoryList: shopDashboardRes.shopDashData.category),
                  16.height,
                  DashboardFeaturedComponents(featuredProductList: shopDashboardRes.shopDashData.featuredProduct),
                  16.height,
                  BestSellerComponents(bestSellerProductList: shopDashboardRes.shopDashData.bestsellerProduct),
                  16.height,
                  DealsComponents(discountProductList: shopDashboardRes.shopDashData.discountProduct),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
