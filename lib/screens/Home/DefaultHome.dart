import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recicle/services/ProductService.dart';
import 'package:recicle/widgets/Items/ItemAsGrid.dart';
import 'package:recicle/widgets/Items/ItemsAsList.dart';

class DefaultHome extends StatefulWidget {
  const DefaultHome({Key? key}) : super(key: key);

  @override
  State<DefaultHome> createState() => _DefaultHomeState();
}

class _DefaultHomeState extends State<DefaultHome> {
  List<dynamic> items = [];
  bool isGrid = false;

  late TextEditingController _searchController = TextEditingController();

  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  final storage = FirebaseStorage.instance;
  Map<String, dynamic> productGalleries = {};
  setAllProductImages() async {
    print("recuperation des image des produits");

    Map<String, dynamic> cc = {};
    print("nombre de produits ${items.length}");
    for (var i = 0; i < items.length; i++) {
      var images = await getAllimagesOfProduct(items[i].id);
      // print("nombre d'images ${images.length}");
      cc[items[i].id] = images;
    }
    print("fin de recuperation des images de toute la galery des produits");
    print("Taille ${cc.length}");
    setState(() {
      productGalleries = cc;
    });
  }

  getAllimagesOfProduct(productId) async {
    try {
      final galery = await storage.ref().child(productId).listAll();
      var all = [];
      galery.items.forEach((element) {
        all.add(element.fullPath);
      });
      print('Found ${all.length} images in folder $productId');
      if (all.length == 0) {
        final defaultGalery = await storage.ref().child('default').listAll();
        var all = [];
        defaultGalery.items.forEach((element) {
          all.add(element.fullPath);
        });
        print('Found ${all.length} images in default folder.');
        return all;
      } else {
        return all;
      }
    } catch (error) {
      print('Error getting images of product: $error');
      // Handle error gracefully (e.g., display a placeholder image)
      if (error is FirebaseException && error.code == 'object-not-found') {
        print('Folder $productId not found, using default folder.');
        final defaultGalery = await storage.ref().child('default').listAll();
        var all = [];
        defaultGalery.items.forEach((element) {
          all.add(element.fullPath);
        });
        print('Found ${all.length} images in default folder.');
        return all;
      } else {
        // Handle other errors
        print('Unexpected error occurred: $error');
        throw error; // Rethrow the error for further handling if necessary
      }
    }
  }

  Stream<QuerySnapshot> getProducts() {
    return products.snapshots();
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    getAllItemFromFirebase();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      // prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        getAllItemFromFirebase();
                      } else {
                        searchProductByName(value);
                      }
                      // Handle search text change
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String searchText = _searchController.text;
                    searchProductByName(searchText);
                    //     // Perform search
                  },
                ),
                IconButton(
                  icon: Icon(
                    isGrid ? Icons.view_list : Icons.grid_view,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      isGrid = !isGrid;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            // child: ItemAsGrid(items: items),
            child: isGrid
                ? ItemAsGrid(items: items, productGalleries: productGalleries)
                : ItemAsList(items: items, productGalleries: productGalleries),
          ),
        ],
      ),
    );
  }

  getAllItemFromFirebase() async {
    QuerySnapshot snapshot = await getProducts().first;
    List<dynamic> fetchedItems = snapshot.docs;
    if (mounted) {
      setState(() {
        items = fetchedItems;
      });
    }
    await setAllProductImages();
  }

  searchProductByName(String name) async {
    QuerySnapshot snapshot = await ProductService().findProductByName(name);
    List<dynamic> fetchedItems = snapshot.docs;
    if (mounted) {
      setState(() {
        items = fetchedItems;
      });
    }
    await setAllProductImages();
  }
}
