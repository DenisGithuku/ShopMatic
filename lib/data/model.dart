import 'dart:convert';

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

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      category: map['category'],
      tags: List<String>.from(jsonDecode(map['tags'])),
      options: (jsonDecode(map['options']) as List)
          .map((e) => Option.fromMap(e))
          .toList(),
      variants: (jsonDecode(map['variants']) as List)
          .map((e) => Variant.fromMap(e))
          .toList(),
      image: map['image'],
    );
  }

  // Convert a Product instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'tags': jsonEncode(tags),
      'options': jsonEncode(options.map((e) => e.toMap()).toList()),
      'variants': jsonEncode(variants.map((e) => e.toMap()).toList()),
      'image': image,
    };
  }
}

class Option {
  final String name;
  final List<String> values;

  Option({required this.name, required this.values});

  // Convert a map to an Option instance
  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      name: map['name'],
      values: List<String>.from(map['values']),
    );
  }

  // Convert an Option instance to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'values': values,
    };
  }
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

  // Convert a map to a Variant instance
  factory Variant.fromMap(Map<String, dynamic> map) {
    return Variant(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      stock: map['stock'],
    );
  }

  // Convert a Variant instance to a map
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price, 'stock': stock};
  }
}
