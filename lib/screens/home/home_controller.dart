import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_common.dart';
import '../../utils/constants.dart';
import '../../utils/local_storage.dart';
import '../booking_module/model/booking_data_model.dart';
import '../dashboard/dashboard_res_model.dart';
import 'services/home_service_apis.dart';

class HomeScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  TextEditingController searchCont = TextEditingController();
  Rx<Future<DashboardRes>> getDashboardDetailFuture = Future(() => DashboardRes(data: DashboardData(upcommingBooking: BookingDataModel(service: SystemService(), payment: PaymentDetails(), training: Training())))).obs;

  Rx<DashboardData> dashboardData = DashboardData(upcommingBooking: BookingDataModel(service: SystemService(), payment: PaymentDetails(), training: Training())).obs;
  PageController pageController = PageController();
  RxInt currentPage = 0.obs;

  @override
  void onReady() {
    init();
    super.onReady();
  }

  void init() {
    try {
      final dashboardResFromLocal = getValueFromLocal(APICacheConst.DASHBOARD_RESPONSE);
      if (dashboardResFromLocal != null) {
        handleDashboardRes(DashboardRes.fromJson(dashboardResFromLocal));
      }
    } catch (e) {
      debugPrint('handleDashboardRes from cache E: $e');
    }
    getDashboardDetail();
  }

  ///Get ChooseService List
  getDashboardDetail({bool isFromSwipRefresh = false}) {
    if (!isFromSwipRefresh) {
      isLoading(true);
    }
    getDashboardDetailFuture(HomeServiceApis.getDashboard()).then((value) {
      handleDashboardRes(value);
      try {
        setValueToLocal(APICacheConst.DASHBOARD_RESPONSE, value.toJson());
      } catch (e) {
        debugPrint('store DASHBOARD_RESPONSE E: $e');
      }
    }).whenComplete(() => isLoading(false));
  }

  void handleDashboardRes(DashboardRes value) {
    dashboardData(value.data);
    isRefresh(true);
    isRefresh(false);
    serviceList(value.data.systemService);
    taxPercentage(value.data.taxPercentage);

    weightUnits(value.data.weightUnit);
    heightUnits(value.data.heightUnit);
    if (weightUnits.isEmpty) {
      weightUnits = [defaulWEIGHT.value].obs;
    } else {
      defaulWEIGHT(weightUnits.first);
    }
    if (heightUnits.isEmpty) {
      heightUnits = [defaulHEIGHT.value].obs;
    } else {
      defaulHEIGHT(heightUnits.first);
    }
  }
}
