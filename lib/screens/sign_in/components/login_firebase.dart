import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/screens/home/components/body.dart';
import 'package:shop_app/screens/sign_up/sign_up_screen.dart';
import 'package:shop_app/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants.dart';
import '../../../helper/database_manager.dart';
import '../../../main.dart';
import '../../../models/Product.dart';
import '../../home/home_screen.dart';

User? user;
String? userEmail, userFirstName, userSurname, userPassword;
String userType = "customer";
Map<String, dynamic>? userCart;
UserData newUser = UserData();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  static Future<User?> loginEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String loginError;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      loginStatus = true;
    } on FirebaseAuthException catch (e) {
      loginError = e.message!;

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("CAN'T LOGIN!"),
              content: Text(loginError),
            );
          });
      if (e.code == "user-not-found") {
        SnackBar(content: Text('Login error.'), duration: Duration(seconds: 3));
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 25)),
                        Container(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 34, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 25)),
                        Container(
                          child: Text(
                            "Login to experience new ways",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      emailFormField(),
                      SizedBox(
                        height: 20,
                      ),
                      passwordFormField(),
                      SizedBox(
                        height: 40,
                      ),
                      submitButton(),
                      SizedBox(
                        height: 40,
                      ),
                      registerButton(),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailFormField() {
    return TextField(
      decoration: InputDecoration(
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          contentPadding:
              new EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              borderSide: BorderSide.none),
          hintText: "Email",
          prefixIcon: Icon(Icons.alternate_email)),
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
    );
  }

  Widget passwordFormField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
        contentPadding:
            new EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide.none),
        hintText: "Password",
        prefixIcon: Icon(Icons.lock_outline),
      ),
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
    );
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: kPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          )),
      onPressed: () async {

        String userEmail = _emailController.text;

        newUser.email = userEmail;
        userSurname = newUser.surname;
        user = await loginEmailPassword(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user!.uid)
            .get()
            .then((dataFromDB) {
          userFirstName = dataFromDB.data()!["Name"];
          userSurname = dataFromDB.data()!["Surname"];
          userType = dataFromDB.data()!["type"];
          userCart = dataFromDB.data()!["userCart"];
        });
        if (user != null) {
          if (currentCart.sum != 0) {
            //FETCH LOCAL CART TO DB.

            await addToCartDB(currentCart.cartItems!.elementAt(0).product.title,
                currentCart.cartItems!.elementAt(0).numOfItem);
          }
          currentCart.cartItems!.clear(); //CLEAR LOCAL CART
          if (userCart != null) {
            int i = 0;
            for (var v in userCart!.values) {
              if (userCart!.values.elementAt(i) > 0) { //FETCH DB TO LOCAL CART
                Product itemToAdd = productListnew
                    .where((element) => element.title
                        .contains(userCart!.keys.elementAt(i).trimLeft()))
                    .toList()[0];
                currentCart.cartItems!.add(CartItem(
                    product: itemToAdd,
                    numOfItem: userCart!.values.elementAt(i)));
              }

              i++;
            }
          }

          Navigator.pushNamed(context, HomeScreen.routeName);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Sign In Success!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: kPrimaryColor,
          ));
        }
      },
      child: Text(
        "  Login  ",
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  ElevatedButton registerButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: kPrimaryColor,
          padding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          )),
      onPressed: () {
        // _formKey.currentState!.validate();
        Navigator.pushNamed(context, SignUpScreen.routeName);
      },
      child: Text(
        "Register",
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
