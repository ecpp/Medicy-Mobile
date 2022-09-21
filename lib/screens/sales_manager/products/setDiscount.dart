import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/components/body.dart';
import 'package:shop_app/screens/sales_manager/products/components/body2.dart'
    as pbody;

class SetDiscountScreen extends StatelessWidget {
  static String routeName = "/smanagerproducts";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: buildAppBar(context),
          body: pbody.Body2(),
        ));
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
