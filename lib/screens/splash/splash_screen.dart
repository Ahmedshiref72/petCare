import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/utils/app_common.dart';

import '../../components/app_logo_widget.dart';
import '../../components/app_scaffold.dart';
import '../../generated/assets.dart';
import '../../utils/constants.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashScreenController splashController =
      Get.put(SplashScreenController());
  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      body: Stack(
        children: [
          const Image(
            image: AssetImage(Assets.Splash),
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Image.asset(
              isDarkMode.value ? Assets.Splashlogo : Assets.Splashlogo,
              height: Constants.appLogoSize,
              width: Constants.appLogoSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const AppLogoWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
