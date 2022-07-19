import 'package:flutter/material.dart';
import 'package:shop_app/models/Cart.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final CartItem cart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(cart.product.images),
            ),
          ),
        ),
        SizedBox(width: 20),
        Flexible(
          flex: 1,
          child: Column(
            children: [
              Text(
                cart.product.title,
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "\$${cart.product.price}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                  children: [
                    TextSpan(
                        text: " x${cart.numOfItem}",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
