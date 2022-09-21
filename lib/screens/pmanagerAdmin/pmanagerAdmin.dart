import 'package:flutter/material.dart';
import 'package:shop_app/screens/comment/pending_comments.dart';
import 'package:shop_app/screens/pmanagerAdmin/deliveries.dart';
import 'package:shop_app/screens/pmanagerAdmin/products/products.dart';
import '../../../screens/profile/components/profile_menu.dart';
import 'categories/categories.dart';

class ProductManagerAdminScreen extends StatelessWidget {
  static String routeName = "/pmanagerpanel";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('App Name'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              //ProfilePic(),
              SizedBox(height: 20),
              ProfileMenu(
                text: "Add Category",
                icon: "assets/icons/Settings.svg",
                press: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoriesScreen()));
                },
              ),
              ProfileMenu(
                text: "Add/Remove Product",
                icon: "assets/icons/User Icon.svg",
                press: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductsScreen()));
                },
              ),
              ProfileMenu(
                text: "Deliveries",
                icon: "assets/icons/box.svg",
                press: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DeliveriesScreen()));
                },
              ),
              ProfileMenu(
                text: "Approve Comments",
                icon: "assets/icons/Settings.svg",
                press: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => pendingCommentsScreen()));
                },
              ),
            ],
          ),
        ));
  }
}
