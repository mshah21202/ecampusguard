import 'dart:convert';

import 'package:flutter/services.dart';

class PhoneNumberValidator {
  PhoneNumberValidator() {
    _loadFile();
  }

  var data;

  Future<void> _loadFile() async {
    final String response =
        await rootBundle.loadString('assets/data/phoneNumberData.json');
    data = await json.decode(response);
  }

  bool isPhoneNumberValid(
      String countryCode, String phoneNumber, bool international) {
    var countryPhoneRegex = data[countryCode]
        [international ? "internationalPattern" : "nationalPattern"];

    if (countryPhoneRegex == null) {
      return true;
    }

    return RegExp((countryPhoneRegex as String)).hasMatch(phoneNumber);
  }
}
