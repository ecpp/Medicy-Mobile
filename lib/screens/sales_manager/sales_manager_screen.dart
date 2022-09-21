import 'package:flutter/material.dart';
import 'package:shop_app/enums.dart';

import 'components/body.dart';

class SalesManagerScreen extends StatelessWidget {
  static String routeName = "/salesManager";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Manager"),
      ),
      body: Body(),
    );
  }
}
