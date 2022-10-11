import 'package:flutter/material.dart';
import 'package:shop_app/screens/generate_pdf/components/body.dart';

class GeneratePdfScreen extends StatelessWidget {
  static String routeName = "/generate_pdf";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate PDF Report"),
      ),
      body: Body(),
    );
  }
}
