// ignore_for_file: use_key_in_widget_constructors, file_names, non_constant_identifier_names

import 'package:easycharge/screens/AppBar.dart';
import 'package:easycharge/screens/card_images.dart';
import 'package:easycharge/screens/drawer.dart';
import 'package:easycharge/screens/options.dart';
import 'package:flutter/material.dart';
import 'package:easycharge/services/options_info.dart';
import 'package:easy_localization/easy_localization.dart';

class Help extends StatefulWidget {
  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        routes: {
          'options': (context) => Options(),
          'cardImages': (context) => CardImages()
        },
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: Appbar(),
            endDrawer: const drawer(),
            body: Stepper(
              currentStep: _index,
              onStepCancel: () {
                if (_index > 0) {
                  setState(() {
                    _index -= 1;
                  });
                }
              },
              onStepContinue: () {
                if (_index <= 6) {
                  setState(() {
                    _index += 1;
                  });
                }
              },
              onStepTapped: (int index) {
                setState(() {
                  _index = index;
                });
              },
              steps: con_list(),
            )));
  }
}

main_container_wid(var steps_list, var index) {
  return Step(
      title: Text(tr(steps_list[index])),
      content: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset('assets/help/${index + 1}.jpeg'),
      ));
}

List<Step> con_list() {
  List<Step> con_lis = [];
  for (int i = 0; i < steps.length; i++) {
    con_lis.add(main_container_wid(steps, i));
  }
  return con_lis;
}
