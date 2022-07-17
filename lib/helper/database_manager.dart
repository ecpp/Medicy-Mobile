import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/models/reviewModal.dart';
import 'package:shop_app/screens/sign_in/components/login_firebase.dart';

class DatabaseManager {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('products_new');
  Future<void> createProduct(
      String name, int price, int stockCount, int weight, String pid) async {
    return await productList.doc(pid).set({
      'Name': name,
      'Price': price,
      'Stock_Count': stockCount,
      'Weight_Grams': weight
    });
  }

  Future getProducts() async {
    List itemsList = [];

    try {
      print("Getting products...");
      await productList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
      print(itemsList);
      return itemsList;
    } catch (e) {
      print("Error while getting products:");
      print(e.toString());
      return null;
    }
  }
}

Future updateProduct(
    String pid,
    String category,
    String description,
    int id,
    String images,
    bool isPopular,
    num price,
    num rating,
    int stock,
    int timesold,
    String title) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('products_new');
  return await productList.doc(pid).update({
    'category': category,
    'description': description,
    'id': id,
    'images': images,
    'isPopular': isPopular,
    'price': price,
    'stock': stock,
    'timesold': timesold,
    'title': title
  });
}

Future createTransaction(
    String pid, String transactionid, num totalprice) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('transactions');
  return await productList.doc(transactionid).set({
    'user': pid,
    'totalprice': totalprice,
    'date': FieldValue.serverTimestamp(),
    'orderstatus': "placed",
  });
}

Future updateTransaction(String transactionid, String item) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('transactions');
  return await productList.doc(transactionid).update({
    'items': FieldValue.arrayUnion([item])
  });
}

Future updateTransaction2(
    String transactionid, String itemname, num price) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('transactions');
  return await productList
      .doc(transactionid)
      .update({'itemsandprice.$itemname': price});
}

Future addPathToInvoice(String transactionid, String invPath) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('transactions');
  return await productList.doc(transactionid).update({
    'invoicePath': invPath,
  });
}

Future addTransactiontoUser(String transactionid) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('Users');
  return await productList.doc(user!.uid).update({
    //'items': FieldValue.arrayUnion([item])
    'transactionid': FieldValue.arrayUnion([transactionid])
  });
}

Future addReview(String productname, String comment, int rating) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('productreviews');
  return await productList.add({
    //'items': FieldValue.arrayUnion([item])
    'productName': productname,
    'comment': comment,
    'rating': rating,
    'status': 'pending',
    'name': username + " " + usersurname,
    'userid': user!.uid
  });
}

Future<bool> checkifRefundExists(
    String productname, String transactionid) async {
  bool returnres = false;
  Query qqq = FirebaseFirestore.instance
      .collection('refunds')
      .where('productName', isEqualTo: productname);
  await qqq.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      if (result["transactionid"] == transactionid) {
        returnres = true;
      }
    });
  });
  return returnres;
}

Future requestRefund(String productname, String transactionid, int itemCount,
    num pricePaid) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('refunds');
  return await productList.add({
    //'items': FieldValue.arrayUnion([item])
    'productName': productname,
    'itemCount': itemCount,
    'pricePaid': pricePaid,
    'status': 'pending',
    'name': username + " " + usersurname,
    'userid': user!.uid,
    'transactionid': transactionid,
  });
}

Future<num> getcurrentStock(String productname) async {
  num stock = 0;
  Query qqq = FirebaseFirestore.instance
      .collection('products_new')
      .where('title', isEqualTo: productname);
  await qqq.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      stock = result['stock'];
    });
  });
  return stock;
}

Future updateProductStock(String productname, num newstock) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('products_new');
  return await productList.doc(productname).update({'stock': newstock});
}

Future approveRefund(String refundid) async {
  final CollectionReference refundList =
      FirebaseFirestore.instance.collection('refunds');
  return await refundList.doc(refundid).update({'status': "approved"});
}

Future addProduct(String description, String images, num price, int stock,
    String title, String category) async {
  Map<String, dynamic> demodata = {
    //'items': FieldValue.arrayUnion([item])
    'description': description,
    'images': images,
    'price': price,
    'stock': stock,
    'title': title,
    'category': category,
    'id': 5,
    'isPopular': false,
    'rating': 0,
    'timesold': 0,
  };

  final CollectionReference productList =
      FirebaseFirestore.instance.collection('products_new');

  return await productList.doc(title).set(demodata);
}

