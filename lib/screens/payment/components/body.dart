import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/database_manager.dart';
import 'package:shop_app/helper/pdf_invoice_api.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/Transaction.dart';
import 'package:shop_app/screens/sign_in/components/login_firebase.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

void main() => runApp(Body());

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BodyState();
  }
}

class _BodyState extends State<Body> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: Colors.red,
                  backgroundImage: 'assets/images/card_bg.png',
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/images/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          themeColor: Colors.blue,
                          textColor: Colors.black,
                          cardNumberDecoration: InputDecoration(
                            labelText: 'Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: border,
                            enabledBorder: border,
                          ),
                          expiryDateDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Card Holder',
                          ),
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            primary: kPrimaryColor,
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            child: Text(
                              'PAY \$${currentCart.sum}',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'halter',
                                fontSize: 14,
                                package: 'flutter_credit_card',
                              ),
                            ),
                          ),
                          //${currentCart.sum}
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Valid(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

Valid(BuildContext context) {
  sendEmail(List<String> sendEmailTo, String subject, String emailBody,
      String path) async {
    await FirebaseFirestore.instance.collection("mail").add({
      'to': sendEmailTo,
      'message': {
        'subject': '$subject',
        'text': '$emailBody',
        'html':
            '<html>Hi! Thank you for shopping with us! You can find your invoice attached:</html>',
        'attachments': [
          {
            'path': '$path',
            'type': 'pdf',
            'name': 'Invoice',
            'filename': "Invoice.pdf",
          }
        ]
      },
    }).then(
      (value) => {print("Queued email for delivery!")},
    );
  }

  // Create button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () async {
      Navigator.pop(context);
      int i = 0;
      var uuid = Uuid();
      String randomid = uuid.v1();
      late Map<String, dynamic> items = {};
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Processing order...');

      await createTransaction(user!.uid, randomid, currentCart.sum);
      pd.update(value:10);
      while (i < currentCart.cartItems!.length) {
        String itemName = currentCart.cartItems![i].product.title +
            " x ${currentCart.cartItems![i].numOfItem}";
        pd.update(value:20);
        await addTransactiontoUser(randomid);
        await updateTransaction2(
            randomid, itemName, currentCart.cartItems![i].product.price);
        pd.update(value:40);
        items['$itemName'] = currentCart.cartItems![i].product.price;
        pd.update(value:70);
        await updateProduct(
            currentCart.cartItems![i].product.title,
            currentCart.cartItems![i].product.category,
            currentCart.cartItems![i].product.description,
            currentCart.cartItems![i].product.id,
            currentCart.cartItems![i].product.images,
            currentCart.cartItems![i].product.isPopular,
            currentCart.cartItems![i].product.price,
            currentCart.cartItems![i].product.rating,
            currentCart.cartItems![i].product.stock -
                currentCart.cartItems![i].numOfItem,
            currentCart.cartItems![i].product.numsold +
                currentCart.cartItems![i].numOfItem,
            currentCart.cartItems![i].product.title);
        i++;
      }

      // TransactionClass newTransaction =
      //     TransactionClass(items: items, totalprice: currentCart.sum);

      // final pdfFile = await PdfInvoiceApi.generate(newTransaction);
      // UploadTask uploadTask;
      // String saveName = "invoice_" + randomid;
      // final pathToInvoice = 'invoices/$saveName';
      // final ref = FirebaseStorage.instance.ref().child(pathToInvoice);
      // uploadTask = ref.putFile(pdfFile);
      //
      // final snapshot = await uploadTask.whenComplete(() => {});
      // final urlDownload = await snapshot.ref.getDownloadURL();
      // addPathToInvoice(randomid, urlDownload);

      // await sendEmail(
      //     ['${user?.email}'], "Order Placed", "Order Data", urlDownload);
      await removeallFromCartDB();
      currentCart = Cart(sum: 0, cartItems: []);
      pd.update(value: 100);
      pd.close();
      Navigator.popUntil(context, ModalRoute.withName('/home'));
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Payment Successful"),
    content: Text("Thank you for your order. Your payment will be processed."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
