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
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(children: [
                    Container(
                      height: getProportionateScreenHeight(35),
                      width: getProportionateScreenWidth(100),
                      child: TextFormField(
                        controller: myController,
                        onChanged: (value) =>
                            {}, // Todo: IMPLEMENT THIS FUNCTION
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          hintText: "New Price",
                          suffix: Text("\$"),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(10),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(10)),
                    SizedBox(
                      width: getProportionateScreenWidth(100),
                      height: getProportionateScreenHeight(35),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          primary: Colors.white,
                          backgroundColor: kPrimaryColor,
                        ),
                        onPressed: () => {
                          setPrice(widget.product.title,
                              int.parse(myController.text)),
                          //Navigator.pop(context),
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "New Price of the " +
                                  widget.product.title.toString() +
                                  " is: " +
                                  myController.text +
                                  "\$",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: kPrimaryColor,
                          )),
                          setState(() {
                            widget.product.price = int.parse(myController.text);
                          })
                        },
                        child: Text(
                          "Set Price",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(10),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ])),
              Divider(color: Colors.black),
            ],
          ),
        )
      ],
    );
  }
}
