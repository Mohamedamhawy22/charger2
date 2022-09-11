// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names

import 'dart:async';
import 'package:easycharge/services/database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:path_provider/path_provider.dart';

class Ai_cam {
  String platformVersion = 'Unknown';
  int? cameraOcr = FlutterMobileVision.CAMERA_BACK;
  Size? previewOcr;
  var cardnumber = "";
  var images = ImageDatabase();

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterMobileVision.platformVersion ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    platformVersion = platformVersion;
  }

  Future ExtractNumber() async {
    List<OcrText> texts = [];
    Size _scanpreviewOcr = previewOcr ?? FlutterMobileVision.PREVIEW;
    var width = (_scanpreviewOcr.width * 0.50).toInt();
    await images.getDataBase();
    await images.openDataBase();
    await images.countImages();
    var no = images.no_paths;
    var extDir = await getApplicationDocumentsDirectory();
    var dirPath = extDir.path;
    try {
      texts = await FlutterMobileVision.read(
          flash: true,
          autoFocus: true,
          imagePath: '$dirPath/${no + 1}.jpg',
          preview: _scanpreviewOcr,
          waitTap: true,
          multiple: false,
          camera: cameraOcr ?? FlutterMobileVision.CAMERA_BACK,
          fps: 15.0,
          showText: true,
          scanArea: Size((width), 130));
    } on Exception {
      texts.add(OcrText('Failed to recognize text.'));
    }

    for (OcrText text in texts) {
      cardnumber = text.value.replaceAll(RegExp(r"\D"), "");
    }
  }

  Future textFieldText(var TextCont) async {
    TextCont.text = cardnumber;
  }
}
