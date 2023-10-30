import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/screens/dashboard/dashboard_controller.dart';

import '../../components/app_scaffold.dart';
import '../../components/service_app_button.dart';
import '../../generated/assets.dart';
import 'payment_controller.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.payment,
      isLoading: paymentController.isLoading,
      body: Stack(
        fit: StackFit.expand,
        children: [
          RefreshIndicator(
            onRefresh: () async {
              getAppConfigurations();
              return await Future.delayed(const Duration(seconds: 2));
            },
            child: Obx(
              () => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonDivider,
                    8.height,
                    Text(locale.value.choosePaymentMethod, style: primaryTextStyle()).paddingSymmetric(horizontal: 16),
                    8.height,
                    Text(locale.value.chooseYourConvenientPaymentOptions, style: secondaryTextStyle()).paddingSymmetric(horizontal: 16),
                    32.height,
                    if (!paymentController.isFromBookingDetail) cashAfterService(context),
                    8.height.visible(appConfigs.value.stripePay.stripePublickey.isNotEmpty && appConfigs.value.stripePay.stripeSecretkey.isNotEmpty),
                    stripePaymentWidget(context).visible(appConfigs.value.stripePay.stripePublickey.isNotEmpty && appConfigs.value.stripePay.stripeSecretkey.isNotEmpty),
                    8.height.visible(appConfigs.value.razorPay.razorpaySecretkey.isNotEmpty),
                    razorPaymentWidget(context).visible(appConfigs.value.razorPay.razorpaySecretkey.isNotEmpty),
                    8.height.visible(appConfigs.value.paystackPay.paystackPublickey.isNotEmpty && appConfigs.value.paystackPay.paystackSecretkey.isNotEmpty),
                    payStackPaymentWidget(context).visible(appConfigs.value.paystackPay.paystackPublickey.isNotEmpty && appConfigs.value.paystackPay.paystackSecretkey.isNotEmpty),
                    8.height.visible(appConfigs.value.paypalPay.paypalSecretkey.isNotEmpty),
                    payPalPaymentWidget(context).visible(appConfigs.value.paypalPay.paypalSecretkey.isNotEmpty),
                    8.height.visible(appConfigs.value.flutterwavePay.flutterwaveSecretkey.isNotEmpty && appConfigs.value.flutterwavePay.flutterwavePublickey.isNotEmpty),
                    flutterWavePaymentWidget(context).visible(appConfigs.value.flutterwavePay.flutterwaveSecretkey.isNotEmpty && appConfigs.value.flutterwavePay.flutterwavePublickey.isNotEmpty),
                    32.height,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: AppButtonWithPricing(
              buttonTitle: locale.value.payNow,
              price: paymentController.isFromBookingDetail ? paymentController.amount.validate().toStringAsFixed(2).toDouble() : totalAmount.toStringAsFixed(2).toDouble(),
              tax: paymentController.isFromBookingDetail ? paymentController.tax.validate().toStringAsFixed(2).toDouble() : totalTax.toStringAsFixed(2).toDouble(),
              items: paymentController.isFromBookingDetail && paymentController.bookingService != null ? paymentController.bookingService!.name.capitalizeFirstLetter() : currentSelectedService.value.name.capitalizeFirstLetter(),
              serviceImg: paymentController.isFromBookingDetail && paymentController.bookingService != null ? paymentController.bookingService!.serviceImage : currentSelectedService.value.serviceImage,
              onTap: () {
                paymentController.handleBookNowClick(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget stripePaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesStripeLogo),
          color: darkGrayGeneral,
          height: 16,
          width: 22,
        ),
        fillColor: MaterialStateProperty.all(primaryColor),
        title: Text("Stripe", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_STRIPE,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget razorPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesRazorpayLogo),
          color: darkGrayGeneral,
          height: 18,
          width: 24,
        ),
        fillColor: MaterialStateProperty.all(primaryColor),
        title: Text("Razor Pay", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_RAZORPAY,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget payStackPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesPaystackLogo),
          color: darkGrayGeneral,
          height: 18,
          width: 24,
        ),
        fillColor: MaterialStateProperty.all(primaryColor),
        title: Text("Paystack", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_PAYSTACK,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget payPalPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesPaypalLogo),
          color: darkGrayGeneral,
          height: 18,
          width: 24,
        ),
        fillColor: MaterialStateProperty.all(primaryColor),
        title: Text("Paypal", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_PAYPAL,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget flutterWavePaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesFlutterWaveLogo),
          color: darkGrayGeneral,
          height: 18,
          width: 24,
        ),
        fillColor: MaterialStateProperty.all(primaryColor),
        title: Text("Flutter Wave", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget cashAfterService(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.iconsIcCash),
          color: darkGrayGeneral,
          height: 18,
          width: 24,
        ),
        fillColor: MaterialStateProperty.all(primaryColor),
        title: Text("Cash after service", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_CASH,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
