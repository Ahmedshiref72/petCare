import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../models/base_response_model.dart';
import '../../../models/register_user_res_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';
import '../model/app_configuration_res.dart';
import '../model/change_password_res.dart';
import '../model/employee_model.dart';
import '../model/login_response.dart';
import '../model/notification_model.dart';

class AuthServiceApis {
  static Future<RegUserResp> createUser({required Map request}) async {
    return RegUserResp.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.register, request: request, method: HttpMethodType.POST)));
  }

  static Future<LoginResponse> loginUser({required Map request, bool isSocialLogin = false}) async {
    return LoginResponse.fromJson(await handleResponse(await buildHttpResponse(isSocialLogin ? APIEndPoints.socialLogin : APIEndPoints.login, request: request, method: HttpMethodType.POST)));
  }

  static Future<ChangePassRes> changePasswordAPI({required Map request}) async {
    return ChangePassRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.changePassword, request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> forgotPasswordAPI({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.forgotPassword, request: request, method: HttpMethodType.POST)));
  }

  static Future<List<NotificationData>> getNotificationDetail({
    int page = 1,
    int perPage = 10,
    required List<NotificationData> notifications,
    Function(bool)? lastPageCallBack,
  }) async {
    if (isLoggedIn.value) {
      final notificationRes = NotificationRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getNotification}?per_page=$perPage&page=$page", method: HttpMethodType.GET)));
      if (page == 1) notifications.clear();
      notifications.addAll(notificationRes.notificationData);
      lastPageCallBack?.call(notificationRes.notificationData.length != perPage);
      return notifications;
    } else {
      return [];
    }
  }

  static Future<NotificationData> clearAllNotification() async {
    return NotificationData.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.clearAllNotification, method: HttpMethodType.GET)));
  }

  static Future<NotificationData> removeNotification({required String notificationId}) async {
    return NotificationData.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.removeNotification}?id=$notificationId', method: HttpMethodType.GET)));
  }

  static Future<void> clearData({bool isFromDeleteAcc = false}) async {
    GoogleSignIn().signOut();
    if (isFromDeleteAcc) {
      localStorage.erase();
      isLoggedIn(false);
      loginUserData(UserData());
    } else {
      final tempEmail = loginUserData.value.email;
      final tempPASSWORD = getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
      final tempIsRemeberMe = getValueFromLocal(SharedPreferenceConst.IS_REMEMBER_ME);
      final tempUserName = loginUserData.value.userName;

      localStorage.erase();
      isLoggedIn(false);
      loginUserData(UserData());
      OneSignal.Notifications.clearAll();
      OneSignal.logout();

      setValueToLocal(SharedPreferenceConst.FIRST_TIME, true);
      setValueToLocal(SharedPreferenceConst.USER_EMAIL, tempEmail);
      setValueToLocal(SharedPreferenceConst.USER_NAME, tempUserName);

      if (tempPASSWORD is String) {
        setValueToLocal(SharedPreferenceConst.USER_PASSWORD, tempPASSWORD);
      }
      if (tempIsRemeberMe is bool) {
        setValueToLocal(SharedPreferenceConst.IS_REMEMBER_ME, tempIsRemeberMe);
      }
    }
  }

  static Future<BaseResponseModel> logoutApi() async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.logout, method: HttpMethodType.GET)));
  }

  static Future<BaseResponseModel> deleteAccountCompletely() async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.deleteUserAccount, request: {}, method: HttpMethodType.POST)));
  }

  static Future<ConfigurationResponse> getAppConfigurations() async {
    return ConfigurationResponse.fromJson(
        await handleResponse(await buildHttpResponse('${APIEndPoints.appConfiguration}?is_authenticated=${(getValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN) == true).getIntBool()}', request: {}, method: HttpMethodType.GET)));
  }

  static Future<GetUserProfileResponse> viewProfile({int? id}) async {
    var res = GetUserProfileResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.userDetail}?id=${id ?? loginUserData.value.id}', method: HttpMethodType.GET)));
    return res;
  }

  static Future<dynamic> updateProfile({
    File? imageFile,
    String firstName = '',
    String lastName = '',
    String mobile = '',
    String address = '',
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoints.updateProfile);
      if (firstName.isNotEmpty) multiPartRequest.fields[UserKeys.firstName] = firstName;
      if (lastName.isNotEmpty) multiPartRequest.fields[UserKeys.lastName] = lastName;
      if (mobile.isNotEmpty) multiPartRequest.fields[UserKeys.mobile] = mobile;
      if (address.isNotEmpty) multiPartRequest.fields[UserKeys.address] = address;
      // if (appStore.playerId.isNotEmpty) multiPartRequest.fields[UserKeys.playerId] = appStore.playerId;

      if (imageFile != null) {
        multiPartRequest.files.add(await MultipartFile.fromPath(UserKeys.profileImage, imageFile.path));
      }

      multiPartRequest.headers.addAll(buildHeaderTokens());

      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          onSuccess?.call(data);
        },
        onError: (error) {
          throw error;
        },
      ).catchError((error) {
        throw error;
      });
    }
  }
}
