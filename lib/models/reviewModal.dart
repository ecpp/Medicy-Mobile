class ReviewModal {
  String name = "asdasd";
  num rating = 1;
  String comment = "asdasd";
  String itemName = " ";
  String reviewid = "test";

  ReviewModal(
      {required this.name,
      required this.rating,
      required this.comment,
      required this.itemName,
      required this.reviewid,});

  ReviewModal.fromJson(Map<String, dynamic> json) {
    itemName = json['productName'];
    name = json['name'];
    rating = json['rating'];
    comment = json['comment'];
    reviewid = json['reviewid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['reviewid'] = this.reviewid;
    return data;
  }
}
