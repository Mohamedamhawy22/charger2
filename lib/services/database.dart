// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class ImageDatabase {
  String path = '';
  var database;
  int no_paths = 0;
  var ImagesPaths;
  var dates;
  var date_images;
  var Images_date_con;
  Future getDataBase() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'cards.db');
  }

  Future openDataBase() async {
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS images (id INTEGER PRIMARY KEY, path TEXT,date TEXT)');
    });
  }

  Future dataGet() async {
    ImagesPaths = await database.rawQuery('SELECT path , date FROM images');
    dates = await database.rawQuery('SELECT  date FROM images group by date');
  }

  Future countImages() async {
    var ImagesCount = await database
        .rawQuery('SELECT id FROM images order by id DESC LIMIT 1');
    if (ImagesCount.length != 0) {
      no_paths = ImagesCount[0]['id'];
    } else {
      no_paths = 0;
    }
  }

  Future dataSpe(var condition) async {
    date_images = await database
        .rawQuery("SELECT  path FROM images where date = '$condition'");
  }

  Future dataUpdate(String path) async {
    DateTime now = DateTime.now();

    String date = "${now.year} - ${now.month} - ${now.day}";

    await database.transaction((txn) async {
      txn.rawInsert('INSERT INTO images(path, date) VALUES("$path", "$date")');
    });
  }

  Future delete_images() async {
    await database.transaction((txn) async {
      txn.rawInsert('DELETE FROM images');
    });
  }

  Future images_func() async {
    List<Widget> images_con = [
      Container(
          margin: const EdgeInsets.all(20.0),
          child: const Text(
            "Charged Cards",
            style: TextStyle(fontSize: 25.0, color: Colors.grey),
          ))
    ];

    ImageDatabase imagesDates = ImageDatabase();
    var date_images;
    await imagesDates.getDataBase();
    await imagesDates.openDataBase();
    await imagesDates.dataGet();
    for (int i = 0; i < (imagesDates.dates).length; i++) {
      await imagesDates.dataSpe(imagesDates.dates[i]['date']);
      date_images = imagesDates.date_images;
      images_con.add(Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.all(5),
          child: ExpansionTile(
              title: Text("${imagesDates.dates[i]['date']}"),
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: date_images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Image.file(
                        File(date_images[index]["path"]),
                      ),
                      margin: const EdgeInsets.all(8.0),
                    );
                  },
                ),
              ])));
    }

    Images_date_con = images_con;
  }
}
