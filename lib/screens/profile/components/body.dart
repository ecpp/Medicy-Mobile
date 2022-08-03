import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/pmanagerAdmin/pmanagerAdmin.dart';
import 'package:shop_app/screens/profile/my_orders/orders_page.dart';
import 'package:shop_app/screens/sales_manager/sales_manager_screen.dart';
import 'package:shop_app/models/Cart.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../my_account.dart';
import 'profile_menu.dart';
import '../../sign_in/components/login_firebase.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          //ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () {
              if (loginStatus == true)
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ProfileMenu(
            text: "My Orders",
            icon: "assets/icons/box.svg",
            press: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TransactionScreen()));
            },
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          if (userType == "pmanager" || userType == "admin")
            ProfileMenu(
              text: "Product Management",
              icon: "assets/icons/comment-svgrepo-com.svg",
              press: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductManagerAdminScreen()));
              },
            ),
          if (userType == "smanager" || userType == "admin")
            ProfileMenu(
              text: "Sales Managment",
              icon: "assets/icons/comment-svgrepo-com.svg",
              press: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SalesManagerScreen()));
              },
            ),
          ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async{
                currentCart.cartItems!.clear();
                currentCart.sum = 0;
                if (loginStatus == true) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Logout Success!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: kPrimaryColor,
                  ));
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('userPassword');
                  await prefs.remove('userEmail');
                  loginStatus = false;
                  user = null;
                  FirebaseAuth auth = FirebaseAuth.instance;
                  auth.signOut().then((value) {
                    //Navigator.pushNamed(context, HomeScreen.routeName);
                    Navigator.pop(context);
                  });
                }
              }),
        ],
      ),
    );
  }
}
