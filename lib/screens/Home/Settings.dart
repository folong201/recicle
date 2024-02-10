import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:recicle/services/ProductService.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> products = [
  ]; // Example list of products

  createnewProduct() {
    setState(() {
      products.add("new product");
    });
  }

  _showCreateProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateProductDialog();
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   String? uid = FirebaseAuth.instance.currentUser?.uid;
    ProductService().getProductsByUser(uid).then((value) {
      setState(() {
        products = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Column(children: [
            Container(
              height: 200,
              child: Swiper(
                itemCount: 3, //widget.product.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      Container(
                        height: 200,
                        child: Image.asset(
                          "assets/images/photolcd.webp",
                          // widget.product.images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 02,
                        right: 30,
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // TODO: Implement delete functionality
                            print("element suprimer");
                          },
                        ),
                      ),
                    ],
                  );
                },
                pagination: SwiperPagination(),
              ),
            ),
            ListTile(
              title: Text(products[index]['name'].toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        products.removeAt(index);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Implement edit functionality
                    },
                  ),
                ],
              ),
              subtitle: Text("description du ptoduit "),
            ),
          ]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showCreateProductDialog();
        },
      ),
    );
  }
}

class CreateProductDialog extends StatefulWidget {
  // const CreateProductDialog({Key key});

  @override
  State<CreateProductDialog> createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  String productName = '';
  double productPrice = 0.0;
  String productDescription = '';
  String productCategory = '';
  String productSubcategory = '';
  List<String> productImages = [];
  bool isLoading = false;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        productImages.add(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AlertDialog(
            title: Text('Create New Product'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                    ),
                    onChanged: (value) {
                      productName = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Product Price',
                    ),
                    onChanged: (value) {
                      productPrice = double.parse(value);
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Product Description',
                    ),
                    onChanged: (value) {
                      productDescription = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Product Category',
                    ),
                    onChanged: (value) {
                      productCategory = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Product Subcategory',
                    ),
                    onChanged: (value) {
                      productSubcategory = value;
                    },
                  ),
                  ElevatedButton(
                    child: Text('Add Image'),
                    onPressed: _selectImage,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Createe'),
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  if (productName.isEmpty ||
                      productPrice == 0.0 ||
                      productDescription.isEmpty ||
                      productCategory.isEmpty ||
                      productSubcategory.isEmpty) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                  ProductService(uid: FirebaseAuth.instance.currentUser?.uid!)
                      .addProduct(
                    productName,
                    productPrice,
                    productDescription,
                    setCategory(productCategory),
                    setCategory(productSubcategory),
                    'assets/images/photolcd.webp',
                  )
                      .then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    print("produit creer avec succes");
                    print(value.id);
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
  }
  setCategory(String chaine){
    //code pour set les category en separant par des virgules
    return chaine.split(",");
  }
}
