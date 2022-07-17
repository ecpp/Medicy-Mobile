import 'package:flutter/material.dart';
import 'package:shop_app/helper/database_manager.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:shop_app/constants.dart';
import '../../../components/default_button.dart';

class PendingRefundUI extends StatelessWidget {
  final String name, itemName, refundid;
  final num itemCount, pricePaid;
  const PendingRefundUI({
    Key? key,
    required this.itemName,
    required this.name,
    required this.pricePaid,
    required this.itemCount,
    required this.refundid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: kPrimaryLightColor,
          width: 3,
        ),
      ),
      padding: EdgeInsets.only(
        top: 2.0,
        bottom: 2.0,
        left: 16.0,
        right: 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Product: ",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              Expanded(
                child: Text(
                  itemName,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.0),
          Divider(
            thickness: 3,
            color: Colors.grey,
          ),
          SizedBox(height: 6.0),
          Row(
            children: [
              Text(
                "Customer: ",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 6.0),
          Divider(
            thickness: 3,
            color: Colors.grey,
          ),
          SizedBox(height: 6.0),
          Row(
            children: [
              Text(
                "Price Paid: ",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "$pricePaid",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 6.0),
          Divider(
            thickness: 3,
            color: Colors.grey,
          ),
          SizedBox(height: 6.0),
          Row(
            children: [
              Text(
                "Item Count: ",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "$itemCount",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 6.0),
          Divider(
            thickness: 3,
            color: Colors.grey,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: DefaultButton(
                  text: "Approve Refund",
                  press: () async {
                    num currentStock = await getcurrentStock(itemName);
                    print("Current stock count: " + currentStock.toString());
                    currentStock = currentStock + itemCount;
                    print("Updated stock count: " + currentStock.toString());
                    await updateProductStock(itemName, currentStock);
                    await approveRefund(refundid);
                    //Update the transaction(indicate that a refund is applied to a specific purchased product in the transaction)!
                  }))
        ],
      ),
    );
  }
}
