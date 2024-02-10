import 'package:recicle/models/User.dart';

class Product {
  User user;
  List<String> categories;
  String name;
  String description;
  double price;
  List<String> subCategories;
  List<String> gallery;

  Product({
    required this.user,
    required this.categories,
    required this.name,
    required this.description,
    required this.price,
    required this.subCategories,
    required this.gallery,
  });

  // Méthode pour afficher les détails du produit
  void displayDetails() {
    print('Product Name: $name');
    print('Description: $description');
    print('Price: $price');
    print('Categories: $categories');
    print('Subcategories: $subCategories');
    print('Gallery: $gallery');
  }

  // Méthode pour ajouter une catégorie au produit
  void addCategory(String category) {
    categories.add(category);
  }

  // Méthode pour ajouter une sous-catégorie au produit
  void addSubCategory(String subCategory) {
    subCategories.add(subCategory);
  }

  // Méthode pour ajouter une image à la galerie du produit
  void addImageToGallery(String image) {
    gallery.add(image);
  }
}
