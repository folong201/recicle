import 'package:cached_network_image/cached_network_image.dart';
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

  bool isLoading = true; // Added to track loading state

  Future<String> getImage(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();
      return url;
    } catch (error) {
      // print('Error getting image URL: $error');
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CreateProductDialog();
      },
    ).then((_) {
      // Add a then callback to refresh the UI when the dialog is closed
      getuserProduct();
    });
  }

  @override
  void initState() {
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
        isLoading = false; // Set loading state to false when data is loaded
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Dashboard'),
      // ),
      body: isLoading // Show loading indicator if data is loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                int fisrtindex = index;
                return Column(children: [
                  SizedBox(
                    height: 200,
                    child: Swiper(
                      itemCount: productGalleries[products[index].id].length,
                      itemBuilder: (context, index) {
                        final imagePath =
                            productGalleries[products[index].id][index];
                        return FutureBuilder<String>(
                          future: getImage(imagePath),
                          builder: (context, snapshot) {
                            Widget image;
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              image =
                                  const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              // print('Error loading image: ${snapshot.error}');
                              // Handle error gracefully (e.g., display a placeholder)
                              image = Image.asset('assets/placeholder.png');
                            } else {
                              final imageUrl = snapshot.data!;
                              // image = Image.network(
                              //   imageUrl,
                              //   fit: BoxFit.cover,
                              //   width: double.infinity,
                              //   height: double.infinity,
                              // );

                              image = CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                imageUrl: imageUrl,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              );
                            }
                            return Stack(
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: image,
                                ),
                                Positioned(
                                  top: 02,
                                  right: 30,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      // print("Suprimer l'image de la galerie");
                                      if (productGalleries[
                                                  products[index].id] !=
                                              null &&
                                          productGalleries[products[index].id]
                                                  [index] !=
                                              null) {
                                        await deleteOneImage(productGalleries[
                                                products[index].id][index])
                                            .then((_) {
                                          getuserProduct();
                                        });
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
                                    "${productGalleries[products[index].id]
                                            .length} images",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      pagination: const SwiperPagination(),
                    ),
                  ),
                  ListTile(
                    title: Text(products[index]['name'].toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            // print("Ajouter une image a la galerie");
                            // print(products[index].id);
                            setState(() {
                              isLoading = true;
                            });
                            _selectImage(products[fisrtindex].id);
                            setState(() {
                              isLoading = false;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // print("Modifier le produit");
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CreateProductDialog(
                                    toUpdate: true,
                                    product: products[fisrtindex]);
                              },
                            ).then((_) {
                              // print(
                              //     "recuperation de tout les article de l'utilisateur");

                              getuserProduct();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            deleteProduct(products[index].id);
                            setState(() {
                              isLoading = false;
                            });
                          },
                        ),
                      ],
                    ),
                    subtitle: Text(products[index]['description'].toString() ??
                        "descripton"),
                  ),
                ]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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
        // print('File name: $fileName');
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('$productid/$fileName');
        final UploadTask uploadTask = storageRef.putFile(imageFile);

        // Monitor the upload progress
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          // print(
          //     'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
        });

        // Get the download URL after the upload is complete
        // final String downloadURL = await taskSnapshot.ref.getDownloadURL();
        // print("Uploading terminer");
        getuserProduct();
      } else {
        // print('File does not exist');
      }
    }
  }

  deleteProduct(productId) async {
    // Delete the product document from Firestore
    // print("supression du produit");
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();

    await deleteProductImages(productId);
  }

  deleteProductImages(productId) async {
    // Get the list of images for the product
    // print("supression des images du produit du produit");

    ListResult result = await FirebaseStorage.instance.ref(productId).listAll();
    for (var item in result.items) {
      await item.delete();
    }
    getuserProduct();
  }

  Future<void> deleteOneImage(String path) async {
    final Reference storageRef = FirebaseStorage.instance.ref(path);
    try {
      await storageRef.delete();
      // print('Successfully deleted $path');
      getuserProduct();
    } catch (e) {
      // print('Failed to delete $path: $e');
    }
  }
}
