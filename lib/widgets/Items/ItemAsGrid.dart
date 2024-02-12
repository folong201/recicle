import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:recicle/screens/Home/DefaultHome.dart';
import 'package:recicle/screens/ProductDetails.dart';

class ItemAsGrid extends StatefulWidget {
  final List<dynamic> items;
  Map<String, dynamic> productGalleries;
  ItemAsGrid({required this.items, required this.productGalleries});

  @override
  State<ItemAsGrid> createState() => _ItemAsGridState();
}

class _ItemAsGridState extends State<ItemAsGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
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
              // print("Gallery pour un produit");
              // print(widget.productGalleries[widget.items[index]].toString());
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
                child: GridTile(
                  child: Stack(
                    children: [
                      image,
                      // Positioned(
                      //   top: 0,
                      //   right: 0,
                      //   child: IconButton(
                      //     icon: Icon(
                      //       widget.items[index].isBookmarked
                      //           ? Icons.bookmark
                      //           : Icons.bookmark_border,
                      //     ),
                      //     onPressed: () {
                      //       setState(() {
                      //         widget.items[index].isBookmarked = false;
                      //         // !widget.items[index].isBookmarked;
                      //       });
                      //     },
                      //   ),
                      // ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.items[index]['name'] ?? ''),
                            Text(widget.items[index]['description'] ?? ''),
                          ],
                        ),
                      ),
                    ],
                  ),
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
