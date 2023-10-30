import 'package:get/get.dart';

import '../services/home_service_apis.dart';
import '../../dashboard/dashboard_res_model.dart';

class EventController extends GetxController {
  Rx<Future<List<PetEvent>>> getEvents = Future(() => <PetEvent>[]).obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxList<PetEvent> eventList = RxList();
  RxInt page = 1.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    getEvents(
      HomeServiceApis.getEvent(
        page: page.value,
        events: eventList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ).whenComplete(
        () => isLoading(false),
      ),
    );
  }
}
