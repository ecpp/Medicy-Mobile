import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_app/helper/database_manager.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/cart/components/check_out_card.dart';
import '../../../main.dart';
import '../../../size_config.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
    required this.stream,
  }) : super(key: key);
  final Stream<num> stream;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
    //initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ListView.builder(
        itemCount: currentCart.cartItems!.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(UniqueKey().toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              if (loginStatus == true)
                await removeFromCartDB(
                    currentCart.cartItems!.elementAt(index).product.title);
              currentCart.cartItems!.removeAt(index);
              cartStreamController.add(currentCart.sumAll());
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
            child: CartCard(cart: currentCart.cartItems![index]),
          ),
        ),
      ),
    );
  }
}
