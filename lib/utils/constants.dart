// ignore_for_file: constant_identifier_names

import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';

import '../screens/dashboard/dashboard_res_model.dart';

const DEFAULT_QUANTITY = '1';
const PERMISSION_STATUS = 'permissionStatus';
const LATITUDE = 'LATITUDE';
const LONGITUDE = 'LONGITUDE';
const CURRENT_ADDRESS = 'CURRENT_ADDRESS';

class Constants {
  static const perPageItem = 20;
  static var labelTextSize = 17;
  static var googleMapPrefix = 'https://www.google.com/maps/search/?api=1&query=';
  static const DEFAULT_EMAIL = 'john@gmail.com';
  static const DEFAULT_PASS = '12345678';
  static const appLogoSize = 98.0;
  static const DECIMAL_POINT = 2;
}

//region DateFormats
class DateFormatConst {
  static const DD_MM_YY = "dd-MM-yy"; //TODO Use to show only in UI
  static const MMMM_D_yyyy = "MMMM d, y"; //TODO Use to show only in UI
  static const D_MMMM_yyyy = "d MMMM, y"; //TODO Use to show only in UI
  static const MMMM_D_yyyy_At_HH_mm_a = "MMMM d, y @ hh:mm a"; //TODO Use to show only in UI
  static const EEEE_D_MMMM_At_HH_mm_a = "EEEE d MMMM @ hh:mm a"; //TODO Use to show only in UI
  static const dd_MMM_yyyy_HH_mm_a = "dd MMM y, hh:mm a"; //TODO Use to show only in UI
  static const yyyy_MM_dd_HH_mm = 'yyyy-MM-dd HH:mm';
  static const yyyy_MM_dd = 'yyyy-MM-dd';
  static const HH_mm12Hour = 'hh:mm a';
  static const HH_mm24Hour = 'HH:mm';
}
//endregion

//region THEME MODE TYPE
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;
//endregion

//region LOGIN TYPE
class LoginTypeConst {
  static const LOGIN_TYPE_USER = 'user';
  static const LOGIN_TYPE_GOOGLE = 'google';
  static const LOGIN_TYPE_APPLE = 'apple';
  static const LOGIN_TYPE_OTP = 'mobile';
}
//endregion

//region SharedPreference Keys
class SharedPreferenceConst {
  static const IS_LOGGED_IN = 'IS_LOGGED_IN';
  static const USER_DATA = 'USER_LOGIN_DATA';
  static const USER_EMAIL = 'USER_EMAIL';
  static const USER_PASSWORD = 'USER_PASSWORD';
  static const FIRST_TIME = 'FIRST_TIME';
  static const IS_REMEMBER_ME = 'IS_REMEMBER_ME';
  static const USER_NAME = 'USER_NAME';
  static const AUTO_SLIDER_STATUS = 'AUTO_SLIDER_STATUS';
}
//endregion

const USER_NOT_CREATED = "User not created";

class UserKeys {
  static String firstName = 'first_name';
  static String lastName = 'last_name';
  static String userType = 'user_type';
  static String username = 'username';
  static String email = 'email';
  static String password = 'password';
  static String mobile = 'mobile';
  static String address = 'address';
  static String displayName = 'display_name';
  static String profileImage = 'profile_image';
  static String oldPassword = 'old_password';
  static String newPassword = 'new_password';
  static String playerId = 'player_id';
  static String loginType = 'login_type';
  static String contactNumber = 'contact_number';
}

//region CacheConst Keys
class APICacheConst {
  static const DASHBOARD_RESPONSE = 'HOME_SCREEN_RESPONSE';
  static const STATUS_RESPONSE = 'STATUS_RESPONSE';
  static const ABOUT_RESPONSE = 'ABOUT_RESPONSE';
  static const APP_CONFIGURATION_RESPONSE = 'APP_CONFIGURATION_RESPONSE';
  static const PET_TYPES = 'PET_TYPES';
  static const PET_CENTER_RESPONSE = 'PET_CENTER_RESPONSE';
}

//set Them

class SettingsLocalConst {
  static const THEME_MODE = 'THEME_MODE';
}
//endregion

//region CacheConst Keys
class ServicesKeyConst {
  static const boarding = 'boarding';
  static const veterinary = 'veterinary';
  static const grooming = 'grooming';
  static const walking = 'walking';
  static const training = 'training';
  static const dayCare = 'daycare';

  ///video-consultancy key
  static const videoConsultancyId = 19;
  static const videoConsultancyName = 'Video Consultancy';
}
//endregion

//region CacheConst Keys
class EmployeeKeyConst {
  static const boarding = 'boarder';
  static const veterinary = 'vet';
  static const grooming = 'groomer';
  static const walking = 'walker';
  static const training = 'trainer';
  static const dayCare = 'day_taker';
}
//endregion

