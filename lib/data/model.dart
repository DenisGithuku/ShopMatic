class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> tags;
  final List<Option> options;
  final List<Variant> variants;
  final String? image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.tags,
    required this.options,
    required this.variants,
    required this.image,
  });
}

class Option {
  final String name;
  final List<String> values;

  Option({required this.name, required this.values});
}

class Variant {
  final String id;
  final String name;
  final double price;
  final int stock;

  Variant(
      {required this.id,
      required this.name,
      required this.price,
      required this.stock});
}
