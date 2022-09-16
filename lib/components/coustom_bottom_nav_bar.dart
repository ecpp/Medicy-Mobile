import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';

import '../constants.dart';
import '../enums.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/sign_in/components/login_firebase.dart';
import '../screens/sign_in/sign_in_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],

      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Shop Icon.svg",
                    color: MenuState.home == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  //iconSize: MenuState.home == selectedMenu ? 15 : 20,
                  onPressed: () => {
                        if (MenuState.home != selectedMenu)
                          {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (Route<dynamic> route) => false,
                            )
                          }
                      }),

              // IconButton(
              //   icon: SvgPicture.asset("assets/icons/Heart Icon.svg"),
              //   onPressed: () {},
              // ),
              IconButton(
                icon:
                  SvgPicture.asset(
                    "assets/icons/Cart Icon.svg",
                    color: MenuState.cart == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),

                onPressed: () =>
                    Navigator.pushNamed(context, CartScreen.routeName),
              ),

              IconButton(
                  icon:
                      SvgPicture.asset(
                        "assets/icons/User Icon.svg",
                        color: MenuState.profile == selectedMenu
                            ? kPrimaryColor
                            : inActiveIconColor,
                      ),

                  //iconSize: MenuState.profile == selectedMenu ? 15 : 20,
                  onPressed: () {
                    if (MenuState.profile != selectedMenu) {
                      if (loginStatus) {
                        Navigator.pushNamed(context, ProfileScreen.routeName);
                      } else {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      }
                    }
                  }),
            ],
          )),
    );
  }
}
