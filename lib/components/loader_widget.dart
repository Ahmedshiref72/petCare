import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/utils/colors.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Loader(
      valueColor: AlwaysStoppedAnimation(
       primaryColor,
      ),
    );
  }
}
