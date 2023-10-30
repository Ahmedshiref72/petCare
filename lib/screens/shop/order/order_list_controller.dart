import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/screens/shop/order/model/order_status_model.dart';
import '../../../utils/common_base.dart';
import 'model/order_detail_model.dart';
import 'order_apis.dart';

class OrderListController extends GetxController with GetSingleTickerProviderStateMixin {
  Rx<Future<List<OrderListData>>> orderListFuture = Future(() => <OrderListData>[]).obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  List<OrderListData> orders = [];
  TextEditingController searchCont = TextEditingController();
  RxList<OrderStatusData> statusList = RxList();
  RxList<OrderStatusData> statusFilterList = RxList();
  RxSet<String> selectedIndex = RxSet();
  RxBool isSearchText = false.obs;

  @override
  void onInit() {
    getOrderList();
    super.onInit();
  }

  getOrderList({bool showloader = true}) {
    if (showloader) {
      isLoading(true);
    }
    orderListFuture(OrderApis.getOrderList(
      filterByStatus: selectedIndex.join(","),
      page: page.value,
      orders: orders,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    )).whenComplete(() => isLoading(false));
  }

  orderUpdate({required int orderId, VoidCallback? onUpdateOrder}) async {
    isLoading(true);
    hideKeyBoardWithoutContext();

    await OrderApis.orderUpdate(orderId: orderId).then((value) {
      if (onUpdateOrder != null) {
        onUpdateOrder.call();

        toast(locale.value.theOrderHasBeen);
      }

      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }
}
