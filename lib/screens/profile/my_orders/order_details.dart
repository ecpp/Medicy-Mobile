import 'package:check_points/check_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/database_manager.dart';
import 'package:shop_app/models/Transaction.dart';
import 'package:shop_app/screens/comment/commentproducts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../helper/file_handle_api.dart';
import '../../../helper/pdf_invoice_api.dart';
import '../../../size_config.dart';

class OrderDetailsPage extends StatefulWidget {
  final TransactionClass transaction;

  // In the constructor, require a Person
  OrderDetailsPage({Key? key, required this.transaction}) : super(key: key);
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return orderDetailUI(widget.transaction);
  }

  Widget orderDetailUI(TransactionClass model) {
    int checkint = 0;
    String orderstat = "Order Status";
    if (model.orderstatus == "completed")
      checkint = 2;
    else if (model.orderstatus == "placed")
      checkint = 0;
    else if (model.orderstatus == "shipping")
      checkint = 1;
    else if (model.orderstatus == "cancelled") {
      orderstat = "Your order is cancelled!";
      checkint = -1;
    }
    ;
    return Scaffold(
      appBar: AppBar(
        title: Text(orderstat,
            style: TextStyle(color: kPrimaryColor, fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          // Text(orderstat,
          //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          CheckPoint(
            checkedTill: checkint,
            checkPoints: ["Placed", "Shipping", "Completed"],
            checkPointFilledColor: Colors.redAccent,
          ),
          Divider(color: Colors.grey),
          _listOrder(model),
          SizedBox(height: 10),
          Text(
            "Total: ${model.totalprice}\$",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent),
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
          if (model.invoicePath != "null") showInvoice(model),
          //comment(context, model),
        ]),
      ),
    );
  }

  Widget _listOrder(TransactionClass model) {
    return ListView.builder(
      itemCount: model.items.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        String currentitem = model.items.keys.elementAt(index);
        final splitted = currentitem.split(' x ');
        currentitem = splitted[0];
        return ListTile(
          dense: false,
          contentPadding: EdgeInsets.all(2),
          onTap: () {},
          title: new Text(
            model.items.keys.elementAt(index),
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Padding(
              padding: EdgeInsets.all(1),
              child: new Text(
                "Price per item: ${model.items.values.elementAt(index)}\$",
                style: TextStyle(fontSize: 14),
              )),
          trailing: Wrap(children: [
            Column(children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: SizedBox(
                  width: 50,
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                    onPressed: () async {
                      //print(checkifReviewExists(currentitem));
                      if (await checkifReviewExists(currentitem) == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "You already commented on this item!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: kPrimaryColor,
                        ));
                      } else if (widget.transaction.orderstatus !=
                          "completed") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "You cant comment on not-completed orders!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: kPrimaryColor,
                        ));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CommentProductScreen(itemname: currentitem)));
                      }
                    },
                    child: Text(
                      "Review",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  onPressed: () async {
                    if (await checkifRefundExists(
                            currentitem, model.transactionid) ==
                        true) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "You already requested a refund on this item!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        duration: Duration(seconds: 3),
                        backgroundColor: kPrimaryColor,
                      ));
                    }
                    //Check if the purchase is within 30 days!!!
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Your refund request is sent!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        duration: Duration(seconds: 3),
                        backgroundColor: kPrimaryColor,
                      ));
                      requestRefund(
                          currentitem,
                          model.transactionid,
                          int.parse(splitted[1]),
                          (model.items.values.elementAt(index)) *
                              (int.parse(splitted[1])));
                    }
                  },
                  child: Text(
                    "Refund",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        );
      },
    );
  }
}

Widget showInvoice(TransactionClass model) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: TextButton(
      style: TextButton.styleFrom(
        primary: kPrimaryColor,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Color(0xFFF5F6F9),
      ),
      onPressed: () async {
        // PermissionStatus permissions = await Permission.storage.request();
        // if (permissions.isGranted) {
        //   final pdfFile = await PdfInvoiceApi.generate(model);
        //   FileHandleApi.openFile(pdfFile);
        // } else {
        //   print("COULD NOT AUTHORIZE");
        // }
      },
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/receipt.svg",
            color: kPrimaryColor,
            width: 22,
          ),
          SizedBox(width: 20),
          Expanded(child: Text("See invoice")),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    ),
  );
}

/*Widget comment(BuildContext context, TransactionClass model) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: TextButton(
      style: TextButton.styleFrom(
        primary: kPrimaryColor,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Color(0xFFF5F6F9),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                CommentProductScreen(itemname: currentitem)));
      },
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/comment-svgrepo-com.svg",
            color: kPrimaryColor,
            width: 22,
          ),
          SizedBox(width: 20),
          Expanded(child: Text("Comment")),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    ),
  );
}*/
