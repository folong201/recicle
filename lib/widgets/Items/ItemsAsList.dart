import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:recicle/screens/products/ProductDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemAsList extends StatefulWidget {
  final List<dynamic> items;
  final Map<String, dynamic> productGalleries;
  ItemAsList({required this.items, required this.productGalleries});

  @override
  State<ItemAsList> createState() => _ItemAsListState();
}

class _ItemAsListState extends State<ItemAsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return FutureBuilder<String>(
          future: getImageURL(widget.items[index].id),
          builder: (context, snapshot) {
            Widget image;
            if (snapshot.connectionState == ConnectionState.waiting) {
              image = const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              image = Image.asset('assets/images/photolcd.webp');
            } else {
              final imageUrl = snapshot.data!;
              // image = Image.network(
              //   imageUrl,
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              //   height: double.infinity,
              // );

              image = CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            }
            return GestureDetector(
              child: ListTile(
                leading: Container(
                  width: 50.0, // Adjust width as needed
                  child: image,
                ),
                title: Text(widget.items[index]['name'].toString()),
              ),
              onTap: () {
                productDetails(context, widget.items[index]);
              },
            );
          },
        );
      },
    );
  }

  Future<String> getImageURL(String productId) async {
    if (widget.productGalleries.containsKey(productId)) {
      final images = widget.productGalleries[productId];
      if (images != null && images.isNotEmpty) {
        return getImage(images.first);
      }
    }
    return 'https://placehold.jp/150x150.png';
  }

  Future<String> getImage(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref(path);
      return await ref.getDownloadURL();
    } catch (error) {
      print('Error getting image URL: $error');
      return 'https://placehold.jp/150x150.png';
    }
  }

  void productDetails(BuildContext context, dynamic product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetails(
            product: product,
            productGallery: widget.productGalleries[product.id]),
      ),
    );
  }
}
