import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class EmployeeRes {
  bool status;
  List<EmployeeModel> data;
  String message;

  EmployeeRes({
    this.status = false,
    this.data = const <EmployeeModel>[],
    this.message = "",
  });

  factory EmployeeRes.fromJson(Map<String, dynamic> json) {
    return EmployeeRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<EmployeeModel>.from(json['data'].map((x) => EmployeeModel.fromJson(x))) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class EmployeeModel {
  int id;
  String fullName;
  String email;
  String mobile;
  String latitude;
  String longitude;
  num distance;
  RxString profileImage;

  String createdAt;

  EmployeeModel({
    this.id = -1,
    this.fullName = "",
    this.email = "",
    this.mobile = "",
    this.latitude = "",
    this.longitude = "",
    this.distance = 0,
    required this.profileImage,
    this.createdAt = "",
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] is int ? json['id'] : -1,
      fullName: json['full_name'] is String ? json['full_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      mobile: json['mobile'] is String ? json['mobile'] : "",
      latitude: json['latitude'] is String ? json['latitude'] : "",
      longitude: json['longitude'] is String ? json['longitude'] : "",
      distance: json['distance'] is String
          ? double.tryParse(json['distance'].toString().replaceAll(",", "")) ?? 0
          : json['distance'] is num
              ? json['distance']
              : 0,
      profileImage: json['profile_image'] is String ? (json['profile_image'] as String).obs : "".obs,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'mobile': mobile,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'profile_image': (profileImage).value,
      'created_at': createdAt,
    };
  }
}
