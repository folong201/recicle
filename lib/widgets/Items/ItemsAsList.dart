import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:recicle/screens/Home/DefaultHome.dart';
import 'package:recicle/screens/ProductDetails.dart';

class ItemAsList extends StatefulWidget {
  final List<dynamic> items;

  Map<String, dynamic> productGalleries;
  ItemAsList({required this.items, required this.productGalleries});

  @override
  State<ItemAsList> createState() => _ItemAsListState();
}

class _ItemAsListState extends State<ItemAsList> {
  final storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return FutureBuilder<String>(
            // future: getImage(
            //     widget.productGalleries[widget.items[index].id]?.first ?? ''),
            future:
                widget.productGalleries[widget.items[index].id]?.isNotEmpty ==
                        true
                    ? getImage(
                        widget.productGalleries[widget.items[index].id]!.first)
                    : Future.value(''),
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
                image = Image.asset('assets/images/photolcd.webp');
              } else {
                image = Center(child: CircularProgressIndicator());
              }

              return GestureDetector(
                child: ListTile(
                  leading: Container(
                    width: 50.0, // Adjust width as needed
                    child: image,
                  ),
                  title: Text(widget.items[index]['name'] + index.toString()),
                  // subtitle: Text(
                  //     (widget.items[index]['description'] ?? "descrip") +
                  //             productGalleries[widget.items[index].id]
                  //                 ?.first
                  //                 .toString() ??
                  //         'img'),
                ),
                onTap: () {
                  productDatails(context, widget.items[index]);
                },
              );
            });
      },
    );
  }

  productDatails(context, product) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ProductDetails(product: product);
      },
    ));
  }

  Future<String> getImage(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();
      return url;
    } catch (error) {
      print('Error getting image URL: $error');
      // Handle error gracefully (e.g., display a placeholder image)
      return 'https://placehold.jp/150x150.png'; // Or handle differently
    }
  }
}
