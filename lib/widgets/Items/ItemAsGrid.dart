import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:recicle/screens/Home/DefaultHome.dart';
import 'package:recicle/screens/products/ProductDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                    fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                imageUrl: imageUrl,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              );
            }
            return GestureDetector(
              child: GridTile(
                child: Stack(
                  children: [
                    image,
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
          },
        );
      },
    );
  }

  productDatails(context, product) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ProductDetails(
          product: product,
          productGallery: widget.productGalleries[product.id],
        );
      },
    ));
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
}
