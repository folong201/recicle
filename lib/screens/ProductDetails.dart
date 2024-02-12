import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:recicle/screens/Messages/DetailsPage.dart';
import 'package:recicle/services/MessageService.dart';
import 'package:recicle/services/UserService.dart';

class ProductDetails extends StatefulWidget {
  var product;

  ProductDetails({Key? key, this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  MessageService messageService = MessageService();
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
                itemCount: 3, //widget.product.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    "assets/images/photolcd.webp",
                    fit: BoxFit.cover,
                  );
                },
                pagination: SwiperPagination(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your logic to open the chat screen with the owner
                UserService.messageOwner(
                  context,
                  widget.product['uid'],
                );
              },
              child: const Text('Message Owner'),
            ),
            Text(widget.product['name'].toString()),
            Text(widget.product['description'].toString() ?? "Unknow"),
            // Text(widget.product.productCategory[0].toString() ?? "Unknow"),
            // Text(widget.product.productPrice.toString() ?? "Unknow"),
            // Text(widget.product.productSubcategory[0].toString() ?? "Unknow"),
            // Text(widget.product.timestamp.toString() ?? "Unknow"),
          ],
        ),
      ),
    );
  }
}
