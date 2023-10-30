import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/network/zoom_services.dart';
import '../../dashboard/dashboard_res_model.dart';
import '../../shop/model/category_model.dart';
import '../model/booking_data_model.dart';
import '../payment_screen.dart';
import '../../../utils/constants.dart';

import 'model/book_veterinary_req.dart';
import '../model/employe_model.dart';
import '../model/service_model.dart';

import '../services/services_form_api.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../payment_controller.dart';
import '../../pet/model/pet_list_res_model.dart';
import '../../pet/my_pets_controller.dart';
import '../model/choose_pet_widget.dart';

class VeterineryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool showBookBtn = false.obs;
  RxBool refreshWidget = false.obs;
  RxList<PlatformFile> medicalReportfiles = RxList();
  BookVeterinaryReq bookVeterinaryReq = BookVeterinaryReq();
  //Category
  Rx<ShopCategoryModel> selectedVeterinaryType = ShopCategoryModel().obs;
  RxList<ShopCategoryModel> categoryList = RxList();
  RxList<ShopCategoryModel> categoryFilterList = RxList();
  //Error Category
  RxBool hasErrorFetchingVeterinaryType = false.obs;
  RxString errorMessageVeterinaryType = "".obs;
  //Service
  Rx<ServiceModel> selectedService = ServiceModel().obs;
  RxList<ServiceModel> serviceList = RxList();
  RxList<ServiceModel> serviceFilterList = RxList();
  //Error Service
  RxBool hasErrorFetchingService = false.obs;
  RxString errorMessageService = "".obs;
  //Vet
  Rx<EmployeeModel> selectedVet = EmployeeModel(profileImage: "".obs).obs;
  RxList<EmployeeModel> vetList = RxList();
  RxList<EmployeeModel> vetFilterList = RxList();
  //Error Vet
  RxBool hasErrorFetchingVet = false.obs;
  RxString errorMessageVet = "".obs;
  RxBool isUpdateForm = false.obs;
  // List<int> additionalFacility = [];
  TextEditingController dateCont = TextEditingController();
  TextEditingController timeCont = TextEditingController();
  TextEditingController veterinaryTypeCont = TextEditingController();
  TextEditingController serviceCont = TextEditingController();
  TextEditingController vetCont = TextEditingController();
  TextEditingController reasonCont = TextEditingController();
  Rx<BookingDataModel> bookingFormData = BookingDataModel(service: SystemService(), payment: PaymentDetails(), training: Training()).obs;

  //
  TextEditingController searchCont = TextEditingController();

  @override
  void onInit() {
    bookVeterinaryReq.systemServiceId = currentSelectedService.value.id;
    if (Get.arguments is BookingDataModel) {
      try {
        isUpdateForm(true);
        debugPrint('bookingFormData.value.veterinaryReason ==> ${bookingFormData.value.veterinaryReason.toString()}');
        bookingFormData(Get.arguments as BookingDataModel);
        reasonCont.text = bookingFormData.value.veterinaryReason.toString();
        getCategory();
        selectedPet(myPetsScreenController.myPets.firstWhere((element) => element.name.toLowerCase() == bookingFormData.value.petName.toLowerCase(), orElse: () => PetData()));
      } catch (e) {
        debugPrint('veterinery book again E: $e');
      }
    } else {
      getCategory();
    }

    super.onInit();
  }

  void reloadWidget() {
    refreshWidget(true);
    refreshWidget(false);
  }

  //
  Future<void> handleFilesPickerClick() async {
    final pickedFiles = await pickFiles();
    Set<String> filePathsSet = medicalReportfiles.map((file) => file.name.trim().toLowerCase()).toSet();
    for (var i = 0; i < pickedFiles.length; i++) {
      if (!filePathsSet.contains(pickedFiles[i].name.trim().toLowerCase())) {
        medicalReportfiles.add(pickedFiles[i]);
      }
    }
  }

  //Get Category List
  getCategory() {
    isLoading(true);
    PetServiceFormApis.getCategory(categoryType: ServicesKeyConst.veterinary).then((value) {
      isLoading(false);
      categoryList(value.data);
      hasErrorFetchingVeterinaryType(false);
      if (isUpdateForm.value) {
        selectedVeterinaryType(categoryList.firstWhere((p0) => p0.id == bookingFormData.value.categoryID, orElse: () => ShopCategoryModel()));
        veterinaryTypeCont.text = selectedVeterinaryType.value.name;
        getService();
      }
    }).onError((error, stackTrace) {
      hasErrorFetchingVeterinaryType(true);
      errorMessageVeterinaryType(error.toString());
      isLoading(false);
      // toast(error.toString());
    });
  }

  ///Get Service List
  getService() {
    isLoading(true);
    PetServiceFormApis.getService(type: ServicesKeyConst.veterinary, categoryId: selectedVeterinaryType.value.id.toString()).then((value) {
      isLoading(false);
      serviceList(value.data);
      hasErrorFetchingService(false);
      if (isUpdateForm.value) {
        selectedService(serviceList.firstWhere((p0) => p0.id == bookingFormData.value.service.id, orElse: () => ServiceModel()));
        serviceCont.text = selectedService.value.name;
        getVet();
      }
    }).onError((error, stackTrace) {
      hasErrorFetchingService(true);
      errorMessageService(error.toString());
      isLoading(false);
      // toast(error.toString());
    });
  }

  void clearVetSelection() {
    vetCont.clear();
    selectedVet(EmployeeModel(profileImage: "".obs));
  }

  //Get Vet List
  getVet() {
    isLoading(true);
    PetServiceFormApis.getEmployee(role: EmployeeKeyConst.veterinary, serviceId: selectedService.value.id.toString()).then((value) {
      isLoading(false);
      vetList(value.data);
      hasErrorFetchingVet(false);
      if (isUpdateForm.value) {
        selectedVet(vetList.firstWhere((p0) => p0.id == bookingFormData.value.employeeId, orElse: () => EmployeeModel(profileImage: "".obs)));
        vetCont.text = selectedVet.value.fullName;
      }
    }).onError((error, stackTrace) {
      hasErrorFetchingVet(true);
      errorMessageVet(error.toString());
      isLoading(false);
      // toast(error.toString());
    });
  }

  void searchServiceFunc({
    required String searchtext,
    required RxList<ServiceModel> serviceFilterList,
    required RxList<ServiceModel> serviceSList,
  }) {
    serviceFilterList.value = List.from(serviceSList.where((element) => element.name.toString().toLowerCase().contains(searchtext.toString().toLowerCase())));
    for (var i = 0; i < serviceFilterList.length; i++) {
      debugPrint('SEARCHEDNAMES : ${serviceFilterList[i].toJson()}');
    }
    debugPrint('SEARCHEDNAMES.LENGTH: ${serviceFilterList.length}');
  }

  void onServiceSearchChange(searchtext) {
    searchServiceFunc(
      searchtext: searchtext,
      serviceFilterList: serviceFilterList,
      serviceSList: serviceList,
    );
  }

  void searchCategoryFunc({
    required String searchtext,
    required RxList<ShopCategoryModel> categoryFilterList,
    required RxList<ShopCategoryModel> categorySList,
  }) {
    categoryFilterList.value = List.from(categorySList.where((element) => element.name.toString().toLowerCase().contains(searchtext.toString().toLowerCase())));
    for (var i = 0; i < categoryFilterList.length; i++) {
      debugPrint('SEARCHEDNAMES : ${categoryFilterList[i].toJson()}');
    }
    debugPrint('SEARCHEDNAMES.LENGTH: ${categoryFilterList.length}');
  }

  void onCategorySearchChange(searchtext) {
    searchCategoryFunc(
      searchtext: searchtext,
      categoryFilterList: categoryFilterList,
      categorySList: categoryList,
    );
  }

  void searchVetFunc({
    required String searchtext,
    required RxList<EmployeeModel> vetFilterList,
    required RxList<EmployeeModel> vetSList,
  }) {
    vetFilterList.value = List.from(vetSList.where((element) => element.fullName.toString().toLowerCase().contains(searchtext.toString().toLowerCase())));
    for (var i = 0; i < vetFilterList.length; i++) {
      debugPrint('SEARCHEDNAMES : ${vetFilterList[i].toJson()}');
    }
    debugPrint('SEARCHEDNAMES.LENGTH: ${vetFilterList.length}');
  }

  void onVetSearchChange(searchtext) {
    searchVetFunc(
      searchtext: searchtext,
      vetFilterList: vetFilterList,
      vetSList: vetList,
    );
  }

  bool get isShowCategoryFullList => categoryFilterList.isEmpty && searchCont.text.trim().isEmpty;
  bool get isShowServiceFullList => serviceFilterList.isEmpty && searchCont.text.trim().isEmpty;
  bool get isShowVetFullList => vetFilterList.isEmpty && searchCont.text.trim().isEmpty;

  handleBookNowClick() {
    bookVeterinaryReq.reason = reasonCont.text.trim();
    bookVeterinaryReq.totalAmount = totalAmount;
    bookVeterinaryReq.employeeId = selectedVet.value.id;
    bookVeterinaryReq.serviceId = selectedService.value.id;
    bookVeterinaryReq.serviceName = selectedService.value.name;
    bookVeterinaryReq.duration = selectedService.value.durationMin.toString();
    bookingSuccessDate("${bookVeterinaryReq.date} ${bookVeterinaryReq.time}".trim());
    debugPrint('BOOKBOARDINGREQ.TOJSON(): ${bookVeterinaryReq.toJson()}');
    if (selectedVeterinaryType.value.name.toLowerCase().contains(ServicesKeyConst.videoConsultancyName.toLowerCase()) || selectedService.value.name.toLowerCase().contains(ServicesKeyConst.videoConsultancyName.toLowerCase())) {
      ZoomServices.generateZoomMeetingLink(topic: selectedService.value.name, startTime: bookVeterinaryReq.toJson()["date_time"].toString().dateInyyyyMMddHHmmFormat, durationInMinuts: selectedService.value.durationMin).then((value) {
        bookVeterinaryReq.startVideoLink = value.startUrl;
        bookVeterinaryReq.joinVideoLink = value.joinUrl;
      });
    }
    hideKeyBoardWithoutContext();
    paymentController = PaymentController(bookingService: currentSelectedService.value);
    Get.to(() => const PaymentScreen());
  }

  ///
  ///TODO Don't Remove
  /* saveVetBookingApi() {
    bookVeterinaryReq.reason = reasonCont.text.trim();
    bookVeterinaryReq.otherMedicalReport = otherMedicalReportCont.text.trim();
    bookVeterinaryReq.totalAmount = totalAmount;
    bookVeterinaryReq.employeeId = selectedVet.value.id;
    bookVeterinaryReq.serviceId = selectedService.value.id;
    bookVeterinaryReq.serviceName = selectedService.value.name;
    bookVeterinaryReq.duration = selectedService.value.durationMin.toString();
    debugPrint('BOOKBOARDINGREQ.TOJSON(): ${bookVeterinaryReq.toJson()}');
    isLoading(true);
    hideKeyBoardWithoutContext();
    PetServiceFormApis.bookServiceApi(
      request: bookVeterinaryReq.toJson(),
      files: medicalReportfiles.isNotEmpty ? medicalReportfiles : null,
      onSuccess: () {
        isLoading(false);
        onBookingSuccess(bookingType: ServicesKeyConst.veterinary);
      },
      loaderOff: () {
        isLoading(false);
      },
    ).then((value) {}).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  } */
}
