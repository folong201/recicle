import 'package:flutter/material.dart';
import 'package:recicle/screens/Home/DefaultHome.dart';
import 'package:recicle/screens/ProductDetails.dart';

class ItemAsGrid extends StatefulWidget {
  final List<dynamic> items;

  const ItemAsGrid({required this.items});

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
        return GestureDetector(
          child: GridTile(
            child: Stack(
              children: [
                Image.asset("assets/images/photolcd.webp"),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      widget.items[index].isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.items[index].isBookmarked = false;
                        // !widget.items[index].isBookmarked;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.items[index].name ?? ''),
                      Text(widget.items[index].description ?? ''),
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
  }

  productDatails(context, product) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ProductDetails(product: product);
      },
    ));
  }
}
