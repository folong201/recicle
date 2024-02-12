import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recicle/services/ProductService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io'; // Import this to use File & other IO classes
import 'package:path/path.dart' as path;

class CreateProductDialog extends StatefulWidget {
  bool? toUpdate;
  dynamic product;
  CreateProductDialog({this.toUpdate, this.product});
  @override
  State<CreateProductDialog> createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  String productName = '';
  double productPrice = 0.0;
  String productDescription = '';
  String productCategory = '';
  String productSubcategory = '';
  List<String> productImages = [];
  List<dynamic> products = [];
  Map<String, dynamic> productGalleries = {};
  final storage = FirebaseStorage.instance;
  bool isLoading = false;
  var filepath;
  double progress = 0;
  Future _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Upload the image to a server or storage
      // Here is an example using Firebase Storage
      final File imageFile = File(pickedImage.path);
      setState(() {
        filepath = imageFile;
      });
    } else {
      setState(() {
        filepath = null;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  initializer() async {
    if (widget.toUpdate == true) {
      fusionnecat(widget.product['category'], widget.product['subcategory']);

      setState(() {
        productName = widget.product['name'];
        productPrice = widget.product['price'];
        productDescription = widget.product['description'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AlertDialog(
            title: Text('Create New Product'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                    ),
                    onChanged: (value) {
                      productName = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Product Price',
                    ),
                    onChanged: (value) {
                      productPrice = double.parse(value);
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Product Description',
                    ),
                    onChanged: (value) {
                      productDescription = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Product Category',
                    ),
                    onChanged: (value) {
                      productCategory = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Product Subcategory',
                    ),
                    onChanged: (value) {
                      productSubcategory = value;
                    },
                  ),
                  ElevatedButton(
                    child: Text('Add Image'),
                    onPressed: _selectImage,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Create'),
                onPressed: saveProduct,
              ),
            ],
          );
  }

  setCategory(String chaine) {
    //code pour set les category en separant par des virgules
    return chaine.split(",");
  }

  saveProduct() async {
    setState(() {
      isLoading = true;
    });
    print("product creation");
    if (productName.isEmpty ||
        productPrice == 0.0 ||
        productDescription.isEmpty ||
        productCategory.isEmpty ||
        productSubcategory.isEmpty) {
      setState(() {
        isLoading = false;
      });
    } else {
      if (widget.toUpdate==true ) {
        _updateProduct();
      } else {
        ProductService(uid: FirebaseAuth.instance.currentUser?.uid!)
            .addProduct(
          productName,
          productPrice,
          productDescription,
          setCategory(productCategory),
          setCategory(productSubcategory),
          'assets/images/photolcd.webp',
        )
            .then((value) {
          print("produit creer avec succes");
          print(value.id);
          if (filepath != null) {
            print("uploading de l'image");
            uploadImage(value.id);
            Navigator.of(context).pop();
          } else {
            print("fichier a uploader null");
            Navigator.of(context).pop();
          }
          setState(() {
            isLoading = false;
          });
        });
      }
    }
  }

  Future<void> uploadImage(productId) async {
    try {
      DateTime now = DateTime.now();
      final String fileName = now.millisecondsSinceEpoch.toString();
      if (await filepath.exists()) {
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('${productId}/$fileName');
        final UploadTask uploadTask = storageRef.putFile(filepath);

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          if (mounted) {
            setState(() {
              progress = snapshot.bytesTransferred / snapshot.totalBytes;
            });
          }
        });

        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        final String downloadURL = await taskSnapshot.ref.getDownloadURL();
      } else {
        print('File does not exist');
      }
    } catch (e) {
      if (e is firebase_core.FirebaseException &&
          e.code == 'app-check-token-error') {
        // Handle App Check error
        print('App Check blocked the request: $e');
      } else {
        // Handle other errors
        print('An error occurred: $e');
      }
    }
  }

  Future<void> _updateProduct() async {
    setState(() {
      isLoading = true;
    });
    ProductService(uid: FirebaseAuth.instance.currentUser?.uid!)
        .updateProduct(
      widget.product['id'],
      productName,
      productDescription,
      'assets/images/photolcd.webp',
      productPrice.toString(),
      setCategory(productCategory),
      setCategory(productSubcategory),
    )
        .then((value) {
      print("produit Mis A Jour avec succes");
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    });
  }

  Future<void> _showCreateProductDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateProductDialog();
      },
    );
  }

  fusionnecat(cat, subcat) {
    //code pour fusionner les category et les subcategory
    String cater = '';
    String subcater = '';
    for (var i = 0; i < cat.length; i++) {
      cater = cater + cat[i];
    }
    setState(() {
      productCategory = cater;
    });
    for (var i = 0; i < subcat.length; i++) {
      subcater = subcater + subcat[i];
    }
    setState(() {
      productSubcategory = subcater;
    });
  }
}
