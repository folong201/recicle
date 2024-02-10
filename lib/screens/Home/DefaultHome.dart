import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recicle/widgets/Items/ItemAsGrid.dart';
import 'package:recicle/widgets/Items/ItemsAsList.dart';

class Item {
  final String name;
  final String image;
  final String uid;
  final String description;
  final String category;
  dynamic isBookmarked;

  Item({
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.uid,
    this.isBookmarked = false,
  });
}

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
                      // Handle search text change
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String searchText = _searchController.text;
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
            child: isGrid ? ItemAsGrid(items: items) : ItemAsList(items: items),
          ),
        ],
      ),
    );
  }

  getAllItemFromFirebase() async {
    QuerySnapshot snapshot = await getProducts().first;
    List<Item> fetchedItems = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print(data['name']);
      return Item(
        name: data['name'] ?? '',
        image: data['image'] ?? '',
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        uid: data['uid'] ?? '',
        isBookmarked: false,
      );
    }).toList();

    if (mounted) {
      setState(() {
        items = fetchedItems;
      });
    }
  }
}
