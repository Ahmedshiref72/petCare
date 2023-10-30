import 'package:get/get.dart';
import 'package:pawlly/screens/shop/cart/product_cart_api.dart';
import '../shop_dashboard/model/product_list_response.dart';

class WishlistController extends GetxController {
  Rx<Future<List<ProductItemData>>> getWishList = Future(() => <ProductItemData>[]).obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxList<ProductItemData> wishList = RxList();
  RxInt page = 1.obs;

  @override
  void onInit() {
    init();

    super.onInit();
  }

  void init() {
    getWishListData();
  }

  getWishListData({bool isFromSwipRefresh = false}) {
    if (!isFromSwipRefresh) {
      isLoading(true);
    }
    getWishList(
      ProductCartApi.getWishList(
        page: page.value,
        wishlist: wishList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ).whenComplete(
        () => isLoading(false),
      ),
    );
  }
}
