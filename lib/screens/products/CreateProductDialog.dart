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
  String operation = "Create Article";
  Map<String, dynamic> productGalleries = {};
  final storage = FirebaseStorage.instance;
  bool isLoading = false;
  var filepath;
  double progress = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productCategoryController = TextEditingController();
  TextEditingController productSubcategoryController = TextEditingController();

  Future _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
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
    // super.initState();
    // print("id du prosuit : ${widget.product.id}");
    initializer();
  }

  initializer() {
    if (widget.toUpdate != null && widget.toUpdate != false) {
      fusionnecat(widget.product['productCategory'],
          widget.product['productSubcategory']);
      print("mis a jour des controllers");

      setState(() {
        operation = "Update Article";
        productNameController.text = widget.product['name'];
        productPriceController.text = widget.product['productPrice'].toString();
        productDescriptionController.text = widget.product['description'];
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
            scrollable: true,
            title: Text(operation),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: productNameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: productPriceController,
                      decoration: InputDecoration(
                        labelText: 'Product Price',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a product price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: productDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Product Description',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a product description';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: productCategoryController,
                      decoration: InputDecoration(
                        labelText: 'Product Category',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a product category';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: productSubcategoryController,
                      decoration: InputDecoration(
                        labelText: 'Product Subcategory',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a product subcategory';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      child: Text('Add Image'),
                      onPressed: _selectImage,
                    ),
                  ],
                ),
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
                child: Text('Save'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.toUpdate != null && widget.toUpdate == true) {
                      _updateProduct();
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      await saveProduct();
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
              ),
            ],
          );
  }

  setCategory(String chaine) {
    //code pour set les category en separant par des virgules
    return chaine.split(",");
  }

  saveProduct() async {
    print("product creation");
    if (!_formKey.currentState!.validate()) {
      print("probleme de validation");
      setState(() {
        isLoading = false;
      });
    } else {
      print("creation du produit");
      setState(() {
        isLoading = true;
      });
      await ProductService(uid: FirebaseAuth.instance.currentUser?.uid!)
          .addProduct(
        productNameController.text,
        productPriceController.text,
        productDescriptionController.text,
        setCategory(productCategoryController.text),
        setCategory(productSubcategoryController.text),
        'assets/images/photolcd.webp',
      )
          .then((value) {
        print("produit creer avec succes");
        print(value.id);
        if (filepath != null) {
          print("uploading de l'image");
          uploadImage(value.id);
        } else {
          print("fichier a uploader null");
        }
        Navigator.of(context).pop();
      });
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
      widget.product.id,
      productNameController.text, // Nouveau nom du produit
      productDescriptionController.text, // Nouvelle description du produit
      'assets/images/photolcd.webp', // Nouvelle image du produit
      productPriceController.text, // Nouveau prix du produit
      setCategory(
          productCategoryController.text), // Nouvelle catégorie du produit
      setCategory(productSubcategoryController
          .text), // Nouvelle sous-catégorie du produit
    )
        .then((value) {
      print("Produit mis à jour avec succès");
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
