import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/models/Product.dart';
import '../../../size_config.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Center(
              child: Text(
                product.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            )),
        SizedBox(height: getProportionateScreenHeight(10)),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
          ),
          child: Text(
            product.description,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${product.rating.toDouble()}" + "/5",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 7),
            SvgPicture.asset("assets/icons/Star Icon.svg"),
          ],
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: Text(
            (product.stock == 0 ? "\nOut of Stock!" : ""),
            style: TextStyle(
                color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
