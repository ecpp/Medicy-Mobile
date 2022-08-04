import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/components/body.dart';
import 'package:shop_app/screens/pmanagerAdmin/products/components/stock_body.dart'
    as pbody;

class StockProductsScreen extends StatelessWidget {
  static String routeName = "/smanagerproducts";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: pbody.StockBody(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Products",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${productListnew.length} items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}