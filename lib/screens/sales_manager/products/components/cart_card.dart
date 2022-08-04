import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/database_manager.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/size_config.dart';

class ProductCard extends StatefulWidget {
  ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final myController = TextEditingController();
  //var productPrice;
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
              child: Image.network(widget.product.images),
            ),
          ),
        ),
        SizedBox(width: 20),
        Flexible(
          flex: 1,
          child: Column(
            children: [
              Text(
                widget.product.title,
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: widget.product.price.toString() + "\$",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                ),
              ),

            ],
          ),
        )
      ],
    );
  }
}
