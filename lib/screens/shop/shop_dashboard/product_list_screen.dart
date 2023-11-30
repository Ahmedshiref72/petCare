import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/booking_module/add_booking_forms/daycare_service_controller.dart';
import 'package:pawlly/screens/booking_module/model/choose_pet_widget.dart';
import 'package:pawlly/screens/shop/shop_dashboard/product_list_controller.dart';
import 'package:pawlly/screens/shop/shop_dashboard/shop_search_screen.dart';

import '../../../components/app_scaffold.dart';
import '../../../components/loader_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'components/product_item_component.dart';
import 'model/product_list_response.dart';

class ProductListScreen extends StatelessWidget {
  final String? title;

  ProductListScreen({super.key, this.title});

  final ProductListController productListController =
      Get.put(ProductListController());
 final DayCareServiceController dayCareServiceController =
      Get.put(DayCareServiceController());
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: title,
      isLoading: productListController.isLoading,
      actions: [
        IconButton(
          onPressed: () async {
            hideKeyboard(context);
            Get.to(() => ShopSearchScreen());
          },
          icon: commonLeadingWid(
              imgPath: Assets.iconsIcSearch,
              color: switchColor,
              icon: Icons.search_outlined,
              size: 22),
        ),
      ],
      body: Obx(
        () => SnapHelperWidget<List<ProductItemData>>(
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
            if (productList.isEmpty) {
              return NoDataWidget(
                title: locale.value.noProductsFound,
                retryText: locale.value.reload,
                onRetry: () {
                  productListController.page(1);
                  productListController.isLoading(true);
                  productListController.init();
                },
              );
            }
            return AnimatedScrollView(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 30),
              onNextPage: () async {
                if (!productListController.isLastPage.value) {
                  productListController
                      .page(productListController.page.value + 1);
                  productListController.isLoading(true);
                  productListController.init();
                  return await Future.delayed(const Duration(seconds: 2), () {
                    productListController.isLoading(false);
                  });
                }
              },
              onSwipeRefresh: () async {
                productListController.page(1);
                productListController.init();
                return await Future.delayed(const Duration(seconds: 2));
              },
              children: [
                /* SearchBarWidget(
                  productListController: ProductListController(),
                  onTap: () {
                    hideKeyboard(context);
                    Get.to(() => ShopSearchScreen());
                  },
                ),*/
                  //TODO
                  //just a view until the api being ready
                   ChooseYourPet(
                    onChanged: (selectedPet) {
                      dayCareServiceController.bookDayCareReq.petId =
                          selectedPet.id;
                    },
                  ),

                16.height,
                AnimatedWrap(
                  itemCount: productList.length,
                  spacing: 16,
                  runSpacing: 16,
                  itemBuilder: (context, index) {
                    return Obx(() => ProductItemComponents(
                        productListData: productList[index]));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
