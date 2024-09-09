import 'package:flutter/material.dart';
import 'package:shopmatic/data/model.dart';
import 'package:shopmatic/data/product_db.dart';
import 'package:shopmatic/repository/product_repository.dart';
import 'package:shopmatic/screens/new_product/components/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Get access to repository
  late ProductRepository _productRepository;

  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _productRepository = ProductRepository(ProductDbManager());
    _fetchProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      // Fetch the list of products
      List<Product> products = await _productRepository.getProducts();

      // Update the state with the fetched products
      setState(() {
        _products = products;
      });
    } catch (e) {
      // Handle any errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('My Products'),
          actions: [
            IconButton(
                onPressed: () => Navigator.pushNamed(context, "/new_product"),
                icon: Icon(Icons.add))
          ],
        ),
        body: _buildProductList(context));
  }

  Widget _buildProductList(BuildContext context) {
    if (_products.isEmpty) {
      return Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No products available.'),
          FilledButton.tonal(
              onPressed: () => Navigator.pushNamed(context, "/new_product"),
              child: Text('Add product'))
        ],
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ProductItem(product: product);
        },
      ),
    );
  }
}
