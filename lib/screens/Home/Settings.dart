import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:recicle/screens/products/CreateProductDialog.dart';
import 'package:recicle/services/ProductService.dart';
import 'dart:io'; // Import this to use File & other IO classes
import 'package:path/path.dart' as path;

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> products = [];
  Map<String, dynamic> productGalleries = {};
  final storage = FirebaseStorage.instance;

  createnewProduct() {
    setState(() {
      products.add("new product");
    });
  }

  Future<String> getImage(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();
      return url;
    } catch (error) {
      print('Error getting image URL: $error');
      // Handle error gracefully (e.g., display a placeholder image)
      return 'https://example.com/placeholder.png'; // Or handle differently
    }
  }

  getAllimagesOfProduct(productId) async {
    //code pour recuperer les images de chaque produit en fonction de l'id du produit
    final galery = await storage.ref().child(productId).listAll();
    // print("nombre de dossier existant ${galery.items.length}");
    var all = [];
    //afficher les liens d'access de ces images
    galery.items.forEach((element) {
      all.add(element.fullPath);
    });

    return all;
  }

  _showCreateProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateProductDialog();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserProduct();
  }

  getuserProduct() async {
    print("Recuperer les produits de l'utilisateur");
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    ProductService().getProductsByUser(uid).then((value) async {
      Map<String, dynamic> galleries = {};
      for (var i = 0; i < value.length; i++) {
        galleries[value[i].id] = await getAllimagesOfProduct(value[i].id);
      }
      setState(() {
        products = value;
        productGalleries = galleries; // And this line
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          int fisrtindex = index;
          return Column(children: [
            Container(
              height: 200,
              child: Swiper(
                itemCount: productGalleries[products[index].id].length,
                itemBuilder: (context, index) {
                  final imagePath = productGalleries[products[index].id][index];
                  return FutureBuilder<String>(
                    future: getImage(imagePath),
                    builder: (context, snapshot) {
                      Widget image;
                      if (snapshot.hasData) {
                        final imageUrl = snapshot.data!;
                        image = Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        );
                      } else if (snapshot.hasError) {
                        print('Error loading image: ${snapshot.error}');
                        // Handle error gracefully (e.g., display a placeholder)
                        image = Image.asset('assets/placeholder.png');
                      } else {
                        image = Center(child: CircularProgressIndicator());
                      }

                      return Stack(
                        children: [
                          Container(
                            height: 200,
                            child: image,
                          ),
                          Positioned(
                            top: 02,
                            right: 30,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // TODO: Implement delete functionality
                                print("Suprimer l'image de la galerie");
                                if (productGalleries[products[index].id] !=
                                        null &&
                                    productGalleries[products[index].id]
                                            [index] !=
                                        null) {
                                  deleteOneImage(
                                      productGalleries[products[index].id]
                                          [index]);
                                } else {
                                  print(
                                      'Cannot delete image because it does not exist');
                                }
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 02,
                            right: 30,
                            child: Text(
                              productGalleries[products[index].id]
                                      .length
                                      .toString() +
                                  " images",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                pagination: SwiperPagination(),
              ),
            ),
            ListTile(
              title: Text(products[index]['name'].toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      print("Ajouter une image a la galerie");
                      print(products[index].id);
                      _selectImage(products[fisrtindex].id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Implement edit functionality
                      print("Modifier le produit");
                      CreateProductDialog(
                          toUpdate: true, product: products[fisrtindex]);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      deleteProduct(products[index].id);
                    },
                  ),
                ],
              ),
              subtitle: Text(
                  products[index]['description'].toString() ?? "descripton"),
            ),
          ]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showCreateProductDialog();
        },
      ),
    );
  }

  Future<void> _selectImage(productid) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Upload the image to a server or storage
      // Here is an example using Firebase Storage
      final File imageFile = File(pickedImage.path);
      final String fileName = path.basename(imageFile.path);
      if (await imageFile.exists()) {
        // Continue with upload
        print('File name: $fileName');
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('$productid/$fileName');
        final UploadTask uploadTask = storageRef.putFile(imageFile);

        // Monitor the upload progress
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          print(
              'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
        });

        // Get the download URL after the upload is complete
        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        // final String downloadURL = await taskSnapshot.ref.getDownloadURL();
        print("Uploading terminer");
        getuserProduct();
      } else {
        print('File does not exist');
      }
    }
  }

  deleteProduct(productId) async {
    // Delete the product document from Firestore
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();
  }

  deleteProductImages(productId) async {
    // Get the list of images for the product
    ListResult result = await FirebaseStorage.instance.ref(productId).listAll();
    for (var item in result.items) {
      await item.delete();
    }
  }

  Future<void> deleteOneImage(String path) async {
    final Reference storageRef = FirebaseStorage.instance.ref(path);
    try {
      await storageRef.delete();
      print('Successfully deleted $path');
      getuserProduct();
    } catch (e) {
      print('Failed to delete $path: $e');
    }
  }
}
