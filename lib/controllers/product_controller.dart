import 'package:flutter/material.dart';
import '../repository/product_repository.dart';
import '../data/model.dart';

class ProductController with ChangeNotifier {
  final ProductRepository _repository;

  ProductController(this._repository);

  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> addProduct(Product product) async {
    await _repository.insertProduct(product);
    _products.add(product);

    notifyListeners();
  }

  Future<void> fetchProducts() async {
    await _repository.getProducts();
    notifyListeners();
  }

  Future<Product?> fetchProduct(String id) async {
    return await _repository.getProduct(id);
  }

  Future<void> updateProduct(Product product) async {
    await _repository.updateProduct(product);
    notifyListeners();
  }

  Future<void> deleteProduct(Product product) async {
    await _repository.deleteProduct(product);
    notifyListeners();
  }
}