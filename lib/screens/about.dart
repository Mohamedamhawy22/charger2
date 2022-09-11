// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:easycharge/screens/AppBar.dart';
import 'package:easycharge/screens/card_images.dart';
import 'package:easycharge/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:easycharge/services/options_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easycharge/screens/options.dart';

class About extends StatelessWidget {
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
            endDrawer: drawer(),
            body: Padding(
                padding: const EdgeInsets.all(7),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple.shade300),
                          color: Colors.purple.shade100),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                                team_members['personal_iamge'][index]),
                          ),
                          Container(
                              padding: const EdgeInsets.all(6),
                              child: Text(team_members['names'][index],
                                  style: const TextStyle(
                                      fontSize: 18.0, color: Colors.black)))
                        ],
                      ),
                    );
                  },
                  itemCount: team_members['names'].length,
                ))));
  }
}
