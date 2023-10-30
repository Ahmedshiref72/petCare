import 'package:get/get.dart';
import 'package:pawlly/screens/shop/cart/cart_controller.dart';
import 'dashboard_shop_apis.dart';
import 'model/category_model.dart';

class ShopDashboardController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool hasErrorFetchingProduct = false.obs;
  RxString errorMessageProduct = "".obs;
  Rx<Future<DashboardShopRes>> getDashboardDetailFuture = Future(() => DashboardShopRes(shopDashData: DashboardShopModel())).obs;
  Rx<DashboardShopRes> shopdashboardData = DashboardShopRes(shopDashData: DashboardShopModel()).obs;

  @override
  void onInit() {
    /// To Set Cart Count to [cartCount] global variable
    CartController cartController = CartController();
    cartController.init();
    super.onInit();
  }

  @override
  void onReady() {
    init();
    super.onReady();
  }

  void init() {
    getShopDashboardDetail();
  }

  getShopDashboardDetail({bool isFromSwipRefresh = false}) {
    if (!isFromSwipRefresh) {
      isLoading(true);
    }
    getDashboardDetailFuture(DashboardShopApi.getShopDashboard()).then((value) {
      shopdashboardData(value);
    }).whenComplete(() => isLoading(false));
  }
}