Future<bool> checkifReviewExists(String productname) async {
  bool returnres = false;
  Query qqq = FirebaseFirestore.instance
      .collection('productreviews')
      .where('productName', isEqualTo: productname);
  await qqq.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      if (result["userid"] == user!.uid) {
        returnres = true;
      }
    });
  });
  return returnres;
}

Future<List<ReviewModal>> loadPendingReviews() async {
  List<ReviewModal> reviewList = [];
  ReviewModal newreview = new ReviewModal(
      name: "asd", comment: "asd", rating: 5, itemName: "", reviewid: "");
  Query qqq = FirebaseFirestore.instance
      .collection('productreviews')
      .where('status', isEqualTo: 'pending');
  await qqq.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      newreview = new ReviewModal(
        itemName: result['productName'],
        name: result['name'],
        rating: result['rating'],
        comment: result['comment'],
        reviewid: result.id,
      );
      reviewList.add(newreview);
    });
  });
  return reviewList;
}

Future<num> getcurrentRating(String productname) async {
  num rating = 0;
  Query qqq = FirebaseFirestore.instance
      .collection('products_new')
      .where('title', isEqualTo: productname);
  await qqq.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      rating = result['rating'];
    });
  });
  return rating;
}

Future<int> gethowmanyRated(String productname) async {
  int kackererateedildi = 0;
  Query qqq = FirebaseFirestore.instance
      .collection('products_new')
      .where('title', isEqualTo: productname);
  await qqq.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      kackererateedildi = result['kackererateedildi'];
    });
  });
  return kackererateedildi;
}

Future updateRating2(String productname) async {
  num totalrating = 0;
  int kackere = 0;
  Query qqq = FirebaseFirestore.instance
      .collection('productreviews')
      .where('status', isEqualTo: "approved");
  await qqq.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      if (result['productName'] == productname) {
        totalrating = totalrating + result['rating'];
        kackere = kackere + 1;
      }
    });
  });
  if (kackere != 0) totalrating = totalrating / kackere;
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('products_new');
  return await productList.doc(productname).update({'rating': totalrating});
}

Future updateProductRating(
    String productname, num newrating, int kackererateedildi) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('products_new');
  return await productList
      .doc(productname)
      .update({'kackererateedildi': kackererateedildi});
}

Future approveReview(String reviewid) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('productreviews');
  return await productList.doc(reviewid).update({'status': "approved"});
}

Future setPrice(String productTitle, int newPrice) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('products_new');
  return await productList.doc(productTitle).update({'price': newPrice});
}

Future setPrice2(String productTitle, double newPrice) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('products_new');
  return await productList.doc(productTitle).update({'price': newPrice});
}

Future<Product> findProduct(String pname) async {
  Product producttoaddtocart = new Product(
    id: 1,
    images: "assets/images/ps4_console_white_1.png",
    title: "none",
    price: 65,
    description: "test123",
    rating: 4,
    category: "whey",
    isPopular: true,
  );

  Query qqq = FirebaseFirestore.instance
      .collection('products_new')
      .where('title', isEqualTo: pname);
  await qqq.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      producttoaddtocart.id = result['id'];
      producttoaddtocart.images = result['images'];
      producttoaddtocart.title = result['title'];
      producttoaddtocart.price = result['price'];
      producttoaddtocart.description = result['description'];
      producttoaddtocart.rating = result['rating'];
      producttoaddtocart.isPopular = result['isPopular'];
      producttoaddtocart.category = result['category'];
      producttoaddtocart.numsold = result['numsold'];
      producttoaddtocart.stock = result['stock'];
      print("resultasdjaskdasd");
    });

    print(producttoaddtocart.title);
  });
  return producttoaddtocart;
}

Future addToCartDB(String itemname, int itemcount) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('Users');
  return await productList
      .doc(user!.uid)
      .update({'userCart.$itemname': itemcount});
}

Future removeFromCartDB(String itemname) async {
  final CollectionReference productList =
  FirebaseFirestore.instance.collection('Users');
  return await productList
      .doc(user!.uid)
      .update({'userCart.$itemname': 0});
}

Future removeallFromCartDB() async {
  final CollectionReference productList =
  FirebaseFirestore.instance.collection('Users');
  return await productList
      .doc(user!.uid)
      .update({'userCart': FieldValue.delete()});
}

