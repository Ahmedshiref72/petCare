import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/utils/permissions.dart';
import '../../dashboard/dashboard_res_model.dart';
import '../model/booking_data_model.dart';
import 'location_service.dart';
import 'model/book_walking_req.dart';
import '../model/employe_model.dart';
import '../model/walking_model.dart';
import '../payment_screen.dart';
import '../services/services_form_api.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../payment_controller.dart';
import '../../pet/model/pet_list_res_model.dart';
import '../../pet/my_pets_controller.dart';
import '../model/choose_pet_widget.dart';

class WalkingServiceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool showBookBtn = false.obs;

  RxBool hasErrorFetchingWalker = false.obs;
  RxString errorMessageWalker = "".obs;
  BookWalkingReq bookWalkingReq = BookWalkingReq();
  Rx<DurationData> selectedDuration = DurationData().obs;

  Rx<EmployeeModel> selectedWalker = EmployeeModel(profileImage: "".obs).obs;
  RxList<EmployeeModel> walkerList = RxList();
  RxList<EmployeeModel> walkerFilterList = RxList();
  Rx<Future<List<DurationData>>> duration = Future(() => <DurationData>[]).obs;
  TextEditingController dateCont = TextEditingController();
  TextEditingController timeCont = TextEditingController();
  TextEditingController additionalInfoCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController walkerCont = TextEditingController();
  TextEditingController latitudeCont = TextEditingController();
  TextEditingController longitudeCont = TextEditingController();
  Rx<BookingDataModel> bookingFormData = BookingDataModel(service: SystemService(), payment: PaymentDetails(), training: Training()).obs;
  RxBool isUpdateForm = false.obs;
  RxBool isShowNearBy = false.obs;
  RxList<DurationData> durationList = RxList();

  //Search
  TextEditingController searchCont = TextEditingController();
  void toggleSwitch() {
    isShowNearBy.value = !isShowNearBy.value;
    handleCurrentLocationClick();
    getWalker();
  }

  @override
  void onInit() {
    bookWalkingReq.systemServiceId = currentSelectedService.value.id;
    if (Get.arguments is BookingDataModel) {
      try {
        isUpdateForm(true);
        bookingFormData(Get.arguments as BookingDataModel);
        additionalInfoCont.text = bookingFormData.value.service.description;
        addressCont.text = bookingFormData.value.address;
        debugPrint('BOOKINGFORMDATA.VALUE.DURATION: ${bookingFormData.value.duration}');
        duration(PetServiceFormApis.getDuration(serviceType: ServicesKeyConst.walking)).then((value) {
          selectedDuration(value.firstWhere((p0) => p0.duration == bookingFormData.value.duration, orElse: () => DurationData()));
          if (selectedDuration.value.id > 0 && selectedDuration.value.price > 0) {
            currentSelectedService.value.serviceAmount = selectedDuration.value.price.toDouble();
            bookWalkingReq.price = selectedDuration.value.price.toDouble();
            showBookBtn(true);
          }
        });
        getWalker();
        selectedPet(myPetsScreenController.myPets.firstWhere((element) => element.name.toLowerCase() == bookingFormData.value.petName.toLowerCase(), orElse: () => PetData()));
      } catch (e) {
        debugPrint('walking book again E: $e');
      }
    } else {
      duration(PetServiceFormApis.getDuration(serviceType: ServicesKeyConst.walking));
      getWalker();
      addressCont.text = loginUserData.value.address;
    }

    super.onInit();
  }

  void clearWalkerSelection() {
    walkerCont.clear();
    selectedWalker(EmployeeModel(profileImage: "".obs));
  }

  //Get Walker List
  getWalker() {
    isLoading(true);
    PetServiceFormApis.getEmployee(role: EmployeeKeyConst.walking, latitude: latitudeCont.text, longitude: longitudeCont.text, showNearby: isShowNearBy.value).then((value) {
      isLoading(false);
      walkerList(value.data);
      hasErrorFetchingWalker(false);
      if (isUpdateForm.value) {
        selectedWalker(walkerList.firstWhere((p0) => p0.id == bookingFormData.value.employeeId, orElse: () => EmployeeModel(profileImage: "".obs)));
        walkerCont.text = selectedWalker.value.fullName;
      }
    }).onError((error, stackTrace) {
      hasErrorFetchingWalker(true);
      errorMessageWalker(error.toString());
      isLoading(false);
      // toast(error.toString());
    });
  }

  void searchFunc({
    required String searchtext,
    required RxList<EmployeeModel> walkerFilterList,
    required RxList<EmployeeModel> walkerSList,
  }) {
    walkerFilterList.value = List.from(walkerSList.where((element) => element.fullName.toString().toLowerCase().contains(searchtext.toString().toLowerCase())));
    for (var i = 0; i < walkerFilterList.length; i++) {
      debugPrint('SEARCHEDNAMES : ${walkerFilterList[i].toJson()}');
    }
    debugPrint('SEARCHEDNAMES.LENGTH: ${walkerFilterList.length}');
  }

  void onSearchChange(searchtext) {
    searchFunc(
      searchtext: searchtext,
      walkerFilterList: walkerFilterList,
      walkerSList: walkerList,
    );
  }

  bool get isShowFullList => walkerFilterList.isEmpty && searchCont.text.trim().isEmpty;

  handleBookNowClick() {
    bookWalkingReq.address = addressCont.text.trim();
    bookWalkingReq.additionalInfo = additionalInfoCont.text.trim();
    bookWalkingReq.totalAmount = totalAmount;
    bookingSuccessDate("${bookWalkingReq.date} ${bookWalkingReq.time}".trim());
    debugPrint('BOOKBOARDINGREQ.TOJSON(): ${bookWalkingReq.toJson()}');
    hideKeyBoardWithoutContext();
    paymentController = PaymentController(bookingService: currentSelectedService.value);
    Get.to(() => const PaymentScreen());
  }

  void handleCurrentLocationClick() {
    Permissions.cameraFilesAndLocationPermissionsGranted().then((value) async {
      await setValue(PERMISSION_STATUS, value);
      if (value) {
        isLoading(true);
        await getUserLocation().then((value) {
          latitudeCont.text = getDoubleAsync(LATITUDE).toString();
          longitudeCont.text = getDoubleAsync(LONGITUDE).toString();
          getWalker();
        }).catchError((e) {
          log(e);
          toast(e.toString());
        });

        isLoading(false);
      }
    }).catchError((e) {
      //
    });
  }
}
