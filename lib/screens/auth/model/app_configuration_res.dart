import 'package:nb_utils/nb_utils.dart';

import '../../../configs.dart';
import '../../../utils/constants.dart';

class ConfigurationResponse {
  OnesignalCustomerApp onesignalCustomerApp;
  CustomerAppUrl customerAppUrl;
  ZoomConfig zoom;
  Currency currency;
  RazorPay razorPay;
  StripePay stripePay;
  PaystackPay paystackPay;
  PaypalPay paypalPay;
  FlutterwavePay flutterwavePay;
  String googleLoginStatus;
  String appleLoginStatus;
  String otpLoginStatus;
  String siteDescription;
  String applicationLanguage;
  bool isForceUpdate;
  int minimumForceUpdateCode;
  int latestVersionUpdateCode;
  bool status;

  ConfigurationResponse({
    required this.onesignalCustomerApp,
    required this.customerAppUrl,
    required this.zoom,
    required this.currency,
    required this.razorPay,
    required this.stripePay,
    required this.paystackPay,
    required this.paypalPay,
    required this.flutterwavePay,
    this.googleLoginStatus = "",
    this.appleLoginStatus = "",
    this.otpLoginStatus = "",
    this.siteDescription = "",
    this.applicationLanguage = DEFAULT_LANGUAGE,
    this.isForceUpdate = false,
    this.minimumForceUpdateCode = 0,
    this.latestVersionUpdateCode = 0,
    this.status = false,
  });

  factory ConfigurationResponse.fromJson(Map<String, dynamic> json) {
    return ConfigurationResponse(
      onesignalCustomerApp: json['onesignal_customer_app'] is Map
          ? OnesignalCustomerApp.fromJson(json['onesignal_customer_app'])
          : OnesignalCustomerApp(),
      customerAppUrl: json['customer_app_url'] is Map
          ? CustomerAppUrl.fromJson(json['customer_app_url'])
          : CustomerAppUrl(),
      razorPay: json['razor_pay'] is Map
          ? RazorPay.fromJson(json['razor_pay'])
          : RazorPay(),
      stripePay: json['stripe_pay'] is Map
          ? StripePay.fromJson(json['stripe_pay'])
          : StripePay(),
      paystackPay: json['paystack_pay'] is Map
          ? PaystackPay.fromJson(json['paystack_pay'])
          : PaystackPay(),
      paypalPay: json['paypal_pay'] is Map
          ? PaypalPay.fromJson(json['paypal_pay'])
          : PaypalPay(),
      flutterwavePay: json['flutterwave_pay'] is Map
          ? FlutterwavePay.fromJson(json['flutterwave_pay'])
          : FlutterwavePay(),
      zoom: json['zoom'] is Map
          ? ZoomConfig.fromJson(json['zoom'])
          : ZoomConfig(),
      currency: json['currency'] is Map
          ? Currency.fromJson(json['currency'])
          : Currency(),
      googleLoginStatus: json['google_login_status'] is String
          ? json['google_login_status']
          : "",
      appleLoginStatus: json['apple_login_status'] is String
          ? json['apple_login_status']
          : "",
      otpLoginStatus:
          json['otp_login_status'] is String ? json['otp_login_status'] : "",
      siteDescription:
          json['site_description'] is String ? json['site_description'] : "",
      applicationLanguage: json['application_language'] is String
          ? json['application_language']
          : DEFAULT_LANGUAGE,
      isForceUpdate: json['isForceUpdate'] is int
          ? (json['isForceUpdate'] as int).getBoolInt()
          : false,
      minimumForceUpdateCode: json['minimum_force_update_code'] is int
          ? json['minimum_force_update_code']
          : 0,
      latestVersionUpdateCode: json['latest_version_update_code'] is int
          ? json['latest_version_update_code']
          : 0,
      status: json['status'] is bool ? json['status'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'onesignal_customer_app': onesignalCustomerApp.toJson(),
      'customer_app_url': customerAppUrl.toJson(),
      'razor_pay': razorPay.toJson(),
      'stripe_pay': stripePay.toJson(),
      'paystack_pay': paystackPay.toJson(),
      'paypal_pay': paypalPay.toJson(),
      'flutterwave_pay': flutterwavePay.toJson(),
      'zoom': zoom.toJson(),
      'currency': currency.toJson(),
      'google_login_status': googleLoginStatus,
      'apple_login_status': appleLoginStatus,
      'otp_login_status': otpLoginStatus,
      'site_description': siteDescription,
      'application_language': applicationLanguage,
      'isForceUpdate': isForceUpdate,
      'minimum_force_update_code': minimumForceUpdateCode,
      'latest_version_update_code': latestVersionUpdateCode,
      'status': status,
    };
  }
}

class Currency {
  String currencyName;
  String currencySymbol;
  String currencyCode;
  String currencyPosition;
  int noOfDecimal;
  String thousandSeparator;
  String decimalSeparator;

  Currency({
    this.currencyName = "Doller",
    this.currencySymbol = "\$",
    this.currencyCode = "USD",
    this.currencyPosition = CurrencyPosition.CURRENCY_POSITION_LEFT,
    this.noOfDecimal = 2,
    this.thousandSeparator = ",",
    this.decimalSeparator = ".",
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      currencyName:
          json['currency_name'] is String ? json['currency_name'] : "Doller",
      currencySymbol:
          json['currency_symbol'] is String ? json['currency_symbol'] : "\$",
      currencyCode:
          json['currency_code'] is String ? json['currency_code'] : "USD",
      currencyPosition: json['currency_position'] is String
          ? json['currency_position']
          : "left",
      noOfDecimal: json['no_of_decimal'] is int ? json['no_of_decimal'] : 2,
      thousandSeparator: json['thousand_separator'] is String
          ? json['thousand_separator']
          : ",",
      decimalSeparator:
          json['decimal_separator'] is String ? json['decimal_separator'] : ".",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_name': currencyName,
      'currency_symbol': currencySymbol,
      'currency_code': currencyCode,
      'currency_position': currencyPosition,
      'no_of_decimal': noOfDecimal,
      'thousand_separator': thousandSeparator,
      'decimal_separator': decimalSeparator,
    };
  }
}

class CustomerAppUrl {
  String customerAppPlayStore;
  String customerAppAppStore;

