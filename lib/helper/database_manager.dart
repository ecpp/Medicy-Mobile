import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/models/reviewModal.dart';
import 'package:shop_app/screens/sign_in/components/login_firebase.dart';

import '../main.dart';
import '../models/categoryModel.dart';
import '../screens/home/components/body.dart';

class DatabaseManager {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection(dbProductsTable);
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
      FirebaseFirestore.instance.collection(dbProductsTable);
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
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
  return await users.doc(user!.uid).update({
    //'items': FieldValue.arrayUnion([item])
    'transactionid': FieldValue.arrayUnion([transactionid])
  });
}

Future addReportToUser(String reportLink, String userID) async {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
  return await users.doc(userID).update({
    'reports': FieldValue.arrayUnion([reportLink])
  });
}

Future addReportToDB(String reportID, String reportLink, String userID) async {
  final CollectionReference reports =
      FirebaseFirestore.instance.collection('Reports');
  return await reports.doc(reportID).set({
    'forUser': userID,
    'date': FieldValue.serverTimestamp(),
    'reportLink': reportLink,
    'createdBy': user!.uid,
  });
}

Future<String> findUseridByEmail(String email) async {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
  String uid = 'null';
  await users.get().then((querySnapshot) {
    querySnapshot.docs.forEach((element) {
      if (element['Email'] == email) {
        uid = element.id;
      }
    });
  });
  return uid;
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
    'name': userFirstName! + " " + userSurname!,
    'userid': user!.uid
  });
}

Future<bool> checkifRefundExists(
    String productname, String transactionid) async {
  bool returnres = false;
  Query firebase_query = FirebaseFirestore.instance
      .collection('refunds')
      .where('productName', isEqualTo: productname);
  await firebase_query.get().then((querySnapshot) {
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
    'name': userFirstName! + " " + userSurname!,
    'userid': user!.uid,
    'transactionid': transactionid,
  });
}

Future<num> getcurrentStock(String productname) async {
  num stock = 0;
  Query firebase_query = FirebaseFirestore.instance
      .collection(dbProductsTable)
      .where('title', isEqualTo: productname);
  await firebase_query.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      stock = result['stock'];
    });
  });
  return stock;
}

Future updateProductStock(String productname, num newstock) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection(dbProductsTable);
  return await productList.doc(productname).update({'stock': newstock});
}

Future approveRefund(String refundid) async {
  final CollectionReference refundList =
      FirebaseFirestore.instance.collection('refunds');
  return await refundList.doc(refundid).update({'status': "approved"});
}

Future removeProduct(String productname) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection(dbProductsTable);
  return await productList.doc(productname).delete();
}

Future addProduct(String description, String images, num price, int stock,
    String title, String category) async {
  Map<String, dynamic> demodata = {
    //'items': FieldValue.arrayUnion([item])
    'description': description,
    'images': images,
    'price': price,
    'oldprice': 0,
    'stock': stock,
    'title': title,
    'category': category,
    'id': 5,
    'isPopular': false,
    'rating': 0,
    'timesold': 0,
  };

  final CollectionReference productList =
      FirebaseFirestore.instance.collection(dbProductsTable);

  return await productList.doc(title).set(demodata);
}

Future<bool> checkifReviewExists(String productname) async {
  bool returnres = false;
  Query firebase_query = FirebaseFirestore.instance
      .collection('productreviews')
      .where('productName', isEqualTo: productname);
  await firebase_query.get().then((querySnapshot) {
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
  Query firebase_query = FirebaseFirestore.instance
      .collection('productreviews')
      .where('status', isEqualTo: 'pending');
  await firebase_query.get().then((querySnapshot) {
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
  Query firebase_query = FirebaseFirestore.instance
      .collection(dbProductsTable)
      .where('title', isEqualTo: productname);
  await firebase_query.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      rating = result['rating'];
    });
  });
  return rating;
}

Future<int> gethowmanyRated(String productname) async {
  int kackererateedildi = 0;
  Query firebase_query = FirebaseFirestore.instance
      .collection(dbProductsTable)
      .where('title', isEqualTo: productname);
  await firebase_query.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      kackererateedildi = result['kackererateedildi'];
    });
  });
  return kackererateedildi;
}

Future updateRating2(String productname) async {
  num totalrating = 0;
  int kackere = 0;
  Query firebase_query = FirebaseFirestore.instance
      .collection('productreviews')
      .where('status', isEqualTo: "approved");
  await firebase_query.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      if (result['productName'] == productname) {
        totalrating = totalrating + result['rating'];
        kackere = kackere + 1;
      }
    });
  });
  if (kackere != 0) totalrating = totalrating / kackere;
  final CollectionReference productList =
      FirebaseFirestore.instance.collection(dbProductsTable);
  return await productList.doc(productname).update({'rating': totalrating});
}

Future updateProductRating(
    String productname, num newrating, int kackererateedildi) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection(dbProductsTable);
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
      FirebaseFirestore.instance.collection(dbProductsTable);
  return await productList.doc(productTitle).update({'price': newPrice});
}

Future setPrice2(String productTitle, num newPrice, num oldPrice) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection(dbProductsTable);
  return await productList
      .doc(productTitle)
      .update({'price': newPrice, 'oldprice': oldPrice});
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
  return await productList.doc(user!.uid).update({'userCart.$itemname': 0});
}

Future removeallFromCartDB() async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('Users');
  return await productList
      .doc(user!.uid)
      .update({'userCart': FieldValue.delete()});
}

Future removeCategory(String name) async {
  await FirebaseFirestore.instance
      .collection(dbCategoriesTable)
      .where("name", isEqualTo: name)
      .get()
      .then((snapshot) => {
            for (DocumentSnapshot ds in snapshot.docs) {ds.reference.delete()}
          });
}

