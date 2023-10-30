// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/constants.dart';
import '../services/auth_service_apis.dart';
import 'sign_in_controller.dart';
import '../../../utils/common_base.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool agree = false.obs;
  TextEditingController emailCont = TextEditingController();
  TextEditingController fisrtNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode fisrtNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  saveForm() async {
    isLoading(true);
    hideKeyBoardWithoutContext();

    Map<String, dynamic> req = {
      "email": emailCont.text.trim(),
      "first_name": fisrtNameCont.text.trim(),
      "last_name": lastNameCont.text.trim(),
      "password": passwordCont.text.trim(),
      UserKeys.userType: LoginTypeConst.LOGIN_TYPE_USER,
    };

    await AuthServiceApis.createUser(request: req).then((value) async {
      toast(value.message.toString(), print: true);
      try {
        final SignInController sCont = Get.find();
        sCont.emailCont.text = emailCont.text.trim();
        sCont.passwordCont.text = passwordCont.text.trim();
        isLoading(true);
        sCont.saveForm().whenComplete(() => isLoading(false));
      } catch (e) {
        debugPrint('E: $e');
        toast(e.toString(), print: true);
      }
      // Get.offUntil(GetPageRoute(page: () => SignInScreen()), (route) => route.isFirst || route.settings.name == '/$OptionScreen');
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }
}
