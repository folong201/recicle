import 'package:flutter/material.dart';
import 'package:recicle/screens/Home/DefaultHome.dart';
import 'package:recicle/screens/ProductDetails.dart';

class ItemAsList extends StatelessWidget {
  final List<dynamic> items;

  ItemAsList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ListTile(
            leading: Image.asset("assets/images/photolcd.webp"),
            title: Text(items[index].name),
            subtitle: Text(items[index].description),
            trailing: IconButton(
              icon: Icon(
                items[index].isBookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_border,
              ),
              onPressed: () {
                // TODO: Add onPressed logic here
              },
            ),
          ),
          onTap: () {
            productDatails(context, items[index]);
          },
        );
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
}
