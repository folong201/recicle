import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductService {
  final String? uid;
  ProductService({this.uid});

  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  Stream<QuerySnapshot> getProducts() {
    return products.snapshots();
  }

  Future getProductsByUser(uidd) {
    return products.where('uid', isEqualTo: uidd).get()
    .then((value) {
      List<dynamic> products = [];
      value.docs.forEach((element) {
        products.add(element);
      });
      return products;
    });
  }

  Future<DocumentReference> addProduct(
    productName,
    productPrice,
    productDescription,
    productCategory,
    productSubcategory,
    productImages,
  ) async {
    await getProducts().first.then((value) {
      print("recuperation des produits");
      print(value.docs.length);
      print(value.docs.first.id);
    });
    return products.add({
      'name': productName,
      'description': productDescription,
      'imageUrl': productImages,
      'uid': uid ?? FirebaseAuth.instance.currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'productPrice': productPrice,
      'productCategory': productCategory,
      'productSubcategory': productSubcategory,
    });
  }

  Future<void> updateProduct(
      String id, String name, String description, String imageUrl) async {
    return products.doc(id).update({
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProduct(String id) async {
    return products.doc(id).delete();
  }
}
