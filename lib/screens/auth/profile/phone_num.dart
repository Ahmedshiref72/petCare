import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/common_base.dart';

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith('965') && newValue.text.length >= 3) {
      return newValue.copyWith(text: '9655' + newValue.text.substring(3));
    }
    return TextEditingValue(text: '9655');
  }
}

class YourWidget extends StatelessWidget {
  final addAddressController =
      AddAddressController(); // Assuming this is defined somewhere

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      title: locale.value.phone,
      textStyle: primaryTextStyle(size: 12),
      controller: addAddressController.phoneCont
        ..text = '9655', // Set initial value
      focus: addAddressController.phoneFocus,
      textFieldType: TextFieldType.NUMBER,
      maxLength: 12, // '9655' + 8 more digits
      inputFormatters: [CustomInputFormatter()], // Add custom formatter
      validator: (v) {
        // Your existing validation logic
        return null; // Adjust validation logic as needed
      },
      decoration: inputDecoration(
        context,
        hintText: '+965',
        fillColor: context.cardColor,
        filled: true,
      ),
      suffix: Icon(Icons.phone, size: 20.0),
    );
  }
}

class AddAddressController {
  TextEditingController phoneCont = TextEditingController();
  FocusNode phoneFocus = FocusNode();
}
