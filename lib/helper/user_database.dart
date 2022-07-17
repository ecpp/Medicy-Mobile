import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createUsertoDB(
    String name, String surname, String email, String uid) async {
  CollectionReference userList = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  return await userList.doc(uid).set(
      {'Name': name, 'Surname': surname, 'Email': email, 'type': 'customer'});
}

Future updateUser(String name, String surname, String username, String email,
    String uid) async {
  CollectionReference userList = FirebaseFirestore.instance.collection('Users');
  return await userList
      .doc(uid)
      .update({'Name': name, 'Surname': surname, 'Email': email});
}

Future getUserData() async {
  var collection = FirebaseFirestore.instance.collection('Users');
  var querySnapshot = await collection.get();
  for (var queryDocumentSnapshot in querySnapshot.docs) {
    Map<String, dynamic> data = queryDocumentSnapshot.data();
    String name = data['name'];
    String surname = data['surname'];
  }
}
