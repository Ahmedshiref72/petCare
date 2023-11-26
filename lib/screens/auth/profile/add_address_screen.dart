import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/auth/profile/add_address_controller.dart';
import 'package:pawlly/utils/app_common.dart';

import '../../../components/app_scaffold.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../model/address_models/country_list_response.dart';
import '../model/address_models/logistic_zone_response.dart';
import '../model/address_models/state_list_response.dart';
import 'map_screen.dart';

class AddAddressScreen extends StatefulWidget {
  AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  final AddAddressController addAddressController =
      Get.put(AddAddressController());

  String latitude = "Latitude";

  String longitude = "Longitude";
  bool isLoading = false; // Loading indicator flag

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    while (true) {
      // Check if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled; request the user to enable them.
        bool opened = await Geolocator.openLocationSettings();
        if (!opened) {
          // If the user refuses to open location settings, exit the loop or handle accordingly.
          return Future.error('Location services are disabled.');
        }
        continue; // Re-check if location services are enabled after returning from settings.
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied; request permissions.
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied; they need to be approved.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever; handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // If permissions are granted and location services are enabled, get the current position.
      if (serviceEnabled && permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return await Geolocator.getCurrentPosition();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.myAddresses,
      isLoading: addAddressController.isLoading,
      body: Stack(
        children: [
          AnimatedScrollView(
            controller: scrollController,
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 10),
            children: [
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading
                        ? // Loading indicator
                        const Center(
                            child: CircularProgressIndicator(
                            color: primaryColor,
                          ))
                        : GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true; // Start loading
                              });
                              try {
                                final position = await _determinePosition();
                                final newLocation = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                        initialPosition: LatLng(
                                            position.latitude,
                                            position.longitude)),
                                  ),
                                );

                                if (newLocation != null) {
                                  setState(() {
                                    latitude =
                                        "Latitude: ${newLocation.latitude}";
                                    longitude =
                                        "Longitude: ${newLocation.longitude}";
                                  });
                                  // Update the controller with the new latitude and longitude
                                  addAddressController
                                      .updateLatitude(newLocation.latitude);
                                  addAddressController
                                      .updateLongitude(newLocation.longitude);
                                }
                              } catch (e) {
                                // Handle exceptions
                                print(e);
                              } finally {
                                setState(() {
                                  isLoading = false; // Stop loading
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image(
                                    image: NetworkImage(
                                      'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/191:100/w_1280,c_limit/GoogleMapTA.jpg',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    AppTextField(
                      title: locale.value.firstName,
                      textStyle: primaryTextStyle(size: 12),
                      controller: addAddressController.firstNameCont,
                      focus: addAddressController.firstNameFocus,
                      nextFocus: addAddressController.lastNameFocus,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(
                        context,
                        hintText: '${locale.value.eG}  ${locale.value.merry}',
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                      suffix: Assets.profileIconsIcUserOutlined
                          .iconImage(fit: BoxFit.contain)
                          .paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      title: locale.value.lastName,
                      textStyle: primaryTextStyle(size: 12),
                      controller: addAddressController.lastNameCont,
                      focus: addAddressController.lastNameFocus,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(
                        context,
                        hintText: '${locale.value.eG}  ${locale.value.merry}',
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                      suffix: Assets.profileIconsIcUserOutlined
                          .iconImage(fit: BoxFit.contain)
                          .paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      title: locale.value.phone,
                      textStyle: primaryTextStyle(size: 12),
                      controller: addAddressController.phoneCont,
                      focus: addAddressController.phoneFocus,
                      textFieldType: TextFieldType.NUMBER,
                      decoration: inputDecoration(
                        context,
                        hintText: '+965',
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                      suffix: Icon(
                        Icons.phone,
                        size: 20.0,
                      ),
                    ),
                    16.height,
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(locale.value.country,
                                style: primaryTextStyle()),
                            4.height,
                            Obx(
                              () => DropdownButtonFormField<CountryData>(
                                decoration: inputDecoration(
                                  context,
                                  hintText: locale.value.selectCountry,
                                  fillColor: context.cardColor,
                                  filled: true,
                                ),
                                isExpanded: true,
                                value: addAddressController
                                            .selectedCountry.value.id >
                                        0
                                    ? addAddressController.selectedCountry.value
                                    : null,
                                dropdownColor: context.cardColor,
                                items: addAddressController.countryList
                                    .map((CountryData e) {
                                  return DropdownMenuItem<CountryData>(
                                    value: e,
                                    child: Text(e.name,
                                        style: primaryTextStyle(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  );
                                }).toList(),
                                onChanged: (CountryData? value) async {
                                  hideKeyboard(context);
                                  addAddressController.countryId(value!.id);
                                  addAddressController.selectedCountry(value);
                                  addAddressController
                                      .selectedState(StateData());
                                  addAddressController
                                      .selectedCity(CityData(pivot: Pivot()));
                                  addAddressController.getStates(value.id);
                                },
                              ),
                            ),
                          ],
                        ).expand(),
                        Obx(() => 12.width.visible(
                            addAddressController.stateList.isNotEmpty)),
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(locale.value.state,
                                  style: primaryTextStyle()),
                              4.height,
                              Obx(
                                () => DropdownButtonFormField<StateData>(
                                  decoration: inputDecoration(
                                    context,
                                    hintText: locale.value.selectState,
                                    fillColor: context.cardColor,
                                    filled: true,
                                  ),
                                  isExpanded: true,
                                  dropdownColor: context.cardColor,
                                  value: addAddressController
                                              .selectedState.value.id >
                                          0
                                      ? addAddressController.selectedState.value
                                      : null,
                                  items: addAddressController.stateList
                                      .map((StateData e) {
                                    return DropdownMenuItem<StateData>(
                                      value: e,
                                      child: Text(e.name,
                                          style: primaryTextStyle(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (StateData? value) async {
                                    hideKeyboard(context);
                                    addAddressController
                                        .selectedCity(CityData(pivot: Pivot()));
                                    addAddressController.selectedState(value);
                                    addAddressController.stateId(value!.id);
                                    await addAddressController
                                        .getCity(value.id);
                                  },
                                ),
                              ),
                            ],
                          ).expand().visible(
                              addAddressController.stateList.isNotEmpty),
                        ),
                      ],
                    ),
                    16.height,
                    Row(
                      children: [
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(locale.value.city,
                                  style: primaryTextStyle()),
                              4.height,
                              DropdownButtonFormField<CityData>(
                                decoration: inputDecoration(
                                  context,
                                  hintText: locale.value.selectCity,
                                  fillColor: context.cardColor,
                                  filled: true,
                                ),
                                isExpanded: true,
                                value: addAddressController
                                            .selectedCity.value.id >
                                        0
                                    ? addAddressController.selectedCity.value
                                    : null,
                                style: primaryTextStyle(size: 12),
                                dropdownColor: context.cardColor,
                                items: addAddressController.cityList
                                    .map((CityData e) {
                                  return DropdownMenuItem<CityData>(
                                    value: e,
                                    child: Text(e.name,
                                        style: primaryTextStyle(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  );
                                }).toList(),
                                onChanged: (CityData? value) async {
                                  hideKeyboard(context);
                                  addAddressController.selectedCity(value);
                                  addAddressController.cityId(value!.id);
                                },
                              ),
                            ],
                          ).expand().visible(
                              addAddressController.cityList.isNotEmpty),
                        ),
                        Obx(() => 12
                            .width
                            .visible(addAddressController.cityList.isNotEmpty)),
                        /*AppTextField(
                          title: locale.value.pinCode,
                          textStyle: primaryTextStyle(size: 12),
                          textFieldType: TextFieldType.NUMBER,
                          controller: addAddressController.pinCodeCont,
                          focus: addAddressController.pinCodeFocus,
                          nextFocus: addAddressController.addressLine1FocusNode,
                          isValidationRequired: false,
                          decoration: inputDecoration(
                            context,
                            hintText: '${locale.value.eG} 123456',
                            fillColor: context.cardColor,
                            filled: true,
                          ),
                          onTap: () {
                            scrollController.animToBottom();
                          },
                          onChanged: (p0) {
                            scrollController.animToBottom();
                          },
                        ).expand(),*/
                      ],
                    ),
                    16.height,
                    AppTextField(
                      title: "${locale.value.addressLine} ",
                      textStyle: primaryTextStyle(size: 12),
                      textFieldType: TextFieldType.MULTILINE,
                      minLines: 3,
                      controller: addAddressController.addressLine1Controller,
                      nextFocus: addAddressController.addressLine2FocusNode,
                      focus: addAddressController.addressLine1FocusNode,
                      decoration: inputDecoration(
                        context,
                        hintText:
                            "${locale.value.eG} 123, ${locale.value.mainStreet}",
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                    ),
                    16.height,
                    AppTextField(
                      title: "${locale.value.addressLine1} ",
                      textStyle: primaryTextStyle(size: 12),
                      textFieldType: TextFieldType.MULTILINE,
                      minLines: 3,
                      isValidationRequired: false,
                      controller: addAddressController.addressLine2Controller,
                      focus: addAddressController.addressLine2FocusNode,
                      nextFocus: addAddressController.houseNumFocusNode,
                      decoration: inputDecoration(
                        context,
                        hintText:
                            "${locale.value.eG} ${locale.value.apt} 4B", //No Localization here
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                    ),
                    16.height,
                    AppTextField(
                      title: "${locale.value.houseNum} ",
                      textStyle: primaryTextStyle(size: 12),
                      textFieldType: TextFieldType.NAME,
                      minLines: 1,
                      isValidationRequired: true,
                      controller: addAddressController.houseNumController,
                      focus: addAddressController.houseNumFocusNode,
                      nextFocus: addAddressController.floorNumFocusNode,
                      decoration: inputDecoration(
                        context,
                        hintText:
                            " ${locale.value.houseNum}  1", //No Localization here
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                    ),
                    16.height,
                    AppTextField(
                      title: "${locale.value.floorNum} ",
                      textStyle: primaryTextStyle(size: 12),
                      textFieldType: TextFieldType.NAME,
                      minLines: 1,
                      isValidationRequired: true,
                      controller: addAddressController.floorNumController,
                      focus: addAddressController.floorNumFocusNode,
                      nextFocus: addAddressController.departmentFocusNode,
                      decoration: inputDecoration(
                        context,
                        hintText:
                            " ${locale.value.floorNum}  2", //No Localization here
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                    ),
                    16.height,
                    AppTextField(
                      title: "${locale.value.department} ",
                      textStyle: primaryTextStyle(size: 12),
                      textFieldType: TextFieldType.NAME,
                      minLines: 1,
                      isValidationRequired: true,
                      controller: addAddressController.departmentController,
                      focus: addAddressController.departmentFocusNode,
                      decoration: inputDecoration(
                        context,
                        hintText:
                            " ${locale.value.department}  7", //No Localization here
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                    ),
                    16.height,
                    setAsPrimaryWidget(),
                    16.height,
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: AppButton(
              width: Get.width,
              color: primaryColor,
              onTap: () async {
                if (!addAddressController.isLoading.value) {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();

                    /// Add Or Edit Address Api Call
                    addAddressController.addEditAddress();
                  }
                }
              },
              child: Text(
                  addAddressController.isEdit.value
                      ? locale.value.saveChanges
                      : locale.value.save,
                  style: primaryTextStyle(color: white)),
            ),
          ),
        ],
      ),
    );
  }

  /// region Service List Widget
  Widget setAsPrimaryWidget() {
    return Obx(
      () => ListTileTheme(
        horizontalTitleGap: 0.0,
        child: CheckboxListTile(
          value: addAddressController.isPrimary.value,
          checkColor: white,
          title: Text(locale.value.setAsPrimary,
              style: primaryTextStyle(
                  color:
                      isDarkMode.value ? textPrimaryColorGlobal : primaryColor,
                  size: 14)),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          checkboxShape: RoundedRectangleBorder(borderRadius: radius(5)),
          side: const BorderSide(color: primaryColor),
          dense: true,
          activeColor: isDarkMode.value ? primaryColor : primaryColor,
          onChanged: (value) {
            addAddressController
                .isPrimary(!addAddressController.isPrimary.value);
          },
        ),
      ),
    );
  }
}
