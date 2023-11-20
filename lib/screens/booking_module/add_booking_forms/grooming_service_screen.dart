import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';

import '../../../components/app_scaffold.dart';
import '../../../components/bottom_selection_widget.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/service_app_button.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../model/choose_pet_widget.dart';
import '../model/employe_model.dart';
import '../model/service_model.dart';
import 'grooming_service_controller.dart';

class GroomingScreen extends StatelessWidget {
  GroomingScreen({Key? key}) : super(key: key);
  final GroomingController groomingController = Get.put(GroomingController());
  final GlobalKey<FormState> _groomingformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.grooming,
      appBarTitle: Hero(
        tag: currentSelectedService.value.name,
        child: Text(
          "${locale.value.book} ${currentSelectedService.value.name.capitalizeEachWord()}",
          style: primaryTextStyle(size: 16, decoration: TextDecoration.none),
        ),
      ),
      isLoading: groomingController.isLoading,
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(bottom: 32),
            child: Form(
              key: _groomingformKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  ChooseYourPet(
                    onChanged: (selectedPet) {
                      groomingController.bookGroomingReq.petId = selectedPet.id;
                    },
                  ),
                  32.height,
                  dateTimeWidget(context),
                  32.height,
                  Obx(
                    () => AppTextField(
                      title: locale.value.service,
                      textStyle: primaryTextStyle(size: 12),
                      controller: groomingController.serviceCont,
                      textFieldType: TextFieldType.OTHER,
                      readOnly: true,
                      onTap: () async {
                        groomingController.serviceFilterList.clear();
                        groomingController.searchCont.clear();
                        serviceCommonBottomSheet(
                          context,
                          child: BottomSelectionSheet(
                            title: locale.value.chooseService,
                            hintText: locale.value.searchForService,
                            controller: groomingController.searchCont,
                            onChanged: groomingController.onServiceSearchChange,
                            hasError: groomingController
                                .hasErrorFetchingService.value,
                            isEmpty: groomingController.isShowFullList
                                ? groomingController.serviceList.isEmpty
                                : groomingController.serviceFilterList.isEmpty,
                            errorText:
                                groomingController.errorMessageService.value,
                            noDataTitle: locale.value.serviceListIsEmpty,
                            noDataSubTitle: locale.value.thereAreNoServices,
                            isLoading: groomingController.isLoading,
                            onRetry: () {
                              groomingController.getService();
                            },
                            listWidget: Obx(
                              () => grommingServiceListWid(
                                groomingController.isShowFullList
                                    ? groomingController.serviceList
                                    : groomingController.serviceFilterList,
                              ).expand(),
                            ),
                          ),
                        );
                      },
                      decoration: inputDecoration(context,
                          hintText: locale.value.chooseService,
                          fillColor: context.cardColor,
                          filled: true,
                          prefixIconConstraints:
                              BoxConstraints.loose(const Size.square(60)),
                          prefixIcon: groomingController.selectedService.value
                                      .serviceImage.isEmpty &&
                                  groomingController
                                      .selectedService.value.id.isNegative
                              ? null
                              : CachedImageWidget(
                                  url: groomingController
                                      .selectedService.value.serviceImage,
                                  height: 35,
                                  width: 35,
                                  firstName: groomingController
                                      .selectedService.value.name,
                                  fit: BoxFit.cover,
                                  circle: true,
                                  usePlaceholderIfUrlEmpty: true,
                                ).paddingOnly(
                                  left: 12, top: 8, bottom: 8, right: 12),
                          suffixIcon: groomingController.selectedService.value
                                      .serviceImage.isNotEmpty &&
                                  groomingController
                                      .selectedService.value.id.isNegative
                              ? Icon(Icons.keyboard_arrow_down_rounded,
                                  size: 24, color: darkGray.withOpacity(0.5))
                              : Icon(Icons.keyboard_arrow_down_rounded,
                                  size: 24, color: darkGray.withOpacity(0.5))),
                    )
                        .paddingSymmetric(horizontal: 16)
                        .visible(!groomingController.isRefresh.value),
                  ),
                  32.height,
                  Obx(
                    () => AppTextField(
                      title: locale.value.groomer,
                      textStyle: primaryTextStyle(size: 12),
                      controller: groomingController.groomerCont,
                      textFieldType: TextFieldType.OTHER,
                      readOnly: true,
                      onTap: () async {
                        groomingController.groomerFilterList.clear();
                        groomingController.searchCont.clear();
                        if (groomingController
                            .selectedService.value.id.isNegative) {
                          toast(locale.value.pleaseSelectService);
                          return;
                        }
                        serviceCommonBottomSheet(
                          context,
                          child: Obx(
                            () => BottomSelectionSheet(
                              title: locale.value.chooseGroomer,
                              hintText: locale.value.searchForGroomer,
                              controller: groomingController.searchCont,
                              onChanged: (p0) {
                                debugPrint('P0: $p0');
                                groomingController.onGroomerSearchChange(p0);
                              },
                              hasError: groomingController
                                  .hasErrorFetchingGroomer.value,
                              isEmpty: groomingController.isShowGroomerFullList
                                  ? groomingController.groomerList.isEmpty
                                  : groomingController
                                      .groomerFilterList.isEmpty,
                              errorText:
                                  groomingController.errorMessageGroomer.value,
                              noDataTitle: locale.value.groomerListIsEmpty,
                              noDataSubTitle: locale.value.thereAreNoGroomers,
                              isLoading: groomingController.isLoading,
                              onRetry: () {
                                groomingController.getGroomer();
                              },
                              listWidget: Obx(
                                () => groomerListWid(
                                  groomingController.isShowGroomerFullList
                                      ? groomingController.groomerList
                                      : groomingController.groomerFilterList,
                                ).expand(),
                              ),
                            ),
                          ),
                        );
                      },
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.chooseGroomer,
                        fillColor: context.cardColor,
                        filled: true,
                        prefixIconConstraints:
                            BoxConstraints.loose(const Size.square(60)),
                        prefixIcon: groomingController.selectedGroomer.value
                                    .profileImage.isEmpty &&
                                groomingController
                                    .selectedGroomer.value.id.isNegative
                            ? null
                            : CachedImageWidget(
                                url: groomingController
                                    .selectedGroomer.value.profileImage.value,
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                                circle: true,
                              ).paddingOnly(
                                left: 12, top: 8, bottom: 8, right: 12),
                        suffixIcon: groomingController.selectedGroomer.value
                                    .profileImage.isEmpty &&
                                groomingController
                                    .selectedGroomer.value.id.isNegative
                            ? Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 24,
                                color: darkGray.withOpacity(0.5),
                              )
                            : appCloseIconButton(
                                context,
                                onPressed: () {
                                  groomingController.clearGroomerSelection();
                                },
                                size: 11,
                              ),
                      ),
                    )
                        .paddingSymmetric(horizontal: 16)
                        .visible(!groomingController.isRefresh.value),
                  ),
                  32.height,
                  AppTextField(
                    title: locale.value.additionalInformation,
                    textStyle: primaryTextStyle(size: 12),
                    textFieldType: TextFieldType.MULTILINE,
                    isValidationRequired: false,
                    minLines: 5,
                    controller: groomingController.additionalInfoCont,
                    // focus: editUserProfileController.addressFocus,
                    decoration: inputDecoration(context,
                        hintText: locale.value.writeHereee,
                        fillColor: context.cardColor,
                        filled: true),
                  ).paddingSymmetric(horizontal: 16),
                  96.height,
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
                if (_groomingformKey.currentState!.validate()) {
                  _groomingformKey.currentState!.save();
                  if (groomingController.bookGroomingReq.petId > 0) {
                    hideKeyboard(context);
                    groomingController.handleBookNowClick();
                  } else {
                    toast(locale.value.pleaseSelectPet);
                  }
                }
              },
            )
                .paddingSymmetric(horizontal: 16)
                .visible(groomingController.showBookBtn.value),
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
                  controller: groomingController.dateCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));

                    if (selectedDate != null) {
                      groomingController.bookGroomingReq.date =
                          selectedDate.formatDateYYYYmmdd();
                      groomingController.dateCont.text =
                          selectedDate.formatDateDDMMYY();
                      debugPrint(
                          'REQ: ${groomingController.bookGroomingReq.toJson()}');
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
                  controller: groomingController.timeCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    if (groomingController.dateCont.text.trim().isEmpty) {
                      toast(locale.value.pleaseSelectDateFirst);
                    } else {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        if ("${groomingController.bookGroomingReq.date} ${pickedTime.formatTimeHHmm24Hour()}"
                            .isAfterCurrentDateTime) {
                          groomingController.bookGroomingReq.time =
                              pickedTime.formatTimeHHmm24Hour();
                          groomingController.timeCont.text =
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

  Widget grommingServiceListWid(List<ServiceModel> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          leading: CachedImageWidget(
              url: list[index].serviceImage,
              height: 35,
              fit: BoxFit.cover,
              width: 35,
              circle: true),
          onTap: () {
            groomingController.selectedService(list[index]);
            groomingController.serviceCont.text =
                groomingController.selectedService.value.name;
            groomingController.bookGroomingReq.price =
                groomingController.serviceList[index].defaultPrice;
            currentSelectedService.value.serviceAmount = groomingController
                .selectedService.value.defaultPrice
                .toDouble();
            groomingController.groomerCont.clear();
            groomingController.selectedGroomer =
                EmployeeModel(profileImage: "".obs).obs;
            groomingController.getGroomer();
            groomingController.showBookBtn(false);
            groomingController.showBookBtn(true);
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) =>
          commonDivider.paddingSymmetric(vertical: 6),
    );
  }

  Widget groomerListWid(List<EmployeeModel> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].fullName,
          titleTextStyle: primaryTextStyle(size: 14),
          leading: CachedImageWidget(
              url: list[index].profileImage.value,
              height: 35,
              fit: BoxFit.cover,
              width: 35,
              circle: true),
          onTap: () {
            groomingController.selectedGroomer(list[index]);
            groomingController.groomerCont.text =
                groomingController.selectedGroomer.value.fullName;
            groomingController.bookGroomingReq.employeeId =
                groomingController.selectedGroomer.value.id;
            groomingController.reloadWidget();
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) =>
          commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
