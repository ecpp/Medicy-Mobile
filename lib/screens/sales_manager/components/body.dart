import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/screens/generate_pdf/generate_pdf_screen.dart';
import '../../../screens/profile/components/profile_menu.dart';
import '../set_prices/setPrice.dart';
import '../set_discount/setDiscount.dart';
import '../refunds/pending_refunds.dart';

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
            text: "Set Prices",
            icon: "assets/icons/User Icon.svg",
            press: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: SetPriceScreen());
            },
          ),
          ProfileMenu(
            text: "Discount",
            icon: "assets/icons/box.svg",
            press: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: SetDiscountScreen());
            },
          ),
          ProfileMenu(
            text: "Invoices",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Refund Requests",
            icon: "assets/icons/Refund.svg",
            press: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: pendingRefundsScreen());
            },
          ),
          ProfileMenu(
            text: "Generate PDF",
            icon: "assets/icons/Settings.svg",
            press: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: GeneratePdfScreen());
            },
          ),
        ],
      ),
    );
  }
}
