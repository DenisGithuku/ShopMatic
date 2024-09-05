import '../data/model.dart';
import '../data/product_db.dart';

class ProductRepository {
  final ProductDbManager _dbManager;

  ProductRepository(this._dbManager);

  Future<void> insertProduct(Product product) async {
    await _dbManager.insertProduct(product);
  }

  Future<List<Product>> getProducts() async {
    return await _dbManager.fetchProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _dbManager.updateProduct(product);
  }

  Future<void> deleteProduct(Product product) async {
    await _dbManager.deleteProduct(product);
  }
}