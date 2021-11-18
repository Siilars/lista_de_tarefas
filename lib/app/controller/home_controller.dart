import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomeController {
  bool isLoading = true;

  final toDoController = TextEditingController();

  List toDoList = [];

  late Map<String, dynamic> lastRemoved;

  late int lastRemovedPos;

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> saveData({required List toDoList}) async {
    String data = json.encode(toDoList);
    final file = await getFile();
    return file.writeAsString(data);
  }

  Future<String?> readData() async {
    try {
      final file = await getFile();
      await Future.delayed(Duration(seconds: 2));
      isLoading = false;
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 1));
    toDoList.sort((a, b) {
      if (a["ok"] && !b["ok"])
        return 1;
      else if (!a["ok"] && b["ok"])
        return -1;
      else
        return 0;
    });
    saveData(toDoList: toDoList);
  }
}
