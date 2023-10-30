import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../pet/model/pet_list_res_model.dart';
import '../../pet/my_pets_controller.dart';
import '../model/choose_pet_widget.dart';
import '../model/booking_data_model.dart';
import '../model/employe_model.dart';
import '../payment_screen.dart';
import '../../../utils/constants.dart';

import 'model/book_boarding_req.dart';
import '../model/facilities_model.dart';
import '../../dashboard/dashboard_res_model.dart';
import '../services/services_form_api.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../home/home_controller.dart';
import '../payment_controller.dart';

class BoardingServiceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool showBookBtn = false.obs;
  RxBool hasErrorFetchingBoarders = false.obs;
  RxString errorMessageBoarder = "".obs;
  BookBoardingReq bookBoardingReq = BookBoardingReq();
  RxInt serviceDaysCount = 0.obs;
  Rx<PetBoardingAmount> petBoardingAmount = PetBoardingAmount().obs;
  Rx<BookingDataModel> bookingFormData = BookingDataModel(service: SystemService(), payment: PaymentDetails(), training: Training()).obs;
  RxBool isUpdateForm = false.obs;
  Rx<EmployeeModel> selectedBoarder = EmployeeModel(profileImage: "".obs).obs;
  RxList<EmployeeModel> boardersList = RxList();
  RxList<EmployeeModel> boarderFilterList = RxList();
  TextEditingController dropOffDateCont = TextEditingController();
  TextEditingController dropOfftimeCont = TextEditingController();
  TextEditingController pickUpDateCont = TextEditingController();
  TextEditingController pickUptimeCont = TextEditingController();
  TextEditingController dropAddressCont = TextEditingController();
  TextEditingController pickAddressCont = TextEditingController();
  TextEditingController boarderCont = TextEditingController();
  TextEditingController medicalReportCont = TextEditingController();
  TextEditingController additionalInfoCont = TextEditingController();
  TextEditingController searchCont = TextEditingController();
  Rx<Future<List<FacilityModel>>> getFacility = Future(() => <FacilityModel>[]).obs;
  RxList<FacilityModel> selectedFacilities = RxList();
  FilePickerResult? result;

  @override
  void onInit() {
    getBoarders();
    getPetBoardingAmount();
    getFacility(PetServiceFormApis.getFacility());
    bookBoardingReq.systemServiceId = currentSelectedService.value.id;
    dropAddressCont.text = petCenterDetail.value.addressLine1;

    if (Get.arguments is BookingDataModel) {
      try {
        isUpdateForm(true);
        bookingFormData(Get.arguments as BookingDataModel);
        getFacility(PetServiceFormApis.getFacility()).then((fullList) {
          List<FacilityModel> previousSelected = fullList.where((item) => bookingFormData.value.additionalFacility.map((e) => e.id).toList().contains(item.id)).toList();
          previousSelected.map((item) => item.isChecked(true)).toList();
          selectedFacilities(previousSelected);
        });
        additionalInfoCont.text = bookingFormData.value.service.description;
        selectedPet(myPetsScreenController.myPets.firstWhere((element) => element.name.toLowerCase() == bookingFormData.value.petName.toLowerCase(), orElse: () => PetData()));
      } catch (e) {
        debugPrint('boarding book again E: $e');
      }
    }
    super.onInit();
  }

  void getPetBoardingAmount() {
    try {
      HomeScreenController homeController = Get.find();
      if (homeController.dashboardData.value.petBoardingAmount.isNotEmpty) {
        petBoardingAmount(homeController.dashboardData.value.petBoardingAmount.first);
      }
    } catch (e) {
      HomeScreenController homeController = HomeScreenController();
      homeController.getDashboardDetail();
      if (homeController.dashboardData.value.petBoardingAmount.isNotEmpty) {
        petBoardingAmount(homeController.dashboardData.value.petBoardingAmount.first);
      }
    }
  }

  onDateTimeChanges() {
    try {
      serviceDaysCount(DateFormat(DateFormatConst.yyyy_MM_dd).parse(getpickUpDateTime).difference(DateFormat(DateFormatConst.yyyy_MM_dd).parse(getDropOFFDateTime)).inDays);
      log('SERVICEDAYSCOUNT: ${serviceDaysCount.value}');
      if (serviceDaysCount < 1) {
        serviceDaysCount(1);
      }
      bookBoardingReq.price = petBoardingAmount.value.val.toDouble() * serviceDaysCount.value;
      currentSelectedService.value.serviceAmount = bookBoardingReq.price;

      ///calculationChecker();
      showBookBtn(false);
      showBookBtn(true);
    } catch (e) {
      log('On DateTimeChanges E: $e');
    }
  }

  ///To verify calculation use method below method;
  void calculationChecker() {
    log('SERVICE DAYS COUNT: $serviceDaysCount');
    log('BOOKBOARDINGREQ.PRICE: ${petBoardingAmount.value.val}');
    log('PRICE * Days: ${petBoardingAmount.value.val.toDouble() * serviceDaysCount.value}');
    log('percentTaxAmount: $percentTaxAmount');
    log('fixedTaxAmount: $fixedTaxAmount');
    log('totalAmount: $totalAmount');
    log('TOTAL AMOUNT: $totalAmount');
  }

  String get getDropOFFDateTime => "${bookBoardingReq.dropoffDate.trim()} ${bookBoardingReq.dropoffTime.trim()}";
  String get getpickUpDateTime => "${bookBoardingReq.pickupDate.trim()} ${bookBoardingReq.pickupTime.trim()}";

  void clearBoarderSelection() {
    boarderCont.clear();
    selectedBoarder(EmployeeModel(profileImage: "".obs));
  }

  ///Get Boarders List
  getBoarders() {
    isLoading(true);
    PetServiceFormApis.getEmployee(role: EmployeeKeyConst.boarding).then((value) {
      isLoading(false);
      boardersList(value.data);
      hasErrorFetchingBoarders(false);
      if (isUpdateForm.value) {
        selectedBoarder(boardersList.firstWhere((p0) => p0.id == bookingFormData.value.employeeId, orElse: () => EmployeeModel(profileImage: "".obs)));
        boarderCont.text = selectedBoarder.value.fullName;
      }
    }).onError((error, stackTrace) {
      hasErrorFetchingBoarders(true);
      errorMessageBoarder(error.toString());
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
      log('SEARCHED NAMES : ${daycareFilterList[i].toJson()}');
    }
    log('SEARCHEDNAMES.LENGTH: ${daycareFilterList.length}');
  }

  void onSearchChange(searchtext) {
    searchFunc(
      searchtext: searchtext,
      daycareFilterList: boarderFilterList,
      daycareSList: boardersList,
    );
  }

  bool get isShowFullList => boarderFilterList.isEmpty && searchCont.text.trim().isEmpty;

  handleBookNowClick() {
    bookBoardingReq.dropoffAddress = dropAddressCont.text.trim();
    bookBoardingReq.pickupAddress = dropAddressCont.text.trim();
    bookBoardingReq.additionalInfo = additionalInfoCont.text.trim();
    bookBoardingReq.employeeId = selectedBoarder.value.id;
    bookBoardingReq.additionalFacility = selectedFacilities;
    bookBoardingReq.totalAmount = totalAmount;
    debugPrint('PERCENTTAXAMOUNT: $percentTaxAmount');
    bookingSuccessDate(getDropOFFDateTime);
    log('BOOKBOARDINGREQ.TOJSON(): ${bookBoardingReq.toJson()}');
    hideKeyBoardWithoutContext();
    paymentController = PaymentController(bookingService: currentSelectedService.value);
    Get.to(() => const PaymentScreen());
  }
}
