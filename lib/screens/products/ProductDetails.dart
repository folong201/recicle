// import 'dart:js_util';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:recicle/screens/Messages/DetailsPage.dart';
import 'package:recicle/services/MessageService.dart';
import 'package:recicle/services/UserService.dart';

class ProductDetails extends StatefulWidget {
  final dynamic product;
  final dynamic productGallery;

  ProductDetails({
    Key? key,
    required this.product,
    required this.productGallery,
  }) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  MessageService messageService = MessageService();
  DateTime? timestamp;

  Future<String> getImage(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref(path);
      return await ref.getDownloadURL();
    } catch (error) {
      print('Error getting image URL: $error');
      return 'https://placehold.jp/150x150.png';
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialisation de timestamp
    timestamp = widget.product['timestamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            widget.product['timestamp'].millisecondsSinceEpoch)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.product.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              child: Swiper(
                itemCount: widget.productGallery != null
                    ? widget.productGallery.length
                    : 0,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder<String>(
                    future: getImage(widget.productGallery[index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Image.asset(
                          "assets/images/photolcd.webp",
                          fit: BoxFit.cover,
                        );
                      } else {
                        Widget image = CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          imageUrl: snapshot.data!,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        );
                        return image;

                        // Image.network(
                        //   snapshot.data!,
                        //   fit: BoxFit.cover,
                        // );
                      }
                    },
                  );
                },
                pagination: SwiperPagination(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                UserService.messageOwner(
                  context,
                  widget.product['uid'],
                );
              },
              child: const Text('Message Ownerr'),
            ),
            Text(
              'Name: ${widget.product['name'] ?? "Unknown"}',
            ),
            Text(
              'Description: ${widget.product['description'] ?? "Unknown"}',
            ),
            Text(
              'Product Price: ${widget.product['productPrice'] ?? "Unknown"}',
            ),
            // Text(
            //   'Category: ${widget.product['productCategory'] != null ? widget.product['productCategory'].join(", ") : "Unknown"}',
            // ),
            // Text(
            //     'SubCategory: ${widget.product['productSubcategory'] != null && widget.product['productSubcategory'] is List ? widget.product['productSubcategory'].join(", ") : "Unknown"}'),
            Text(
              'Date: ${timestamp != null ? timestamp.toString() : "Unknown"}',
            ),
          ],
        ),
      ),
    );
  }
}
