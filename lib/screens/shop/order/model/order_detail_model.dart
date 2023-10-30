import 'package:pawlly/utils/common_base.dart';

import '../../cart/model/cart_list_model.dart';

class OrderDetailModel {
  bool status;
  OrderListData data;
  String message;

  OrderDetailModel({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? OrderListData.fromJson(json['data']) : OrderListData(),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class OrderListData {
  int id;
  String orderCode;
  int userId;
  String deliveryStatus;
  String paymentStatus;
  num subTotalAmount;
  num totalTaxAmount;
  num logisticCharge;
  num totalAmount;
  String paymentMethod;
  String orderDate;
  String logisticName;
  String expectedDeliveryDate;
  String deliveryDays;
  String deliveryTime;
  String userName;
  String addressLine1;
  String addressLine2;
  String phoneNo;
  String alternativePhoneNo;
  String city;
  String state;
  String country;
  String postalCode;
  List<CartListData> productDetails;

  // local
  String get orderingDate => orderDate.dateInMMMMDyyyyFormat;
  String get deliveringDate => expectedDeliveryDate.dateInMMMMDyyyyFormat;

  OrderListData({
    this.id = -1,
    this.orderCode = "",
    this.userId = -1,
    this.deliveryStatus = "",
    this.paymentStatus = "",
    this.subTotalAmount = -1,
    this.totalTaxAmount = -1,
    this.logisticCharge = -1,
    this.totalAmount = -1,
    this.paymentMethod = "",
    this.orderDate = "",
    this.logisticName = "",
    this.expectedDeliveryDate = "",
    this.deliveryDays = "",
    this.deliveryTime = "",
    this.userName = "",
    this.addressLine1 = "",
    this.addressLine2 = "",
    this.phoneNo = "",
    this.alternativePhoneNo = "",
    this.city = "",
    this.state = "",
    this.country = "",
    this.postalCode = "",
    this.productDetails = const <CartListData>[],
  });

  factory OrderListData.fromJson(Map<String, dynamic> json) {
    return OrderListData(
      id: json['id'] is int ? json['id'] : -1,
      orderCode: json['order_code'] is String
          ? json['order_code']
          : json['order_code'] is int
              ? json['order_code'].toString()
              : "",
      userId: json['user_id'] is int ? json['user_id'] : -1,
      deliveryStatus: json['delivery_status'] is String ? json['delivery_status'] : "",
      paymentStatus: json['payment_status'] is String ? json['payment_status'] : "",
      subTotalAmount: json['sub_total_amount'] is num ? json['sub_total_amount'] : -1,
      totalTaxAmount: json['total_tax_amount'] is num ? json['total_tax_amount'] : -1,
      logisticCharge: json['logistic_charge'] is num ? json['logistic_charge'] : -1,
      totalAmount: json['total_amount'] is num ? json['total_amount'] : -1,
      paymentMethod: json['payment_method'] is String ? json['payment_method'] : "",
      orderDate: json['order_date'] is String ? json['order_date'] : "",
      logisticName: json['logistic_name'] is String ? json['logistic_name'] : "",
      expectedDeliveryDate: json['expected_delivery_date'] is String ? json['expected_delivery_date'] : "",
      deliveryDays: json['delivery_days'] is String ? json['delivery_days'] : "",
      deliveryTime: json['delivery_time'] is String ? json['delivery_time'] : "",
      userName: json['user_name'] is String ? json['user_name'] : "",
      addressLine1: json['address_line_1'] is String ? json['address_line_1'] : "",
      addressLine2: json['address_line_2'] is String ? json['address_line_2'] : "",
      phoneNo: json['phone_no'] is String ? json['phone_no'] : "",
      alternativePhoneNo: json['alternative_phone_no'] is String ? json['alternative_phone_no'] : "",
      city: json['city'] is String ? json['city'] : "",
      state: json['state'] is String ? json['state'] : "",
      country: json['country'] is String ? json['country'] : "",
      postalCode: json['postal_code'] is String ? json['postal_code'] : "",
      productDetails: json['product_details'] is List ? List<CartListData>.from(json['product_details'].map((x) => CartListData.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_code': orderCode,
      'user_id': userId,
      'delivery_status': deliveryStatus,
      'payment_status': paymentStatus,
      'sub_total_amount': subTotalAmount,
      'total_tax_amount': totalTaxAmount,
      'logistic_charge': logisticCharge,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'order_date': orderDate,
      'logistic_name': logisticName,
      'expected_delivery_date': expectedDeliveryDate,
      'delivery_days': deliveryDays,
      'delivery_time': deliveryTime,
      'user_name': userName,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'phone_no': phoneNo,
      'alternative_phone_no': alternativePhoneNo,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'product_details': productDetails.map((e) => e.toJson()).toList(),
    };
  }
}
