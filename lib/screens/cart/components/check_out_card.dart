import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/screens/payment/payment_screen.dart';
import '../../../size_config.dart';
import 'package:shop_app/models/Cart.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({
    Key? key,
    required this.stream,
  }) : super(key: key);
  final Stream<num> stream;
  @override
  _CheckoutCardState createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  num totalsum = currentCart.sumAll();

  @override
  void initState() {
    super.initState();
    widget.stream.listen((totalsum) {
      mySetState(totalsum);
    });
  }

  void mySetState(num i) {
    if (!mounted) return;
    setState(() {
      totalsum = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "\$${totalsum}",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                      text: "Check Out",
                      press: () => {
                            if (loginStatus == true)
                              {
                                if (currentCart.sumAll() > 0)
                                  {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: PaymentScreen(),
                                      withNavBar:
                                          false, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    ),
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        "Please add items to your cart!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      duration: Duration(seconds: 1),
                                      backgroundColor: kPrimaryColor,
                                    ))
                                  }
                              }
                            else
                              {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "You need to login in order to check out!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: kPrimaryColor,
                                ))
                              }
                          }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
