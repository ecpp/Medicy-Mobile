import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/components/body.dart';
import 'package:shop_app/size_config.dart';

import 'cart_card2.dart';

class Body2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BodyState();
  }
}

class _BodyState extends State<Body2> {
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
            ),
            child: ProductCard2(product: productListnew[index]),
          ),
        ),
      ),
    );
  }
}
