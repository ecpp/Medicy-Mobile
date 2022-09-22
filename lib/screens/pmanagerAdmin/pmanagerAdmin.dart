import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/screens/comment/pending_comments.dart';
import 'package:shop_app/screens/pmanagerAdmin/deliveries.dart';
import 'package:shop_app/screens/pmanagerAdmin/products/add_remove_product.dart';
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
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: CategoriesScreen(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              ProfileMenu(
                text: "Add/Remove Product",
                icon: "assets/icons/User Icon.svg",
                press: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: ProductsScreen(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              ProfileMenu(
                text: "Deliveries",
                icon: "assets/icons/box.svg",
                press: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: DeliveriesScreen(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              ProfileMenu(
                text: "Approve Comments",
                icon: "assets/icons/Settings.svg",
                press: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: pendingCommentsScreen(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
            ],
          ),
        ));
  }
}
