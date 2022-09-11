// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, unused_local_variable

import 'package:easycharge/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:easycharge/services/Ai_camera.dart';
import 'package:easycharge/services/card_charge.dart';
import 'package:path_provider/path_provider.dart';

class Options extends StatefulWidget {
  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  Ai_cam ai_cam = Ai_cam();
  final card_num_field = TextEditingController();

  @override
  void initState() {
    super.initState();
    ai_cam.initPlatformState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          ai_cam.previewOcr = previewSizes[ai_cam.cameraOcr]!.first;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final Map comp_info = ModalRoute.of(context)?.settings.arguments as Map;
    String? value = "";
    var comp_list = comp_info["Item"];

    FocusNode myFocusNode = FocusNode();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text(comp_info["title"]),
          centerTitle: true,
          backgroundColor: comp_info['color']['titlecol'],
        ),
        backgroundColor: Colors.grey[200],
        body: Container(
            padding: const EdgeInsets.only(top: 70, right: 10, left: 20),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                comp_info["image"],
              ),
              fit: BoxFit.fill,
            )),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(top: 25, right: 15, left: 5),
                    child: TextField(
                      focusNode: myFocusNode,
                      controller: card_num_field,
                      maxLength: comp_info["cardNumberLen"],
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: comp_info["color"]['input']),
                      decoration: InputDecoration(
                          labelText: "اكتب كود الشحن او قم باستخراجه بالكاميرا",
                          labelStyle: TextStyle(
                            fontSize: 13,
                            color: myFocusNode.hasFocus
                                ? Colors.white
                                : comp_info["color"]['label'],
                          ),
                          counterStyle: TextStyle(
                              color: comp_info["color"]['counter'],
                              fontSize: 15),
                          filled: false,
                          enabled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  color: comp_info["color"]['border'],
                                  width: 3)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  color: comp_info['color']['border'],
                                  width: 2))),
                    ),
                  )),
                  MaterialButton(
                    onPressed: () async {
                      await ai_cam.ExtractNumber();

                      await ai_cam.textFieldText(card_num_field);
                    },
                    child: const Icon(Icons.camera_alt_rounded),
                    color: comp_info['color']['titlecol'],
                    minWidth: 50,
                    height: 50,
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  )
                ],
              ),
              DropdownButton<String>(
                hint: Text(
                  "بعد كتابه كود الشحن اختر طريقه الشحن من هنا",
                  style: TextStyle(
                      fontSize: 15,
                      color: comp_info["color"]['hint'],
                      fontWeight: FontWeight.bold),
                ),
                icon: const Icon(Icons.arrow_downward),
                elevation: 1,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 1,
                  color: Colors.white,
                ),
                onChanged: (String? newValue) {
                  setState(() async {
                    var extDir = await getApplicationDocumentsDirectory();
                    var dirPath = extDir.path;
                    value = newValue!;
                    ChargeCard(
                        ai_cam.cardnumber,
                        card_num_field.text,
                        comp_info['Codes'][comp_list.indexOf(newValue)],
                        dirPath,
                        comp_info["cardNumberLen"],
                        context);
                  });
                },
                items: comp_list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ])));
  }
}
