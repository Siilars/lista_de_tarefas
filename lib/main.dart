import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app/view/home_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.blue,
      primaryColor: Colors.white,
    ),
  ));
}
