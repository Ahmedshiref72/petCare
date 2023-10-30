// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/screens/shop/shop_dashboard/product_list_controller.dart';

import '../../../components/loader_widget.dart';
import '../../../components/search_widget.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../cart/cart_screen.dart';
import '../cart/wishlist_screen.dart';
import 'components/product_item_component.dart';
import 'model/product_list_response.dart';
import 'shop_dashboard_controller.dart';

class ShopSearchScreen extends StatelessWidget {
  ShopSearchScreen({super.key});

  ProductListController productListController = ProductListController();
  final ShopDashboardController shopDashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    try {
      productListController.handleSearch(isFromSwipRefresh: true);
    } catch (e) {
      debugPrint('handleSearch E: $e');
    }
    return AppScaffold(
      appBartitleText: locale.value.searchProducts,
      isLoading: shopDashboardController.isLoading,
      actions: [
        IconButton(
          onPressed: () async {
            doIfLoggedIn(context, () {
              Get.to(() => WishListScreen());
            });
          },
          icon: const Icon(Icons.favorite_border_outlined, color: switchColor, size: 22),
        ),
        IconButton(
          onPressed: () {
            doIfLoggedIn(context, () {
              Get.to(() => CartScreen());
            });
          },
          icon: const Icon(Icons.shopping_cart_outlined, color: switchColor, size: 22),
        ),
      ],
      body: SizedBox(
        height: Get.height,
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                8.height,
                SearchBarWidget(
                  productListController: productListController,
                  onClearButton: () {
                    productListController.isLoading(true);
                    productListController.handleSearch();
                  },
                  onFieldSubmitted: (p0) {
                    productListController.isLoading(true);
                    productListController.isSearchText(productListController.searchCont.text.trim().isNotEmpty);
                    productListController.handleSearch();
                  },
                ).paddingSymmetric(horizontal: 16),
                SnapHelperWidget<List<ProductItemData>>(
                  future: productListController.getFeatured.value,
                  errorBuilder: (error) {
                    return NoDataWidget(
                      title: error,
                      retryText: locale.value.reload,
                      imageWidget: const ErrorStateWidget(),
                      onRetry: () {
                        productListController.page(1);
                        productListController.isLoading(true);
                        productListController.init();
                      },
                    ).paddingSymmetric(horizontal: 16);
                  },
                  loadingWidget: const LoaderWidget(),
                  onSuccess: (productList) {
                    if (productList.isEmpty && productListController.isSearchText.value && !productListController.isLoading.value) {
                      return NoDataWidget(
                        title: locale.value.noProductsFound,
                        imageWidget: const EmptyStateWidget(),
                      ).paddingTop(Get.height * 0.25);
                    }

                    return AnimatedScrollView(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
                      onSwipeRefresh: () async {
                        productListController.page(1);
                        productListController.init();
                        return await Future.delayed(const Duration(seconds: 2));
                      },
                      onNextPage: () {
                        if (!productListController.isLastPage.value) {
                          productListController.page(productListController.page.value + 1);
                          productListController.init();
                        }
                      },
                      children: [
                        16.height,
                        AnimatedWrap(
                          itemCount: productList.length,
                          spacing: 16,
                          runSpacing: 16,
                          itemBuilder: (context, index) {
                            return Obx(() => ProductItemComponents(productListData: productList[index]));
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
