import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pawlly/screens/shop/shop_dashboard/model/product_status_model.dart';

import 'dashboard_shop_apis.dart';
import 'model/product_list_response.dart';

class ProductListController extends GetxController {
  Rx<Future<List<ProductItemData>>> getFeatured = Future(() => <ProductItemData>[]).obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxList<ProductItemData> productList = RxList();
  Rx<ProductStatusModel> argumentsList = ProductStatusModel().obs;
  RxInt page = 1.obs;

  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    if (Get.arguments is ProductStatusModel) {
      argumentsList(Get.arguments as ProductStatusModel);
    }

    getProductsList(categoryId: argumentsList.value.productCategoryID, bestDiscount: argumentsList.value.isDeal, isFeatured: argumentsList.value.isFeatured, bestSeller: argumentsList.value.isBestSeller);
  }

  void handleSearch({bool isFromSwipRefresh = false}) async {
    getFeatured(getProductsList(isFromSwipRefresh: isFromSwipRefresh, search: searchCont.text.trim()));
  }

  getProductsList({String search = "", String categoryId = "", String bestDiscount = "", String isFeatured = "", String bestSeller = "", bool isFromSwipRefresh = false}) {
    getFeatured(
      DashboardShopApi.getProductsList(
        search: search,
        categoryId: categoryId,
        isFeatured: isFeatured,
        bestSeller: bestSeller,
        bestDiscount: bestDiscount,
        page: page.value,
        products: productList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ).whenComplete(
        () => isLoading(false),
      ),
    );
  }
}
