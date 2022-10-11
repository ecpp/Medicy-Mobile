import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/database_manager.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/pmanagerAdmin/pmanagerAdmin.dart';
import 'package:shop_app/screens/profile/my_orders/orders_page.dart';
import 'package:shop_app/screens/sales_manager/sales_manager_screen.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/screens/user_reports/user_reports.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../my_account.dart';
import '../profile_screen.dart';
import 'profile_menu.dart';
import '../../sign_in/components/login_firebase.dart';

// Future<String> _getUserType() async{
//   String _userType = await getUserType();
//   print('user type ' + _userType.length.toString());
//   print('old type ' + userType.length.toString());
//   if(_userType == 'admin') {
//     print('same type');
//   }
//   return _userType;
// }

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
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: MyAccount(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
            },
          ),
          ProfileMenu(
            text: "My Orders",
            icon: "assets/icons/box.svg",
            press: () {
              PersistentNavBarNavigator.pushNewScreen(context, screen: TransactionScreen(), withNavBar: true, pageTransitionAnimation: PageTransitionAnimation.cupertino);
            },
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          if (getUserType().toString().contains('a'))
            ProfileMenu(
              text: "Admin Panel 1",
              icon: "assets/icons/comment-svgrepo-com.svg",
              press: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: ProductManagerAdminScreen(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
          if (getUserType().toString().contains('a'))
            ProfileMenu(
              text: "Admin Panel 2",
              icon: "assets/icons/comment-svgrepo-com.svg",
              press: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: SalesManagerScreen(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
          ProfileMenu(
            text: "My Documents",
            icon: "assets/icons/Mail.svg",
            press: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: UserReportsScreen(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Hold On!'),
                content: const Text('Are you sure want to log out?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
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
                          duration: Duration(seconds: 1),
                          backgroundColor: kPrimaryColor,
                        ));
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('userPassword');
                        await prefs.remove('userEmail');
                        loginStatus = false;
                        user = null;
                        FirebaseAuth auth = FirebaseAuth.instance;
                        auth.signOut().then((value) {
                          //Navigator.pushNamed(context, HomeScreen.routeName);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false,
                          );
                        });
                      }
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
