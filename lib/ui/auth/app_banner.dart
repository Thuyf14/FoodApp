import 'dart:math';

import 'package:flutter/material.dart';
//Hien thi tieu de cua ung dung
class AppBanner extends StatelessWidget {
  const AppBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0, top: 44),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 94.0,
      ),
      child: Text("FOOD APP", style: TextStyle(fontSize: 30),)
      // Image.asset('assets/Images/logo.jpg'),
    );
  }
}
