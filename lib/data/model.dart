import 'dart:convert';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String options;
  final String variants;
  final String? image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
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
      options: map['options'],
      variants: map['variants'],
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
      'options': options,
      'variants': variants,
      'image': image,
    };
  }
}

class Option {
  final String name;
  final List<String> option_values;

  Option({required this.name, required this.option_values});

  // Convert a map to an Option instance
  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      name: map['name'],
      option_values: List<String>.from(map['option_values']),
    );
  }

  // Convert an Option instance to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'option_values': option_values,
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

// Convert List<Option> to JSON string
String serializeOptions(List<Option> options) {
  return jsonEncode(options.map((option) => option.toMap()).toList());
}

// Convert List<Variant> to JSON string
String serializeVariants(List<Variant> variants) {
  return jsonEncode(variants.map((variant) => variant.toMap()).toList());
}

// Convert JSON string back to List<Option>
List<Option> deserializeOptions(String jsonString) {
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => Option.fromMap(json)).toList();
}

// Convert JSON string back to List<Variant>
List<Variant> deserializeVariants(String jsonString) {
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => Variant.fromMap(json)).toList();
}
