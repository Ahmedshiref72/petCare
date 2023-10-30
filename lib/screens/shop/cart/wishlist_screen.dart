import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/screens/shop/cart/wishlist_controller.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/loader_widget.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../shop_dashboard/components/cart_icon_btn.dart';
import '../shop_dashboard/components/product_item_component.dart';
import '../shop_dashboard/model/product_list_response.dart';

class WishListScreen extends StatelessWidget {
  WishListScreen({Key? key}) : super(key: key);
  final WishlistController wishlistController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.myWishlist,
      isLoading: wishlistController.isLoading,
      actions: const [
        CartIconBtn(),
      ],
      body: Obx(
        () => SnapHelperWidget<List<ProductItemData>>(
          future: wishlistController.getWishList.value,
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                wishlistController.page(1);
                wishlistController.isLoading(true);
                wishlistController.init();
              },
            ).paddingSymmetric(horizontal: 16);
          },
          loadingWidget: const LoaderWidget(),
          onSuccess: (wishlist) {
            if (wishlist.isEmpty) {
              return NoDataWidget(
                title: locale.value.noProductsFound,
                imageWidget: const EmptyStateWidget(),
                subTitle: locale.value.thereAreCurrentlyNoItemsInYourWishlist,
                retryText: locale.value.reload,
                onRetry: () {
                  wishlistController.page(1);
                  wishlistController.isLoading(true);
                  wishlistController.init();
                },
              );
            }
            return AnimatedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              onSwipeRefresh: () async {
                wishlistController.page(1);
                wishlistController.getWishListData(isFromSwipRefresh: false);
                return await Future.delayed(const Duration(seconds: 2));
              },
              padding: const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 50),
              onNextPage: () {
                if (!wishlistController.isLastPage.value) {
                  wishlistController.page(wishlistController.page.value + 1);
                  wishlistController.init();
                }
              },
              children: [
                16.height,
                AnimatedWrap(
                  runSpacing: 16,
                  spacing: 16,
                  listAnimationType: ListAnimationType.FadeIn,
                  children: List.generate(wishlist.length, (index) {
                    return ProductItemComponents(productListData: wishlist[index], isFromWishList: true);
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
