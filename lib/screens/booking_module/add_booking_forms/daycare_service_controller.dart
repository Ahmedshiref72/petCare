import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../dashboard/dashboard_res_model.dart';
import '../model/booking_data_model.dart';
import '../payment_screen.dart';
import '../../../utils/constants.dart';
import 'model/book_day_care_req.dart';
import '../model/employe_model.dart';
import '../services/services_form_api.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../home/home_controller.dart';
import '../payment_controller.dart';
import '../../pet/model/pet_list_res_model.dart';
import '../../pet/my_pets_controller.dart';
import '../model/choose_pet_widget.dart';

class DayCareServiceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  BookDayCareReq bookDayCareReq = BookDayCareReq();
  Rx<PetDaycareAmount> petDaycareAmount = PetDaycareAmount().obs;
  //DayCareTaker
  Rx<EmployeeModel> selectedDayCareTaker = EmployeeModel(profileImage: "".obs).obs;
  RxList<EmployeeModel> dayCareTakerList = RxList();
  RxList<EmployeeModel> dayCareTakerFilterList = RxList();
  //Error DayCareTaker
  RxBool hasErrorFetchingDayCareTaker = false.obs;
  RxString errorMessageDayCareTaker = "".obs;
  Rx<BookingDataModel> bookingFormData = BookingDataModel(service: SystemService(), payment: PaymentDetails(), training: Training()).obs;
  RxBool isUpdateForm = false.obs;
  TextEditingController dateCont = TextEditingController();
  TextEditingController dropOffTimeCont = TextEditingController();
  TextEditingController pickUpTimeCont = TextEditingController();
  TextEditingController daycareTakerCont = TextEditingController();
  TextEditingController favFoodCont = TextEditingController();
  TextEditingController favActCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController additionalInfoCont = TextEditingController();

  //Search
  TextEditingController searchCont = TextEditingController();

  @override
  void onInit() {
    bookDayCareReq.systemServiceId = currentSelectedService.value.id;
    getPetDaycareAmount();
    if (Get.arguments is BookingDataModel) {
      try {
        isUpdateForm(true);
        bookingFormData(Get.arguments as BookingDataModel);
        additionalInfoCont.text = bookingFormData.value.service.description;
        addressCont.text = bookingFormData.value.address;
        debugPrint('bookingFormData.value.food ==> ${bookingFormData.value.food}');
        debugPrint(' bookingFormData.value.activity ==> ${bookingFormData.value.activity}');
        favActCont.text = bookingFormData.value.activity.isNotEmpty ? bookingFormData.value.activity.first : "";
        favFoodCont.text = bookingFormData.value.activity.isNotEmpty ? bookingFormData.value.food.first : "";
        getDayCareTakers();
        selectedPet(myPetsScreenController.myPets.firstWhere((element) => element.name.toLowerCase() == bookingFormData.value.petName.toLowerCase(), orElse: () => PetData()));
      } catch (e) {
        debugPrint('daycare book again E: $e');
      }
    } else {
      getDayCareTakers();
    }
    super.onInit();
  }

  void getPetDaycareAmount() {
    try {
      HomeScreenController homeController = Get.find();
      if (homeController.dashboardData.value.petDaycareAmount.isNotEmpty) {
        petDaycareAmount(homeController.dashboardData.value.petDaycareAmount.first);
        currentSelectedService.value.serviceAmount = petDaycareAmount.value.val.toDouble();
        bookDayCareReq.price = petDaycareAmount.value.val.toDouble();
      }
    } catch (e) {
      HomeScreenController homeController = HomeScreenController();
      homeController.getDashboardDetail();
      if (homeController.dashboardData.value.petDaycareAmount.isNotEmpty) {
        petDaycareAmount(homeController.dashboardData.value.petDaycareAmount.first);
        currentSelectedService.value.serviceAmount = petDaycareAmount.value.val.toDouble();
        bookDayCareReq.price = petDaycareAmount.value.val.toDouble();
      }
    }
  }

  void clearDaycareTakerSelection() {
    daycareTakerCont.clear();
    selectedDayCareTaker(EmployeeModel(profileImage: "".obs));
  }

  ///Get DayCare List
  getDayCareTakers() {
    isLoading(true);
    PetServiceFormApis.getEmployee(role: EmployeeKeyConst.dayCare).then((value) {
      isLoading(false);
      dayCareTakerList(value.data);
      hasErrorFetchingDayCareTaker(false);
      if (isUpdateForm.value) {
        selectedDayCareTaker(dayCareTakerList.firstWhere((p0) => p0.id == bookingFormData.value.employeeId, orElse: () => EmployeeModel(profileImage: "".obs)));
        daycareTakerCont.text = selectedDayCareTaker.value.fullName;
      }
    }).onError((error, stackTrace) {
      hasErrorFetchingDayCareTaker(true);
      errorMessageDayCareTaker(error.toString());
      isLoading(false);
      // toast(error.toString());
    });
  }

  void searchFunc({
    required String searchtext,
    required RxList<EmployeeModel> daycareFilterList,
    required RxList<EmployeeModel> daycareSList,
  }) {
    daycareFilterList.value = List.from(daycareSList.where((element) => element.fullName.toString().toLowerCase().contains(searchtext.toString().toLowerCase())));
    for (var i = 0; i < daycareFilterList.length; i++) {
      debugPrint('SEARCHEDNAMES : ${daycareFilterList[i].toJson()}');
    }
    debugPrint('SEARCHEDNAMES.LENGTH: ${daycareFilterList.length}');
  }

  void onSearchChange(searchtext) {
    searchFunc(
      searchtext: searchtext,
      daycareFilterList: dayCareTakerFilterList,
      daycareSList: dayCareTakerList,
    );
  }

  bool get isShowFullList => dayCareTakerFilterList.isEmpty && searchCont.text.trim().isEmpty;

  String get getDropOFFDateTime => "${bookDayCareReq.date.trim()} ${bookDayCareReq.dropOfftime.trim()}";

  handleBookNowClick() {
    bookDayCareReq.additionalInfo = additionalInfoCont.text.trim();
    bookDayCareReq.address = addressCont.text.trim();
    bookDayCareReq.food = [favFoodCont.text.trim()];
    bookDayCareReq.activity = [favActCont.text.trim()];
    bookDayCareReq.employeeId = selectedDayCareTaker.value.id;
    bookDayCareReq.totalAmount = totalAmount;
    bookingSuccessDate(getDropOFFDateTime);
    debugPrint('BOOKBOARDINGREQ.TOJSON(): ${bookDayCareReq.toJson()}');
    hideKeyBoardWithoutContext();
    paymentController = PaymentController(bookingService: currentSelectedService.value);
    Get.to(() => const PaymentScreen());
  }

  ///TODO Don't Remove
  /*  saveDayCareBookingApi() {
    bookDayCareReq.additionalInfo = additionalInfoCont.text.trim();
    bookDayCareReq.address = addressCont.text.trim();
    bookDayCareReq.favFood = favFoodCont.text.trim();
    bookDayCareReq.favAct = favActCont.text.trim();
    bookDayCareReq.employeeId = selectedDayCareTaker.value.id;

    bookDayCareReq.totalAmount = totalAmount;
    debugPrint('BOOKBOARDINGREQ.TOJSON(): ${bookDayCareReq.toJson()}');
    isLoading(true);
    hideKeyBoardWithoutContext();
    PetServiceFormApis.bookServiceApi(
      request: bookDayCareReq.toJson(),
      onSuccess: () {
        isLoading(false);
        onBookingSuccess(bookingType: ServicesKeyConst.dayCare);
      },
      loaderOff: () {
        isLoading(false);
      },
    ).then((value) {}).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    }); //
  } */
}
