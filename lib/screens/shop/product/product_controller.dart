import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/shop/shop_api.dart';
import 'package:pawlly/utils/app_common.dart';
import '../../../utils/constants.dart';
import '../cart/cart_screen.dart';
import '../cart/product_cart_api.dart';
import '../shop_dashboard/model/product_list_response.dart';
import 'model/product_detail_response.dart';
import 'model/product_review_response.dart';

class ProductDetailController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController pinCodeCont = TextEditingController();
  RxInt qtyCount = 1.obs;
  Rx<Future<ProductDetailRes>> productDetailsFuture = Future(() => ProductDetailRes(data: ProductItemData(inWishlist: false.obs))).obs;
  Rx<ProductDetailRes> productDetailRes = ProductDetailRes(data: ProductItemData(inWishlist: false.obs)).obs;
  RxList<ProductReviewDataModel> allReviewList = RxList();
  Rx<Future<List<ProductReviewDataModel>>> getreview = Future(() => <ProductReviewDataModel>[]).obs;
  PageController pageController = PageController(keepPage: true, initialPage: 0);
  int page = 1;
  RxBool isLastPage = false.obs;
  Rx<VariationData> selectedVariationData = VariationData(inCart: false.obs).obs;
  /*int qtyCounter = DEFAULT_QUANTITY.toInt();*/
  Rx<ProductItemData> argumentsList = ProductItemData(inWishlist: false.obs).obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    if (Get.arguments is ProductItemData) {
      argumentsList(Get.arguments as ProductItemData);
    }
    getProductDetails();
    getReviewList();
  }

  getProductDetails({bool isFromSwipRefresh = false}) {
    if (!isFromSwipRefresh) {
      isLoading(true);
    }

    productDetailsFuture(ShopApi.getProductDetails(productId: argumentsList.value.id)).then((value) {
      productDetailRes(value);
      if (productDetailRes.value.data.variationData.isNotEmpty) {
        selectedVariationData(productDetailRes.value.data.variationData.first);
      }
    }).whenComplete(() => isLoading(false));
  }

  getReviewList() {
    getreview(ShopApi.productAllReviews(
      productId: argumentsList.value.id,
      page: page,
      list: allReviewList,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    ));
  }

  Future<void> addProductToCart() async {
    isLoading(true);

    Map request = {
      ProductModelKey.productId: argumentsList.value.id.isNegative ? "" : argumentsList.value.id,
      ProductModelKey.productVariationId: selectedVariationData.value.id,
      ProductModelKey.qty: qtyCount.value,
      ProductModelKey.locationId: 1,
    };

    await ProductCartApi.addToCart(request).then((value) {
      toast(value.message);
      cartItemCount(cartItemCount.value + 1);
      isLoading(false);
      selectedVariationData.value.inCart(true);
      init();
      Get.to(() => CartScreen());
    }).catchError((error) {
      isLoading(false);
      toast(error.toString());
    });
  }
}
