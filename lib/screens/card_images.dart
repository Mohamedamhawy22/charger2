// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, prefer_const_constructors

import 'package:easycharge/screens/AppBar.dart';
import 'package:easycharge/screens/drawer.dart';
import 'package:easycharge/screens/options.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easycharge/services/database.dart';

class CardImages extends StatefulWidget {
  @override
  State<CardImages> createState() => _CardImagesState();
}

class _CardImagesState extends State<CardImages> {
  bool isVisible = true;
  List<Widget> Images_date = [
    Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(children: [
          Text(
            "Click the Button Below ",
            style: TextStyle(fontSize: 25.0, color: Colors.grey[700]),
          ),
          Container(
            child: Image.asset('assets/arrow.gif'),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.fromLTRB(5, 40, 5, 10),
          )
        ]))
  ];
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
            resizeToAvoidBottomInset: false,
            appBar: Appbar(),
            endDrawer: drawer(),
            body: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                    child: Column(
                  children: Images_date,
                ))),
            floatingActionButton: Visibility(
                visible: isVisible,
                child: FloatingActionButton(
                  child: const Icon(Icons.show_chart),
                  onPressed: () async {
                    ImageDatabase images_con = ImageDatabase();
                    await images_con.images_func();
                    setState(() {
                      if ((images_con.Images_date_con).length == 1) {
                        Images_date = [
                          Container(
                              margin: const EdgeInsets.all(20.0),
                              child: const Text(
                                "No Cards Founded",
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.grey),
                              )),
                          Container(
                            child: Image.asset('assets/error.gif'),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.fromLTRB(5, 40, 5, 10),
                          )
                        ];
                      } else {
                        images_con.Images_date_con.add(ElevatedButton(
                            onPressed: () async {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Are you sure to Delete All your Cards Images?"),
                                    actions: [
                                      TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () async {
                                          setState(() {
                                            Images_date = [
                                              Container(
                                                  margin: const EdgeInsets.all(
                                                      20.0),
                                                  child: const Text(
                                                    "No Cards Founded",
                                                    style: TextStyle(
                                                        fontSize: 25.0,
                                                        color: Colors.grey),
                                                  )),
                                              Container(
                                                child: Image.asset(
                                                    'assets/error.gif'),
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 40, 5, 10),
                                              )
                                            ];
                                          });
                                          Navigator.of(context).pop();
                                          await images_con.getDataBase();
                                          await images_con.openDataBase();
                                          await images_con.delete_images();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("No"),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.delete)));
                        Images_date = images_con.Images_date_con;
                      }
                      isVisible = false;
                    });
                  },
                ))));
  }
}
