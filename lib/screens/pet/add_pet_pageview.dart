import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_scaffold.dart';
import 'add_pet_info_controller.dart';
import '../../main.dart';
import '../../utils/empty_error_state_widget.dart';
import 'add_pet_step_1.dart';
import 'add_pet_step_2.dart';
import 'add_pet_step_3.dart';
import 'components/steps_no_component.dart';

class AddPetInfoScreen extends StatelessWidget {
  AddPetInfoScreen({Key? key}) : super(key: key);

  final AddPetInfoController addPetInfoController = Get.put(AddPetInfoController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        bool canPop = false;
        if (addPetInfoController.currentPage.value == 0) {
          canPop = true;
        } else if (addPetInfoController.isUpdateProfile.value) {
          canPop = true;
        } else {
          addPetInfoController.handlePrevious();
        }
        return Future(() => canPop);
      },
      child: AppScaffold(
        isCenterTitle: true,
        // resizeToAvoidBottomPadding: false,
        isLoading: addPetInfoController.isLoading,
        appBarTitle: Obx(
          () => Text(
            addPetInfoController.isUpdateProfile.value ? locale.value.editPetInfo : addPetInfoController.pageViewElementList[addPetInfoController.currentPage.value].appBarTitle,
            style: primaryTextStyle(size: 18),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            16.height,
            Obx(
              () => StepsRow(
                isStep2Active: addPetInfoController.pageViewElementList[addPetInfoController.currentPage.value].isStep2Active,
                isStep3Active: addPetInfoController.pageViewElementList[addPetInfoController.currentPage.value].isStep3Active,
                midImg1: addPetInfoController.pageViewElementList[addPetInfoController.currentPage.value].midImg1,
                midImg2: addPetInfoController.pageViewElementList[addPetInfoController.currentPage.value].midImg2,
              ).paddingSymmetric(horizontal: 16),
            ),
            32.height,
            /* Obx(() => addPetInfoController.currentPage.value == 0 ? const StepsRow(midImg1: Assets.dogPawDogPaw, midImg2: Assets.dogPawDogPaw1).paddingSymmetric(horizontal: 16) : const SizedBox()),
                Obx(() => addPetInfoController.currentPage.value == 1 ? const StepsRow(isStep2Active: true, midImg1: Assets.dogPawDogPaw2, midImg2: Assets.dogPawDogPaw).paddingSymmetric(horizontal: 16) : const SizedBox()),
                Obx(() => addPetInfoController.currentPage.value == 2 ? const StepsRow(isStep2Active: true, isStep3Active: true, midImg1: Assets.dogPawDogPaw2, midImg2: Assets.dogPawDogPaw2).paddingSymmetric(horizontal: 16) : const SizedBox()), */
            PageView.builder(
              itemCount: addPetInfoController.pageViewElementList.length,
              controller: addPetInfoController.pageController,
              onPageChanged: (int index) {
                addPetInfoController.currentPage(index);
              },
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (index == 0) ...[
                        Obx(
                          () => addPetInfoController.hasErrorFetchingbookingList.value
                              ? NoDataWidget(
                                  title: addPetInfoController.errorMessage.value,
                                  retryText: locale.value.reload,
                                  titleTextStyle: primaryTextStyle(),
                                  imageWidget: const ErrorStateWidget(),
                                  onRetry: () {
                                    addPetInfoController.getPetTypesApi();
                                  },
                                ).paddingTop(Get.height * 0.15).paddingSymmetric(horizontal: 16)
                              : addPetInfoController.petTypeList.isEmpty && !addPetInfoController.isLoading.value
                                  ? NoDataWidget(
                                      title: locale.value.itAppearsTheAdmin,
                                      imageWidget: const EmptyStateWidget(),
                                      subTitle: locale.value.youCanUtilizeThe,
                                      retryText: locale.value.sendRequestToAdmin,
                                      onRetry: () {
                                        Get.back();
                                      },
                                    ).paddingSymmetric(horizontal: 16)
                                  : AddPetStep1Screen(),
                        )
                      ],
                      if (index == 1) ...[AddPetStep2Screen()],
                      if (index == 2) ...[AddPetStep3Screen()],
                    ],
                  ),
                );
              },
            ).expand(),
          ],
        ),
      ),
    );
  }
}