Future addCategory(String name, String imagelink) async {
  String docID = FirebaseFirestore.instance.collection("categories").doc().id;
  String addedBy = user!.uid;
  String addedDate = DateTime.now().toString();
  FirebaseFirestore.instance.collection(dbCategoriesTable).doc(docID).set({
    "id": docID,
    "name": name,
    "image": imagelink,
    "addedBy": addedBy,
    "addedDate": addedDate
  });
}

Future<List<categoryModel>> getCategories() async {
  List<categoryModel> categories = [];

  Query query = FirebaseFirestore.instance.collection(dbCategoriesTable);

  await query.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      categoryModel category = new categoryModel(
        name: result['name'],
        id: result['id'],
        image: result['image'],
      );
      categories.add(category);
    });
  });
  return categories;
}

Future<List<Product>> getAllItems() async {
  List<Product> productList = [];

  Query query = FirebaseFirestore.instance.collection(dbProductsTable);

  await query.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      Product newproduct = new Product(
          id: result['id'],
          images: result['images'],
          title: result['title'],
          price: result['price'],
          oldprice: result['oldprice'],
          description: result['description'],
          rating: result['rating'],
          isPopular: result['isPopular'],
          category: result['category'],
          numsold: result['timesold'],
          stock: result['stock']);
      productList.add(newproduct);
    });
  });
  return productList;
}

Future setStock(String productTitle, int newStock) async {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection('products_new');
  return await productList.doc(productTitle).update({'stock': newStock});
}

Future<String> getUserType() async {
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(user!.uid)
      .get()
      .then((value) {
    String _userType = value.data()!['type'];
    return _userType;
  });
  return 'customer';
}

Future<Product> getProductFromName(String productName) async {
  Product product = new Product(
      id: 0,
      images: '',
      title: '',
      price: 0,
      oldprice: 0,
      description: '',
      rating: 0,
      isPopular: false,
      category: '',
      numsold: 0,
      stock: 0);
  await FirebaseFirestore.instance
      .collection('products_new')
      .where('title', isEqualTo: productName)
      .get()
      .then((value) {
    value.docs.forEach((result) {
      product = new Product(
          id: result['id'],
          images: result['images'],
          title: result['title'],
          price: result['price'],
          oldprice: result['oldprice'],
          description: result['description'],
          rating: result['rating'],
          isPopular: result['isPopular'],
          category: result['category'],
          numsold: result['timesold'],
          stock: result['stock']);
    });
  });
  return product;
}

Future<bool> checkPrice(String itemname, num price) async {
  bool isPrice = false;
  FirebaseFirestore.instance
      .collection('products_new')
      .where('title', isEqualTo: itemname)
      .get()
      .then((value) {
    value.docs.forEach((result) {
      if (result['price'] == price) {
        isPrice = true;
      }
    });
  });
  return isPrice;
}

Future<bool> checkPriceCart(Cart userCart) async {
  for (int i = 0; i < currentCart.cartItems!.length; i++) {
    String itemName = currentCart.cartItems![i].product.title;
    num itemPrice = currentCart.cartItems![i].product.price;
    if (!await checkPrice(itemName, itemPrice)) {
      return false;
    }
  }
  return true;
}

Future<bool> stockCheck(String itemName) async {
  bool isStock = false;
  await FirebaseFirestore.instance
      .collection('products_new')
      .where('title', isEqualTo: itemName)
      .get()
      .then((value) {
    value.docs.forEach((result) {
      print(result['stock']);
      if (result['stock'] > 0) {
        isStock = true;
      }
    });
  });
  return isStock;
}

// Future<void> increasePendingStock(Cart userCart) async {
//
//
// }
//
// Future<void> decreasePendingStock(List<Product> productList) async {
//   for (int i = 0; i < productList.length; i++) {
//     await FirebaseFirestore.instance
//         .collection('products_new')
//         .doc(productList[i].title)
//         .update({'pendingStock': FieldValue.increment(-1)});
//   }
// }

Future fetchAllUserDataOnLogin(bool autoLogin) async {
  print('***** FETCHING ALL USER DATA *****');
  await FirebaseFirestore.instance
      .collection(dbUserTable)
      .doc(user!.uid)
      .get()
      .then((dataFromDB) {
    userFirstName = dataFromDB.data()!["Name"];
    userSurname = dataFromDB.data()!["Surname"];
    userType = dataFromDB.data()!["type"];
    userCart = dataFromDB.data()!["userCart"];
  });
  if (user != null) {
    try {
      if (!autoLogin && currentCart.sum != 0) {
        //FETCH LOCAL CART TO DB.
        await addToCartDB(currentCart.cartItems!.elementAt(0).product.title,
            currentCart.cartItems!.elementAt(0).numOfItem);
        currentCart.cartItems!.clear();
      }
      //CLEAR LOCAL CART
    } catch (e) {
      print('*************ERROR IN FETCHING CART FROM LOCAL DB*************');
      print(e);
    }
    // if (autoLogin){
    //     productListnew = await getAllItems();
    // }
    if (userCart != null) {
      int i = 0;
      for (var v in userCart!.values) {
        if (userCart!.values.elementAt(i) > 0) {
          //FETCH DB TO LOCAL CART
          // Product itemToAdd = productListnew
          //     .where((element) => element.title
          //     .contains(userCart!.keys.elementAt(i).trimLeft()))
          //     .toList()[0];
          Product itemToAdd =
              await getProductFromName(userCart!.keys.elementAt(i).trimLeft());
          if (await stockCheck(itemToAdd.title)) {
            currentCart.cartItems!.add(CartItem(
                product: itemToAdd, numOfItem: userCart!.values.elementAt(i)));
          }
        }
        i++;
      }
    }
  }
}