  CustomerAppUrl({
    this.customerAppPlayStore = APP_PLAY_STORE_URL,
    this.customerAppAppStore = APP_APPSTORE_URL,
  });

  factory CustomerAppUrl.fromJson(Map<String, dynamic> json) {
    return CustomerAppUrl(
      customerAppPlayStore: json['customer_app_play_store'] is String
          ? json['customer_app_play_store']
          : APP_PLAY_STORE_URL,
      customerAppAppStore: json['customer_app_app_store'] is String
          ? json['customer_app_app_store']
          : APP_APPSTORE_URL,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_app_play_store': customerAppPlayStore,
      'customer_app_app_store': customerAppAppStore,
    };
  }
}

class OnesignalCustomerApp {
  String onesignalAppId;
  String onesignalRestApiKey;
  String onesignalChannelId;

  OnesignalCustomerApp({
    this.onesignalAppId = "",
    this.onesignalRestApiKey = "",
    this.onesignalChannelId = "",
  });

  factory OnesignalCustomerApp.fromJson(Map<String, dynamic> json) {
    return OnesignalCustomerApp(
      onesignalAppId:
          json['onesignal_app_id'] is String ? json['onesignal_app_id'] : "",
      onesignalRestApiKey: json['onesignal_rest_api_key'] is String
          ? json['onesignal_rest_api_key']
          : "",
      onesignalChannelId: json['onesignal_channel_id'] is String
          ? json['onesignal_channel_id']
          : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'onesignal_app_id': onesignalAppId,
      'onesignal_rest_api_key': onesignalRestApiKey,
      'onesignal_channel_id': onesignalChannelId,
    };
  }
}

class RazorPay {
  String razorpaySecretkey;

  RazorPay({
    this.razorpaySecretkey = "",
  });

  factory RazorPay.fromJson(Map<String, dynamic> json) {
    return RazorPay(
      razorpaySecretkey: json['razorpay_secretkey'] is String
          ? json['razorpay_secretkey']
          : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'razorpay_secretkey': razorpaySecretkey,
    };
  }
}

class StripePay {
  String stripeSecretkey;
  String stripePublickey;

  StripePay({
    this.stripeSecretkey = "",
    this.stripePublickey = "",
  });

  factory StripePay.fromJson(Map<String, dynamic> json) {
    return StripePay(
      stripeSecretkey:
          json['stripe_secretkey'] is String ? json['stripe_secretkey'] : "",
      stripePublickey:
          json['stripe_publickey'] is String ? json['stripe_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stripe_secretkey': stripeSecretkey,
      'stripe_publickey': stripePublickey,
    };
  }
}

class PaystackPay {
  String paystackSecretkey;
  String paystackPublickey;

  PaystackPay({
    this.paystackSecretkey = "",
    this.paystackPublickey = "",
  });

  factory PaystackPay.fromJson(Map<String, dynamic> json) {
    return PaystackPay(
      paystackSecretkey: json['paystack_secretkey'] is String
          ? json['paystack_secretkey']
          : "",
      paystackPublickey: json['paystack_publickey'] is String
          ? json['paystack_publickey']
          : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paystack_secretkey': paystackSecretkey,
      'paystack_publickey': paystackPublickey,
    };
  }
}

class PaypalPay {
  String paypalSecretkey;
  String paypalClientid;

  PaypalPay({
    this.paypalSecretkey = "",
    this.paypalClientid = "",
  });

  factory PaypalPay.fromJson(Map<String, dynamic> json) {
    return PaypalPay(
      paypalSecretkey:
          json['paypal_secretkey'] is String ? json['paypal_secretkey'] : "",
      paypalClientid:
          json['paypal_clientid'] is String ? json['paypal_clientid'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paypal_secretkey': paypalSecretkey,
      'paypal_clientid': paypalClientid,
    };
  }
}

class FlutterwavePay {
  String flutterwaveSecretkey;
  String flutterwavePublickey;

  FlutterwavePay({
    this.flutterwaveSecretkey = "",
    this.flutterwavePublickey = "",
  });

  factory FlutterwavePay.fromJson(Map<String, dynamic> json) {
    return FlutterwavePay(
      flutterwaveSecretkey: json['flutterwave_secretkey'] is String
          ? json['flutterwave_secretkey']
          : "",
      flutterwavePublickey: json['flutterwave_publickey'] is String
          ? json['flutterwave_publickey']
          : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flutterwave_secretkey': flutterwaveSecretkey,
      'flutterwave_publickey': flutterwavePublickey,
    };
  }
}

class ZoomConfig {
  String accountId;
  String clientId;
  String clientSecret;

  ZoomConfig({
    this.accountId = "",
    this.clientId = "",
    this.clientSecret = "",
  });

  factory ZoomConfig.fromJson(Map<String, dynamic> json) {
    return ZoomConfig(
      accountId: json['account_id'] is String ? json['account_id'] : "",
      clientId: json['client_id'] is String ? json['client_id'] : "",
      clientSecret:
          json['client_secret'] is String ? json['client_secret'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'client_id': clientId,
      'client_secret': clientSecret,
    };
  }
}
