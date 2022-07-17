class TransactionClass {
  num totalprice = 0;
  String user = "a";
  String transactionid = "a";
  String orderstatus = "placed";
  String invoicePath = "";
  Map<String, dynamic> items = {"test": 1};

  TransactionClass(
      {this.totalprice = 1,
      this.user = "a",
      this.transactionid = "a",
      this.orderstatus = "placed",
      this.invoicePath = "",
      required this.items});

// Our demo Products
}