//region Status
class StatusConst {
  static const pending = 'pending';
  static const upcoming = 'upcoming';
  static const confirmed = 'confirmed';
  static const completed = 'completed';
  static const reject = 'reject';
  static const cancel = 'cancel';
  static const inprogress = 'inprogress';
}

//endregion
//region Status
class NotificationConst {
  static const newBooking = 'new_booking';
  static const completeBooking = 'complete_booking';
  static const rejectBooking = 'reject_booking';
  static const acceptBooking = 'accept_booking';
  static const cancelBooking = 'cancel_booking';
  static const changePassword = 'change_password';
  static const forgetEmailPassword = 'forget_email_password';
  static const orderPlaced = 'order_placed';
  static const orderPending = 'order_pending';
  static const orderProcessing = 'order_proccessing';
  static const orderDelivered = 'order_delivered';
  static const orderCancelled = 'order_cancelled';
}

//endregion
class OrderStatus {
  static const order_placed = 'order_placed';
  static const Pending = 'pending';
  static const Processing = 'processing';
  static const Delivered = 'delivered';
  static const Cancelled = 'cancelled';
}

//region BOOKING STATUS
class BookingStatusConst {
  static const COMPLETED = 'completed';
  static const PENDING = 'pending';
  static const CONFIRMED = 'confirmed';
  static const CHECK_IN = 'check_in';
  static const CHECKOUT = 'checkout';
  static const CANCELLED = 'cancelled';
}
//endregion

//region ORDER STATUS
class OrderStatusConst {
  static const ORDER_PLACED = 'order_placed';
  static const PENDING = 'pending';
  static const PROCESSING = 'processing';
  static const DELIVERED = 'delivered';
  static const CANCELLED = 'cancelled';
}
//endregion

//region Status
class PriceStatusConst {
  static const pending = 'pending';
  static const upcoming = 'upcoming';
  static const confirmed = 'confirmed';
  static const cancel = 'cancel';
}
//endregion

//region TaxType Keys
class TaxType {
  static const FIXED = 'fixed';
  static const PERCENT = 'percent';
}
//endregion

//region PaymentStatus
class PaymentStatus {
  static const PAID = 'paid';
  static const pending = 'pending';
}
//endregion

//region Gender TYPE
class GenderTypeConst {
  static const MALE = 'male';
  static const FEMALE = 'female';
}
//endregion

//region PaymentMethods Keys
class PaymentMethods {
  static const PAYMENT_METHOD_CASH = 'cash';
  static const PAYMENT_METHOD_STRIPE = 'stripe';
  static const PAYMENT_METHOD_RAZORPAY = 'razorpay';
  static const PAYMENT_METHOD_PAYPAL = 'paypal';
  static const PAYMENT_METHOD_PAYSTACK = 'paystack';
  static const PAYMENT_METHOD_FLUTTER_WAVE = 'flutterwave';
}
//endregion

Country get defaultCountry {
  return Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 91,
    geographic: true,
    level: 1,
    name: 'India',
    example: '23456789',
    displayName: 'India (IN) [+91]',
    displayNameNoCountryCode: 'India (IN)',
    e164Key: '91-IN-0',
    fullExampleWithPlusSign: '+919123456789',
  );
}

Rx<UnitModel> defaulHEIGHT = UnitModel.fromJson({
  "id": 1,
  "name": "cm",
  "type": "PET_HEIGHT_UNIT",
  "value": "CM",
  "sequence": 0,
  "status": 1,
}).obs;

Rx<UnitModel> defaulWEIGHT = UnitModel.fromJson({
  "id": 2,
  "name": "kg",
  "type": "PET_WEIGHT_UNIT",
  "value": "KG",
  "sequence": 0,
  "status": 1,
}).obs;

// Currency position

//endregion

//region Currency position
class CurrencyPosition {
  static const CURRENCY_POSITION_LEFT = 'left';
  static const CURRENCY_POSITION_RIGHT = 'right';
  static const CURRENCY_POSITION_LEFT_WITH_SPACE = 'left_with_space';
  static const CURRENCY_POSITION_RIGHT_WITH_SPACE = 'right_with_space';
}

//endregion
class ProductModelKey {
  static String productId = 'product_id';
  static String cartId = 'cart_id';
  static String productVariationId = 'product_variation_id';
  static String qty = 'qty';
  static String reviewId = 'review_id';
  static String isLike = 'is_like';
  static String isDislike = 'dislike_like';
  static String locationId = 'location_id';
}

class ShippingDeliveryType {
  static String regular = 'regular';
}
