import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/screens/shop/order/new_order_screen.dart';
import 'package:pawlly/utils/constants.dart';
import '../../../payment_gateways/flutter_wave_service.dart';
import '../../../payment_gateways/paypal_service.dart';
import '../../../payment_gateways/paystack_service.dart';
import '../../../payment_gateways/razor_pay_service.dart';
import '../../../payment_gateways/stripe_services.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../booking_module/booking_confirmation_dialog.dart';
import 'model/place_order_req.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import 'order_apis.dart';

OrderPaymentController orderPaymentController = OrderPaymentController();

class OrderPaymentController {
  ///ORDER Module Params
  PlaceOrderReq? placeOrderReq;
  num? amount;
  OrderPaymentController({
    this.placeOrderReq,
    this.amount,
  });

  //
  RxString paymentOption = PaymentMethods.PAYMENT_METHOD_CASH.obs;
  TextEditingController optionalCont = TextEditingController();
  RxBool isLoading = false.obs;
  RazorPayService razorPayService = RazorPayService();
  PayStackService paystackServices = PayStackService();
  FlutterWaveService flutterWaveServices = FlutterWaveService();

  handlePayNowClick(BuildContext context) {
    showInDialog(
      context,
      contentPadding: EdgeInsets.zero,
      builder: (context) {
        return ConfirmBookingDialog(
          titleText: locale.value.confirmOrder,
          subTitleText: locale.value.doYouConfirmThisPayment,
          confirmText: locale.value.iHaveReadAllDetailFillFormOrder,
          onConfirm: () {
            Get.back();
            if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_STRIPE) {
              payWithStripe();
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_RAZORPAY) {
              payWithRazorPay();
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYSTACK) {
              payWithPayStack(context);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE) {
              payWithFlutterWave(context);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYPAL) {
              payWithPaypal(context);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_CASH) {
              payWithCash();
            }
          },
        );
      },
    );
  }

  payWithStripe() async {
    await StripeServices.stripePaymentMethod(
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      amount: amount.validate(),
      onComplete: (res) {
        placeOrder(paymentType: PaymentMethods.PAYMENT_METHOD_STRIPE, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
  }

  payWithFlutterWave(BuildContext context) async {
    isLoading(true);
    flutterWaveServices.checkout(
      ctx: context,
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: amount.validate(),
      bookingId: 0,
      isTestMode: appConfigs.value.flutterwavePay.flutterwavePublickey.toLowerCase().contains("test"),
      onComplete: (res) {
        placeOrder(paymentType: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    isLoading(false);
  }

  payWithPaypal(BuildContext context) {
    isLoading(true);
    PayPalService.paypalCheckOut(
      context: context,
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: amount.validate(),
      onComplete: (res) {
        placeOrder(paymentType: PaymentMethods.PAYMENT_METHOD_PAYPAL, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
  }

  payWithPayStack(BuildContext context) async {
    isLoading(true);
    await paystackServices.init(
      context: context,
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: amount.validate(),
      bookingId: 0,
      onComplete: (res) {
        placeOrder(paymentType: PaymentMethods.PAYMENT_METHOD_PAYSTACK, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    isLoading(false);
    paystackServices.checkout();
  }

  payWithRazorPay() async {
    isLoading(true);
    razorPayService.init(
      razorKey: appConfigs.value.razorPay.razorpaySecretkey,
      totalAmount: amount.validate(),
      onComplete: (res) {
        log("txn id: $res");
        placeOrder(paymentType: PaymentMethods.PAYMENT_METHOD_RAZORPAY, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    razorPayService.razorPayCheckout();
    await Future.delayed(const Duration(seconds: 2));
    isLoading(false);
  }

  payWithCash() async {
    placeOrder(paymentType: PaymentMethods.PAYMENT_METHOD_CASH, txnId: "", paymentStatus: PaymentStatus.pending);
  }

  ///SHOP MODULE PLACE ORDER API
  void placeOrder({required String txnId, required String paymentType, required String paymentStatus}) {
    debugPrint('PAYMENTSTATUS: $paymentStatus');
    hideKeyBoardWithoutContext();
    if (placeOrderReq == null) return;
    isLoading(true);
    placeOrderReq!.paymentDetails = txnId;
    placeOrderReq!.paymentMethod = paymentType;
    placeOrderReq!.paymentStatus = paymentStatus;
    debugPrint('PLACEORDERREQ!.TOJSON(): ${placeOrderReq!.toJson()}');

    /// Place Order API
    OrderApis.placeOrderAPI(placeOrderReq!.toJson()).then((value) async {
      debugPrint('ORDERLISTSCREEN:placeOrderAPI ');
      cartItemCount(0);
      Get.offUntil(GetPageRoute(page: () => NewOrderScreen()), (route) => route.isFirst || route.settings.name == '/$DashboardScreen');
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }
}
