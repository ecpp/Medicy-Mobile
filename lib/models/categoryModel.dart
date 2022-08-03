class categoryModel {
  String name;
  String id;
  String image;

  categoryModel(
      {required this.name,
  required this.id,
  required this.image,});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}
