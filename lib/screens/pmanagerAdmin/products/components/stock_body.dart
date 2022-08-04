import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/screens/home/components/body.dart';
import 'package:shop_app/screens/pmanagerAdmin/products/components/stock_cart_card.dart';
import 'package:shop_app/size_config.dart';

import 'cart_card.dart';

class StockBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StockBodyState();
  }
}

class _StockBodyState extends State<StockBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ListView.builder(
        itemCount: productListnew.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(productListnew[index].id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                //    currentCart.sum = 5;
                //   currentCart.cartItems!.removeAt(index);
              });
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),
                  SvgPicture.asset("assets/icons/Trash.svg"),
                ],
              ),
            ),
            child: StockProductCard(product: productListnew[index]),
          ),
        ),
      ),
    );
  }
}