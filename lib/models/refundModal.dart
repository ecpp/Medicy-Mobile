class RefundModal {
  String name = "asdasd";
  num itemCount = 1;
  num pricePaid = 0;
  String itemName = " ";
  String refundid = "test";

  RefundModal({
    required this.name,
    required this.itemCount,
    required this.pricePaid,
    required this.itemName,
    required this.refundid,
  });

  RefundModal.fromJson(Map<String, dynamic> json) {
    itemName = json['productName'];
    name = json['name'];
    itemCount = json['itemCount'];
    pricePaid = json['pricePaid'];
    refundid = json['refundid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['itemCount'] = this.itemCount;
    data['pricePaid'] = this.pricePaid;
    data['refundid'] = this.refundid;
    return data;
  }
}
