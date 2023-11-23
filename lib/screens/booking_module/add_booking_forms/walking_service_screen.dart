import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/auth/profile/add_address_screen.dart';
import 'package:pawlly/screens/auth/profile/select_address_controller.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/bottom_selection_widget.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/service_app_button.dart';
import '../../../generated/assets.dart';
import 'walking_service_controller.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../model/choose_pet_widget.dart';
import '../model/employe_model.dart';

class WalkingServiceScreen extends StatelessWidget {
  WalkingServiceScreen({Key? key}) : super(key: key);
  final WalkingServiceController walkingServiceController =
      Get.put(WalkingServiceController());
  final GlobalKey<FormState> _walkingformKey = GlobalKey();

  final SelectAddressController selectAddressController =
      Get.put(SelectAddressController());
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: Hero(
        tag: currentSelectedService.value.name,
        child: Text(
          "${locale.value.book} ${currentSelectedService.value.name.capitalizeEachWord()}",
          style: primaryTextStyle(size: 16, decoration: TextDecoration.none),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(bottom: 32),
            child: Form(
              key: _walkingformKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  ChooseYourPet(
                    onChanged: (selectedPet) {
                      walkingServiceController.bookWalkingReq.petId =
                          selectedPet.id;
                    },
                  ),
                  32.height,
                  dateTimeWidget(context),
                  32.height,
                  Obx(() => durationWidget()),
                  32.height,
                  //TODO
                  // AppTextField(
                  //   title: locale.value.dropoffPickupAddress,
                  //   textStyle: primaryTextStyle(size: 12),
                  //   textFieldType: TextFieldType.MULTILINE,
                  //   minLines: 5,
                  //   controller: walkingServiceController.addressCont,
                  //   // focus: editUserProfileController.addressFocus,
                  //   decoration: inputDecoration(
                  //     context,
                  //     hintText: locale.value.writeHere,
                  //     fillColor: context.cardColor,
                  //     filled: true,
                  //   ),
                  // ).paddingSymmetric(horizontal: 16),

                  // Obx(() {
                  //   var addresses = selectAddressController
                  //       .addressList; // Accessing the address list
                  //   if (addresses.isEmpty) {
                  //     return Text('No addresses available');
                  //   }
                  //   return Column(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //         child: DropdownButtonFormField<UserAddress>(
                  //           decoration: InputDecoration(
                  //             border: OutlineInputBorder(

                  //               borderRadius: BorderRadius.circular(10.0),
                  //               borderSide: const BorderSide(color:  Colors.white)
                  //             ),
                  //             filled: true,
                  //             fillColor: Colors.white,
                  //           ),
                  //           hint: Text(locale.value.myAddresses),
                  //           value: walkingServiceController.selectedAddress
                  //               .value, // Use the value of selectedAddress
                  //           onChanged: (UserAddress? newValue) {
                  //             walkingServiceController.selectedAddress.value =
                  //                 newValue; // Update the Rx variable directly
                  //           },
                  //           items: addresses.map<DropdownMenuItem<UserAddress>>(
                  //               (UserAddress address) {
                  //             return DropdownMenuItem<UserAddress>(
                  //               value: address,
                  //               child: Text(address
                  //                   .addressLine1), // Display addressLine1 instead of the entire UserAddress object
                  //             );
                  //           }).toList(),
                  //           dropdownColor: Colors.white,
                  //           icon: const Icon(Icons.arrow_drop_down,
                  //               color: Colors.grey),
                  //           iconSize: 24,
                  //           elevation: 16,
                  //           alignment: AlignmentDirectional.bottomCenter,
                  //           menuMaxHeight: 200,
                  //         ),
                  //       ),
                  //     ],
                  //   );
                  // }),

                  24.height,
                  SizedBox(
                    height: 32,
                    child: Row(
                      children: [
                        Text(locale.value.myAddresses,
                                style: primaryTextStyle())
                            .paddingSymmetric(horizontal: 16),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Obx(
                    () => AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: TextEditingController(
                        text: walkingServiceController
                                .selectedAddress.value?.addressLine1 ??
                            '',
                      ),
                      textFieldType: TextFieldType.OTHER,
                      readOnly: true,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Obx(
                              () {
                                if (selectAddressController.isLoading.isTrue) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (selectAddressController
                                    .addressList.isEmpty) {
                                  return Center(
                                      child: InkWell(
                                          onTap: () {
                                            Get.to(() => AddAddressScreen());
                                          },
                                          child: const Text(
                                              'No addresses available, tap here to add one ')));
                                }

                                return ListView.builder(
                                  itemCount: selectAddressController
                                      .addressList.length,
                                  itemBuilder: (context, index) {
                                    var address = selectAddressController
                                        .addressList[index];
                                    return ListTile(
                                      title: Text(address.addressLine1),
                                      onTap: () {
                                        walkingServiceController
                                            .selectedAddress.value = address;
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      decoration: inputDecoration(
                        context,
                        hintText: 'Choose Address',
                        fillColor: context.cardColor,
                        filled: true,
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                  ),

                  24.height,
                  SizedBox(
                    height: 32,
                    child: Row(
                      children: [
                        Text(locale.value.walker, style: primaryTextStyle())
                            .paddingSymmetric(horizontal: 16),
                        const Spacer(),
                        Obx(
                          () => Row(
                            children: [
                              Text(
                                locale.value.showNearby,
                                style:
                                    secondaryTextStyle(color: darkGrayGeneral),
                              ),
                              Transform.scale(
                                scale: 0.65,
                                child: Switch(
                                  activeTrackColor: switchActiveTrackColor,
                                  value: walkingServiceController
                                      .isShowNearBy.value,
                                  activeColor: switchActiveColor,
                                  inactiveTrackColor:
                                      switchColor.withOpacity(0.2),
                                  onChanged: (bool value) {
                                    walkingServiceController
                                            .isShowNearBy.value =
                                        !walkingServiceController
                                            .isShowNearBy.value;

                                    if (walkingServiceController
                                        .isShowNearBy.value) {
                                      walkingServiceController
                                          .handleCurrentLocationClick();
                                    } else {
                                      walkingServiceController.getWalker();
                                    }
                                  },
                                ),
                              ),
                              8.width,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => AppTextField(
                      /*  title: locale.value.walker,*/
                      spacingBetweenTitleAndTextFormField: 0,
                      textStyle: primaryTextStyle(size: 12),
                      controller: walkingServiceController.walkerCont,
                      textFieldType: TextFieldType.OTHER,
                      readOnly: true,
                      onTap: () {
                        serviceCommonBottomSheet(context,
                            child: Obx(
                              () => BottomSelectionSheet(
                                title: locale.value.chooseWalker,
                                hintText: locale.value.searchForWalker,
                                controller: walkingServiceController.searchCont,
                                onChanged:
                                    walkingServiceController.onSearchChange,
                                hasError: walkingServiceController
                                    .hasErrorFetchingWalker.value,
                                isEmpty: walkingServiceController.isShowFullList
                                    ? walkingServiceController
                                        .walkerList.isEmpty
                                    : walkingServiceController
                                        .walkerFilterList.isEmpty,
                                errorText: walkingServiceController
                                    .errorMessageWalker.value,
                                isLoading: walkingServiceController.isLoading,
                                noDataTitle: locale.value.walkerListIsEmpty,
                                noDataSubTitle: locale.value.thereAreNoWalkers,
                                onRetry: () {
                                  walkingServiceController.getWalker();
                                },
                                listWidget: Obx(
                                  () => walkerListWid(
                                    walkingServiceController.isShowFullList
                                        ? walkingServiceController.walkerList
                                        : walkingServiceController
                                            .walkerFilterList,
                                  ).expand(),
                                ),
                              ),
                            ));
                      },
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.chooseWalker,
                        fillColor: context.cardColor,
                        filled: true,
                        prefixIconConstraints:
                            BoxConstraints.loose(const Size.square(60)),
                        prefixIcon: walkingServiceController.selectedWalker
                                    .value.profileImage.isEmpty &&
                                walkingServiceController
                                    .selectedWalker.value.id.isNegative
                            ? null
                            : CachedImageWidget(
                                url: walkingServiceController
                                    .selectedWalker.value.profileImage.value,
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                                circle: true,
                                usePlaceholderIfUrlEmpty: true,
                              ).paddingOnly(
                                left: 12, top: 8, bottom: 8, right: 12),
                        suffixIcon: walkingServiceController.selectedWalker
                                    .value.profileImage.isEmpty &&
                                walkingServiceController
                                    .selectedWalker.value.id.isNegative
                            ? Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 24,
                                color: darkGray.withOpacity(0.5),
                              )
                            : appCloseIconButton(
                                context,
                                onPressed: () {
                                  walkingServiceController
                                      .clearWalkerSelection();
                                },
                                size: 11,
                              ),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                  ),
                  32.height,
                  AppTextField(
                    title: locale.value.additionalInformation,
                    textStyle: primaryTextStyle(size: 12),
                    textFieldType: TextFieldType.MULTILINE,
                    isValidationRequired: false,
                    minLines: 5,
                    controller: walkingServiceController.additionalInfoCont,
                    // focus: editUserProfileController.addressFocus,
                    decoration: inputDecoration(context,
                        hintText: locale.value.writeHere,
                        fillColor: context.cardColor,
                        filled: true),
                  ).paddingSymmetric(horizontal: 16),
                ],
              ),
            ),
          ).expand(),
          Obx(
            () => AppButtonWithPricing(
              price: totalAmount.toStringAsFixed(2).toDouble(),
              tax: totalTax.toStringAsFixed(2).toDouble(),
              items: currentSelectedService.value.name.capitalizeFirstLetter(),
              serviceImg: currentSelectedService.value.serviceImage,
              onTap: () {
                if (_walkingformKey.currentState!.validate()) {
                  _walkingformKey.currentState!.save();
                  if (walkingServiceController.selectedDuration.value.id > 0 &&
                      walkingServiceController.bookWalkingReq.petId > 0) {
                    hideKeyboard(context);
                    walkingServiceController.handleBookNowClick();
                  } else if (walkingServiceController
                          .selectedDuration.value.id <=
                      0) {
                    toast(locale.value.pleaseChooseDuration);
                  } else if (walkingServiceController.bookWalkingReq.petId <=
                      0) {
                    toast(locale.value.pleaseSelectPet);
                  }
                }
              },
            )
                .paddingSymmetric(horizontal: 16)
                .visible(walkingServiceController.showBookBtn.value),
          ),
        ],
      ),
    );
  }

  Widget dateTimeWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  title: locale.value.date,
                  textStyle: primaryTextStyle(size: 12),
                  controller: walkingServiceController.dateCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));
                    if (selectedDate != null) {
                      walkingServiceController.bookWalkingReq.date =
                          selectedDate.formatDateYYYYmmdd();
                      walkingServiceController.dateCont.text =
                          selectedDate.formatDateDDMMYY();
                      debugPrint(
                          'walkingServiceController.BOOKBOARDINGREQ: ${walkingServiceController.bookWalkingReq.toJson()}');
                    } else {
                      log("Date is not selected");
                    }
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectDate,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: Assets.navigationIcCalendarOutlined
                        .iconImage(
                            color: secondaryTextColor, fit: BoxFit.contain)
                        .paddingAll(14),
                  ),
                ),
              ],
            ).expand(),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  title: locale.value.time,
                  textStyle: primaryTextStyle(size: 12),
                  controller: walkingServiceController.timeCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    if (walkingServiceController.dateCont.text.trim().isEmpty) {
                      toast(locale.value.pleaseSelectDateFirst);
                    } else {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      if (pickedTime != null) {
                        if ("${walkingServiceController.bookWalkingReq.date} ${pickedTime.formatTimeHHmm24Hour()}"
                            .isAfterCurrentDateTime) {
                          walkingServiceController.bookWalkingReq.time =
                              pickedTime.formatTimeHHmm24Hour();
                          walkingServiceController.timeCont.text =
                              pickedTime.formatTimeHHmmAMPM();
                        } else {
                          toast(locale.value.oopsItSeemsYouVe);
                        }
                      } else {
                        log("Time is not selected");
                      }
                    }
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectTime,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: Assets.iconsIcTimeOutlined
                        .iconImage(
                            color: secondaryTextColor, fit: BoxFit.contain)
                        .paddingAll(14),
                  ),
                ),
              ],
            ).expand(),
          ],
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }

  Widget durationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.duration, style: primaryTextStyle())
            .paddingSymmetric(horizontal: 16),
        8.height,
        Obx(() => SnapHelperWidget(
            future: walkingServiceController.duration.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
              ).paddingSymmetric(horizontal: 32);
            },
            loadingWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${locale.value.loading}... ",
                    style: secondaryTextStyle(
                        size: 14, fontFamily: fontFamilyFontBold)),
              ],
            ),
            onSuccess: (durationList) {
              return durationList.isEmpty
                  ? NoDataWidget(
                      title: locale.value.durationListIsEmpty,
                      subTitle: locale.value.theDurationListIs,
                      titleTextStyle: primaryTextStyle(),
                    ).paddingSymmetric(horizontal: 32)
                  : HorizontalList(
                      itemCount: durationList.length,
                      spacing: 16,
                      runSpacing: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        return Obx(
                          () => InkWell(
                            onTap: () {
                              walkingServiceController
                                  .selectedDuration(durationList[index]);
                              walkingServiceController.bookWalkingReq.duration =
                                  durationList[index].duration.toString();
                              currentSelectedService.value.serviceAmount =
                                  walkingServiceController
                                      .selectedDuration.value.price
                                      .toDouble();
                              walkingServiceController.bookWalkingReq.price =
                                  walkingServiceController
                                      .selectedDuration.value.price
                                      .toDouble();
                              walkingServiceController.showBookBtn(false);
                              walkingServiceController.showBookBtn(true);
                            },
                            borderRadius: radius(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: boxDecorationDefault(
                                color: walkingServiceController
                                            .selectedDuration.value ==
                                        durationList[index]
                                    ? isDarkMode.value
                                        ? darkGrayGeneral2
                                        : lightPrimaryColor
                                    : context.cardColor,
                              ),
                              child: Text(
                                durationList[index]
                                    .duration
                                    .toFormattedDuration(),
                                style: secondaryTextStyle(
                                  color: walkingServiceController
                                              .selectedDuration.value ==
                                          durationList[index]
                                      ? primaryColor
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
            })),
      ],
    );
  }

  Widget walkerListWid(List<EmployeeModel> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].fullName,
          subTitle: walkingServiceController.isLoading.value
              ? "${locale.value.loading}... "
              : walkingServiceController.isShowNearBy.value
                  ? list[index].distance > 0
                      ? "${list[index].distance} ${locale.value.milesAway}"
                      : "Distance Not Availabe"
                  : null,
          titleTextStyle: primaryTextStyle(size: 14),
          leading: CachedImageWidget(
              url: list[index].profileImage.value,
              height: 35,
              fit: BoxFit.cover,
              width: 35,
              circle: true),
          onTap: () {
            walkingServiceController.selectedWalker(list[index]);
            walkingServiceController.walkerCont.text =
                walkingServiceController.selectedWalker.value.fullName;
            walkingServiceController.bookWalkingReq.employeeId =
                walkingServiceController.selectedWalker.value.id;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) =>
          commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
