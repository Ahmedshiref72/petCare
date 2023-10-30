import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../models/base_response_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../model/pet_note_model.dart';
import '../model/pet_list_res_model.dart';
import '../model/pet_type_model.dart';

class PetService {
  static Future<PetTypeRes> getPetTypeApi() async {
    return PetTypeRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.getPetTypeList, method: HttpMethodType.GET)));
  }

  static Future<List<NotePetModel>> getNoteApi({
    int page = 1,
    required int petId,
    int perPage = Constants.perPageItem,
    required List<NotePetModel> notes,
    Function(bool)? lastPageCallBack,
  }) async {
    if (isLoggedIn.value) {
      final petNoteRes = PetNoteRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getNote}?pet_id=$petId&per_page=$perPage&page=$page", method: HttpMethodType.GET)));
      if (page == 1) notes.clear();
      notes.addAll(petNoteRes.data);
      lastPageCallBack?.call(petNoteRes.data.length != perPage);
      return notes;
    } else {
      return [];
    }
  }

  /* static Future<PetNoteRes> getNoteApi({required int petId}) async {
    return PetNoteRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getNote}?pet_id=$petId", method: HttpMethodType.GET)));
  }*/

  static Future<BaseResponseModel> addNoteApi({required Map<String, dynamic> request}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.addNote, request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> deleteNote({required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.deleteNote}/$id", method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> deletePet({required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.addPet}/$id", method: HttpMethodType.DELETE)));
  }

  static Future<List<PetData>> getPetListApi({
    page = 1,
    int perPage = 20,
    required List<PetData> pets,
  }) async {
    if (isLoggedIn.value) {
      final res = PetListRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getPetList}?per_page=$perPage&page=$page", method: HttpMethodType.GET)));
      pets.clear();
      pets.addAll(res.data);
      return res.data;
    } else {
      return [];
    }
  }

  static Future<void> addPetDetailsApi({int? petId, required Map<String, dynamic> request, bool isUpdateProfilePic = false, List<XFile>? files, required VoidCallback onPetAdd, required VoidCallback loaderOff}) async {
    log('FILES: $files');
    log('FILES length: ${files.validate().length}');
    String petIdparam = petId != null ? "/$petId" : "";
    var multiPartRequest = await getMultiPartRequest(APIEndPoints.addPet + petIdparam);
    if (!isUpdateProfilePic) {
      multiPartRequest.fields.addAll(await getMultipartFields(val: request));
    }

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.add(await MultipartFile.fromPath('pet_image', files.validate().first.path.validate()));
    }

    // log("Multipart ${jsonEncode(multiPartRequest.fields)}");
    log("Multipart Images ${multiPartRequest.files.map((e) => e.filename)}");

    multiPartRequest.headers.addAll(buildHeaderTokens());

    // BaseResponseModel baseResponseModel = BaseResponseModel();
    await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
      log("Response: ${jsonDecode(temp)}");
      // baseResponseModel = BaseResponseModel.fromJson(jsonDecode(temp));
      // toast(baseResponseModel.message, print: true);
      onPetAdd.call();
    }, onError: (error) {
      toast(error.toString(), print: true);
      loaderOff.call();
    });
  }
}
