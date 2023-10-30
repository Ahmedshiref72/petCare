import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../models/base_response_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/app_common.dart';
import '../../pet/model/breed_model.dart';
import 'package:http/http.dart';
import '../../shop/model/category_model.dart';
import '../model/employe_model.dart';
import '../model/facilities_model.dart';
import '../model/save_booking_res.dart';
import '../model/service_model.dart';
import '../model/training_model.dart';
import '../model/walking_model.dart';

class PetServiceFormApis {
  static Future<List<FacilityModel>> getFacility() async {
    final facilityRes = FacilityRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.getFacility, method: HttpMethodType.GET)));
    return facilityRes.data;
  }

  static Future<TrainingRes> getTraining() async {
    return TrainingRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.getTraining, method: HttpMethodType.GET)));
  }

  static Future<ServiceRes> getService({required String type, String? categoryId}) async {
    String categoryIdParam = categoryId != null ? '&category_id=$categoryId' : "";
    return ServiceRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getService}?type=$type$categoryIdParam", method: HttpMethodType.GET)));
  }

  static Future<EmployeeRes> getEmployee({required String role, String? serviceId, String latitude = "", String longitude = "", bool showNearby = false}) async {
    String serviceIdParam = serviceId != null ? '&service_ids=$serviceId' : "";
    String lat = '';
    String long = '';

    if (showNearby) {
      lat = latitude.trim().isNotEmpty ? '&latitude=$latitude' : "";
      long = longitude.trim().isNotEmpty ? '&longitude=$longitude' : "";
    }
    return EmployeeRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getEmployeeList}?type=$role$serviceIdParam$lat$long", method: HttpMethodType.GET)));
  }

  static Future<CategoryRes> getCategory({required String categoryType}) async {
    return CategoryRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getCategory}?type=$categoryType", method: HttpMethodType.GET)));
  }

  static Future<BreedRes> getBreed({
    required int petTypeId,
    int page = 1,
    int perPage = 50,
    Function(bool)? lastPageCallBack,
  }) async {
    return BreedRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getBreed}?pettype_id=$petTypeId&per_page=$perPage&page=$page", method: HttpMethodType.GET)));
  }

  static Future<List<DurationData>> getDuration({required String serviceType}) async {
    final res = WalkingDurationRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getDuration}?type=$serviceType", method: HttpMethodType.GET)));
    return res.data;
  }

  static Future<void> bookServiceApi({required Map<String, dynamic> request, List<PlatformFile>? files, required VoidCallback onSuccess, required VoidCallback loaderOff}) async {
    var multiPartRequest = await getMultiPartRequest(APIEndPoints.saveBooking);
    multiPartRequest.fields.addAll(await getMultipartFields(val: request));

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.add(await MultipartFile.fromPath('medical_report', files.validate().first.path.validate()));
    }

    /*  if (files.validate().isNotEmpty) {
      multiPartRequest.files.addAll(await getMultipartImages(files: files.validate(), name: 'medical_report'));
      // multiPartRequest.fields['attachment_count'] = files.validate().length.toString();
    } */

    log("Multipart ${jsonEncode(multiPartRequest.fields)}");
    log("Multipart Files ${multiPartRequest.files.map((e) => e.filename)}");
    log("Multipart Extension ${multiPartRequest.files.map((e) => e.filename!.split(".").last)}");
    multiPartRequest.headers.addAll(buildHeaderTokens());

    await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
      log("Response: ${jsonDecode(temp)}");
      // toast(baseResponseModel.message, print: true);
      try {
        saveBookingRes(SaveBookingRes.fromJson(jsonDecode(temp)));
      } catch (e) {
        log('SaveBookingRes.fromJson E: $e');
      }
      onSuccess.call();
    }, onError: (error) {
      toast(error.toString(), print: true);
      loaderOff.call();
    });
  }

  static Future<BaseResponseModel> savePayment({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.savePayment, request: request, method: HttpMethodType.POST)));
  }
}
