/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../components/loader_widget.dart';
import '../../../../main.dart';
import '../../../../utils/empty_error_state_widget.dart';
import '../model/order_detail_model.dart';
import '../model/order_status_model.dart';
import '../order_apis.dart';
import 'order_item_component.dart';

class OrderListComponent extends StatefulWidget {
  final OrderStatusData orderStatusData;

  const OrderListComponent({super.key, required this.orderStatusData});

  @override
  State<OrderListComponent> createState() => _OrderListComponentState();
}

class _OrderListComponentState extends State<OrderListComponent> {
  Rx<Future<List<OrderListData>>> orderListFuture = Future(() => <OrderListData>[]).obs;

  List<OrderListData> orders = [];

  int page = 1;
  int selectedIndex = 1;

  bool isLastPage = false;

  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init({String search = ''}) {
    orderListFuture(OrderApis.getOrderList(
      status: widget.orderStatusData.name,
      orders: orders,
      page: page,
      lastPageCallBack: (p0) {
        isLastPage = p0;
      },
    ));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => SnapHelperWidget<List<OrderListData>>(
            future: orderListFuture.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  page = 1;
                  isLoading(true);
                  init();
                  Future.delayed(const Duration(seconds: 3), () {
                    isLoading(false);
                  });
                },
              );
            },
            loadingWidget: const LoaderWidget(),
            onSuccess: (orderList) {
              return AnimatedListView(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: orderList.length,
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                emptyWidget: NoDataWidget(
                  title: locale.value.noOrdersFound,
                  subTitle: locale.value.thereAreNoOrders,
                  imageWidget: const EmptyStateWidget(),
                  retryText: locale.value.reload,
                  onRetry: () {
                    page = 1;
                    isLoading(true);
                    init();
                    Future.delayed(const Duration(seconds: 2), () {
                      isLoading(false);
                    });
                  },
                ).paddingSymmetric(horizontal: 16),
                itemBuilder: (_, i) => OrderItemComponent(
                  getOrderData: orderList[i],
                  onUpdateOrder: () {
                    orderList.removeAt(i);
                    setState(() {});
                  },
                ),
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    debugPrint('PAGE: $page');
                    isLoading(true);
                    init();
                    Future.delayed(const Duration(seconds: 2), () {
                      isLoading(false);
                    });
                  }
                },
                onSwipeRefresh: () async {
                  page = 1;
                  init();

                  return await Future.delayed(const Duration(seconds: 2));
                },
              );
            },
          ),
        ),
        Obx(() => const LoaderWidget().center().visible(isLoading.value)),
      ],
    );
  }
}
*/
