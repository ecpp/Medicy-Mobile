import 'package:shop_app/screens/home/components/body.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'Product.dart';

class CartItem {
  final Product product;
  int numOfItem;

  CartItem({required this.product, required this.numOfItem});
}

// Demo data for our cart
class Cart {
  num sum = 0;
  List<CartItem>? cartItems = [
    CartItem(product: productListnew[0], numOfItem: 2),
  ];
  num sumAll() {
    if (sum != 0) {
      sum = 0;
    }
    for (int i = 0; i < cartItems!.length; i++) {
      sum += cartItems![i].product.price * cartItems![i].numOfItem;
    }
    sum = num.parse(sum.toStringAsFixed(2));
    return sum;
  }

  Cart({required this.sum, this.cartItems});
}

Cart currentCart = Cart(sum: 0, cartItems: []);
