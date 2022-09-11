// ignore_for_file: non_constant_identifier_names

import 'package:easycharge/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

ChargeCard(String cameraExNo, String card_number, String code, var dirPath,
    var cardNumberLen, var context) async {
  if (card_number.length == cardNumberLen) {
    FlutterPhoneDirectCaller.callNumber('*' + code + '*' + card_number + '#');
    if (cameraExNo.length == cardNumberLen) {
      ImageDatabase images = ImageDatabase();
      await images.getDataBase();
      await images.openDataBase();
      await images.countImages();
      await images.dataUpdate('$dirPath/${images.no_paths + 1}.jpg');
    }
  } else {
    return showAlertDialog(context);
  }
}

showAlertDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Error"),
        content: const Text("The card number is wrong"),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
