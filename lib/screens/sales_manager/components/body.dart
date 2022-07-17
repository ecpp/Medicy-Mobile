import 'package:flutter/material.dart';
import '../../../screens/profile/components/profile_menu.dart';
import '../products/products.dart';
import '../products/products_discount.dart';
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProductsScreen()));
            },
          ),
          ProfileMenu(
            text: "Discount",
            icon: "assets/icons/box.svg",
            press: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProductsScreen2()));
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => pendingRefundsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
