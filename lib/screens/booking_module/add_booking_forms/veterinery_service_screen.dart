import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';

import '../../../components/app_scaffold.dart';
import '../../../components/bottom_selection_widget.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/event_file_widget.dart';
import '../../../components/service_app_button.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../shop/model/category_model.dart';
import '../model/choose_pet_widget.dart';
import '../model/employe_model.dart';
import '../model/service_model.dart';
import 'veterinery_service_controller.dart';

class VeterineryServiceScreen extends StatelessWidget {
  VeterineryServiceScreen({Key? key}) : super(key: key);
  final VeterineryController veterineryController =
      Get.put(VeterineryController());
  final GlobalKey<FormState> _veterineryformKey = GlobalKey();

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
      isLoading: veterineryController.isLoading,
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(bottom: 32),
            child: Form(
              key: _veterineryformKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  ChooseYourPet(
                    onChanged: (selectedPet) {
                      veterineryController.bookVeterinaryReq.petId =
                          selectedPet.id;
                    },
                  ),
                  32.height,
                  dateTimeWidget(context),
                  32.height,
                  Obx(
                    () => AppTextField(
                      title: locale.value.veterinaryType,
                      textStyle: primaryTextStyle(size: 12),
                      controller: veterineryController.veterinaryTypeCont,
                      textFieldType: TextFieldType.NAME,
                      readOnly: true,
                      onTap: () async {
                        serviceCommonBottomSheet(
                          context,
                          child: Obx(
                            () => BottomSelectionSheet(
                              title: locale.value.chooseVeterinaryType,
                              hintText: locale.value.searchForVeterinary,
                              controller: veterineryController.searchCont,
                              onChanged:
                                  veterineryController.onCategorySearchChange,
                              hasError: veterineryController
                                  .hasErrorFetchingVeterinaryType.value,
                              isEmpty: veterineryController
                                      .isShowCategoryFullList
                                  ? veterineryController.categoryList.isEmpty
                                  : veterineryController
                                      .categoryFilterList.isEmpty,
                              errorText: veterineryController
                                  .errorMessageVeterinaryType.value,
                              noDataTitle: locale.value.veterinaryTypeListIs,
                              noDataSubTitle: locale.value.thereAreNoVeterinary,
                              isLoading: veterineryController.isLoading,
                              onRetry: () {
                                veterineryController.getCategory();
                              },
                              listWidget: Obx(
                                () => veterinaryTypeListWid(
                                  veterineryController.isShowCategoryFullList
                                      ? veterineryController.categoryList
                                      : veterineryController.categoryFilterList,
                                ).expand(),
                              ),
                            ),
                          ),
                        );
                      },
                      decoration: inputDecoration(context,
                          hintText: locale.value.chooseVeterinaryType,
                          fillColor: context.cardColor,
                          filled: true,
                          prefixIconConstraints:
                              BoxConstraints.loose(const Size.square(60)),
                          prefixIcon: veterineryController.selectedVeterinaryType.value.categoryImage.isEmpty &&
                                  veterineryController.selectedVeterinaryType
                                      .value.id.isNegative
                              ? null
                              : CachedImageWidget(
                                  url: veterineryController
                                      .selectedVeterinaryType
                                      .value
                                      .categoryImage,
                                  height: 35,
                                  width: 35,
                                  firstName: veterineryController
                                      .selectedVeterinaryType.value.name,
                                  fit: BoxFit.cover,
                                  circle: true,
                                  usePlaceholderIfUrlEmpty: true,
                                ).paddingOnly(
                                  left: 12, top: 8, bottom: 8, right: 12),
                          suffixIcon: veterineryController
                                      .selectedVeterinaryType
                                      .value
                                      .categoryImage
                                      .isNotEmpty &&
                                  veterineryController.selectedVeterinaryType
                                      .value.id.isNegative
                              ? Icon(Icons.keyboard_arrow_down_rounded,
                                  size: 24, color: darkGray.withOpacity(0.5))
                              : Icon(Icons.keyboard_arrow_down_rounded,
                                  size: 24, color: darkGray.withOpacity(0.5))),
                    )
                        .paddingSymmetric(horizontal: 16)
                        .visible(!veterineryController.refreshWidget.value),
                  ),
                  32.height,
                  Obx(
                    () => AppTextField(
                      title: locale.value.service,
                      textStyle: primaryTextStyle(size: 12),
                      controller: veterineryController.serviceCont,
                      textFieldType: TextFieldType.NAME,
                      readOnly: true,
                      onTap: () async {
                        if (veterineryController
                            .selectedVeterinaryType.value.id.isNegative) {
                          toast(locale.value.pleaseSelectVeterinaryType);
                          return;
                        }
                        veterineryController.serviceFilterList.clear();
                        veterineryController.searchCont.clear();
                        serviceCommonBottomSheet(
                          context,
                          child: Obx(
                            () => BottomSelectionSheet(
                              title: locale.value.chooseService,
                              hintText: locale.value.searchForService,
                              controller: veterineryController.searchCont,
                              onChanged:
                                  veterineryController.onServiceSearchChange,
                              hasError: veterineryController
                                  .hasErrorFetchingService.value,
                              isEmpty:
                                  veterineryController.isShowServiceFullList
                                      ? veterineryController.serviceList.isEmpty
                                      : veterineryController
                                          .serviceFilterList.isEmpty,
                              errorText: veterineryController
                                  .errorMessageService.value,
                              noDataTitle: locale.value.serviceListIsEmpty,
                              noDataSubTitle: locale.value.thereAreNoServices,
                              isLoading: veterineryController.isLoading,
                              onRetry: () {
                                veterineryController.getService();
                              },
                              listWidget: Obx(
                                () => serviceListWid(
                                  veterineryController.isShowServiceFullList
                                      ? veterineryController.serviceList
                                      : veterineryController.serviceFilterList,
                                ).expand(),
                              ),
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
                          prefixIcon: veterineryController.selectedService.value
                                      .serviceImage.isEmpty &&
                                  veterineryController
                                      .selectedService.value.id.isNegative
                              ? null
                              : CachedImageWidget(
                                  url: veterineryController
                                      .selectedService.value.serviceImage,
                                  height: 35,
                                  width: 35,
                                  firstName: veterineryController
                                      .selectedService.value.name,
                                  fit: BoxFit.cover,
                                  circle: true,
                                  usePlaceholderIfUrlEmpty: true,
                                ).paddingOnly(
                                  left: 12, top: 8, bottom: 8, right: 12),
                          suffixIcon: veterineryController.selectedService.value
                                      .serviceImage.isNotEmpty &&
                                  veterineryController
                                      .selectedService.value.id.isNegative
                              ? Icon(Icons.keyboard_arrow_down_rounded,
                                  size: 24, color: darkGray.withOpacity(0.5))
                              : Icon(Icons.keyboard_arrow_down_rounded,
                                  size: 24, color: darkGray.withOpacity(0.5))),
                    )
                        .paddingSymmetric(horizontal: 16)
                        .visible(!veterineryController.refreshWidget.value),
                  ),
                  32.height,
                  Obx(
                    () => AppTextField(
                      title: locale.value.vet,
                      textStyle: primaryTextStyle(size: 12),
                      controller: veterineryController.vetCont,
                      textFieldType: TextFieldType.OTHER,
                      readOnly: true,
                      onTap: () async {
                        if (veterineryController
                            .selectedService.value.id.isNegative) {
                          toast(locale.value.pleaseSelectService);
                          return;
                        }
                        serviceCommonBottomSheet(
                          context,
                          child: Obx(
                            () => BottomSelectionSheet(
                              title: locale.value.chooseVet,
                              hintText: locale.value.searchForVet,
                              controller: veterineryController.searchCont,
                              onChanged: veterineryController.onVetSearchChange,
                              hasError: veterineryController
                                  .hasErrorFetchingVet.value,
                              isEmpty: veterineryController.isShowVetFullList
                                  ? veterineryController.vetList.isEmpty
                                  : veterineryController.vetFilterList.isEmpty,
                              errorText:
                                  veterineryController.errorMessageVet.value,
                              isLoading: veterineryController.isLoading,
                              noDataTitle: locale.value.vetListIsEmpty,
                              noDataSubTitle:
                                  locale.value.thereAreNoVeterinarians,
                              onRetry: () {
                                veterineryController.getVet();
                              },
                              listWidget: Obx(
                                () => vetListWid(
                                  veterineryController.isShowVetFullList
                                      ? veterineryController.vetList
                                      : veterineryController.vetFilterList,
                                ).expand(),
                              ),
                            ),
                          ),
                        );
                      },
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.chooseVet,
                        fillColor: context.cardColor,
                        filled: true,
                        prefixIconConstraints:
                            BoxConstraints.loose(const Size.square(60)),
                        prefixIcon: veterineryController.selectedVet.value
                                    .profileImage.value.isEmpty &&
                                veterineryController
                                    .selectedVet.value.id.isNegative
                            ? null
                            : CachedImageWidget(
                                url: veterineryController
                                    .selectedVet.value.profileImage.value,
                                height: 35,
                                width: 35,
                                firstName: veterineryController
                                    .selectedVet.value.fullName,
                                fit: BoxFit.cover,
                                circle: true,
                                usePlaceholderIfUrlEmpty: true,
                              ).paddingOnly(
                                left: 12, top: 8, bottom: 8, right: 12),
                        suffixIcon: veterineryController.selectedVet.value
                                    .profileImage.value.isEmpty &&
                                veterineryController
                                    .selectedVet.value.id.isNegative
                            ? Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 24,
                                color: darkGray.withOpacity(0.5),
                              )
                            : appCloseIconButton(
                                context,
                                onPressed: () {
                                  veterineryController.clearVetSelection();
                                },
                                size: 11,
                              ),
                      ),
                    )
                        .paddingSymmetric(horizontal: 16)
                        .visible(!veterineryController.refreshWidget.value),
                  ),
                  32.height,
                  AppTextField(
                    title: locale.value.reason,
                    textStyle: primaryTextStyle(size: 12),
                    controller: veterineryController.reasonCont,
                    textFieldType: TextFieldType.OTHER,
                    decoration: inputDecoration(
                      context,
                      hintText: '${locale.value.eG}  ${locale.value.fever}',
                      fillColor: context.cardColor,
                      filled: true,
                      suffixIcon: Assets.profileIconsIcReason
                          .iconImage(fit: BoxFit.contain)
                          .paddingAll(14),
                    ),
                  ).paddingSymmetric(horizontal: 16),
                  32.height,
                  AddFilesWidget(
                    fileList: veterineryController.medicalReportfiles,
                    onFilePick: () async {
                      await veterineryController
                          .handleFilesPickerClick(context);
                    },
                    onFilePathRemove: (index) {
                      veterineryController.medicalReportfiles.remove(
                          veterineryController.medicalReportfiles[index]);
                    },
                  ),
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
                if (_veterineryformKey.currentState!.validate()) {
                  _veterineryformKey.currentState!.save();
                  if (veterineryController.bookVeterinaryReq.petId > 0) {
                    hideKeyboard(context);
                    veterineryController.handleBookNowClick();
                  } else {
                    toast(locale.value.pleaseSelectPet);
                  }
                }
              },
            )
                .paddingSymmetric(horizontal: 16)
                .visible(veterineryController.showBookBtn.value),
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
                  controller: veterineryController.dateCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));

                    if (selectedDate != null) {
                      veterineryController.bookVeterinaryReq.date =
                          selectedDate.formatDateYYYYmmdd();
                      veterineryController.dateCont.text =
                          selectedDate.formatDateDDMMYY();
                      debugPrint(
                          'REQ: ${veterineryController.bookVeterinaryReq.toJson()}');
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
                  controller: veterineryController.timeCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    if (veterineryController.dateCont.text.trim().isEmpty) {
                      toast(locale.value.pleaseSelectDateFirst);
                    } else {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        if ("${veterineryController.bookVeterinaryReq.date} ${pickedTime.formatTimeHHmm24Hour()}"
                            .isAfterCurrentDateTime) {
                          veterineryController.bookVeterinaryReq.time =
                              pickedTime.formatTimeHHmm24Hour();
                          veterineryController.timeCont.text =
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

  Widget veterinaryTypeListWid(List<ShopCategoryModel> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          leading: CachedImageWidget(
              url: list[index].categoryImage,
              height: 35,
              fit: BoxFit.cover,
              width: 35,
              circle: true),
          onTap: () {
            veterineryController.selectedVeterinaryType(list[index]);
            veterineryController.veterinaryTypeCont.text =
                veterineryController.selectedVeterinaryType.value.name;
            veterineryController.serviceCont.clear();
            veterineryController.vetCont.clear();
            veterineryController.vetList.clear();
            veterineryController.showBookBtn(false);
            veterineryController.selectedVet =
                EmployeeModel(profileImage: "".obs).obs;
            veterineryController.selectedService = ServiceModel().obs;
            veterineryController.getService();
            veterineryController.reloadWidget();
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) =>
          commonDivider.paddingSymmetric(vertical: 6),
    );
  }

  Widget serviceListWid(List<ServiceModel> list) {
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
            veterineryController.selectedService(list[index]);
            veterineryController.serviceCont.text =
                veterineryController.selectedService.value.name;
            currentSelectedService.value.serviceAmount = veterineryController
                .selectedService.value.defaultPrice
                .toDouble();
            veterineryController.bookVeterinaryReq.price = veterineryController
                .selectedService.value.defaultPrice
                .toDouble();
            debugPrint(
                'BOOKBOARDINGREQ.PRICE: ${veterineryController.bookVeterinaryReq.price}');
            debugPrint('percentTaxAmount: $percentTaxAmount');
            debugPrint('fixedTaxAmount: $fixedTaxAmount');
            log('TOTAL AMOUNT: $totalAmount');
            veterineryController.clearVetSelection();
            veterineryController.getVet();
            veterineryController.showBookBtn(false);
            veterineryController.showBookBtn(true);
            veterineryController.reloadWidget();
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) =>
          commonDivider.paddingSymmetric(vertical: 6),
    );
  }

  Widget vetListWid(List<EmployeeModel> list) {
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
            veterineryController.selectedVet(list[index]);
            veterineryController.vetCont.text =
                veterineryController.selectedVet.value.fullName;
            veterineryController.reloadWidget();
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) =>
          commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
