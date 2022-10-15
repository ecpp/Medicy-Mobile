import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/screens/home/components/body.dart';
import 'package:shop_app/screens/home/components/home_categories.dart';
import 'package:shop_app/screens/pmanagerAdmin/products/add_product.dart';
import 'package:shop_app/screens/pmanagerAdmin/products/components/body.dart'
    as pbody;

import '../../../constants.dart';
import '../../../size_config.dart';

class AddProductScreen extends StatelessWidget {
  static String routeName = "/pmanagerproducts";
  List<String> cats = [];
  @override
  Widget build(BuildContext context) {
    getCategories();
    return Scaffold(
      appBar: buildAppBar(context),
      body: pbody.AddProductBody(allCategories: cats),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Text(
              "Add Product",
              style: TextStyle(color: Colors.black),
            ),
          ]),
        ],
      ),
    );
  }

  getCategories() {
    // Get docs from collection reference
    cats.clear();
    for (var elem in categories) {
      cats.add(elem.name);
    }
  }
}
