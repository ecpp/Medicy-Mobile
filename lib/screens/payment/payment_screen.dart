import 'package:flutter/material.dart';
import 'components/body.dart';


class PaymentScreen extends StatelessWidget {
  static String routeName = "/payment";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Complete Payment",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
