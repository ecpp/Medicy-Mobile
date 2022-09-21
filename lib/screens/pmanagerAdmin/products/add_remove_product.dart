import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/components/body.dart';
import 'package:shop_app/screens/pmanagerAdmin/products/add_product.dart';
import 'package:shop_app/screens/pmanagerAdmin/products/components/body.dart'
    as pbody;

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductsScreen extends StatelessWidget {
  static String routeName = "/pmanagerproducts";
  List<String> cats = [];
  @override
  Widget build(BuildContext context) {
    getCate();
    return Scaffold(
      appBar: buildAppBar(context),
      body: pbody.Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Text(
              "Products",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "${productListnew.length} items",
              style: Theme.of(context).textTheme.caption,
            ),
          ]),
          SizedBox(
            width: getProportionateScreenWidth(80),
            height: getProportionateScreenHeight(35),
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: Colors.white,
                backgroundColor: kPrimaryColor,
              ),
              onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddProductScreen(
                          cats: cats,
                        )))
              },
              child: Text(
                "Add New",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(13),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getCate() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    ;

    // Get data from docs and convert map to Lis
    //for a specific field
    final allData = await querySnapshot.docs
        .map((doc) => doc.get('name') as String)
        .toList();
    print(allData);

    for (var task in allData) {
      // do something
      cats.add(task);
    }

    print(cats);
  }
}
