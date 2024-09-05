import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class ProductDbManager {
  static final ProductDbManager _dbManagerInstance =
      ProductDbManager._internal();
  static Database? _database;

  factory ProductDbManager() {
    return _dbManagerInstance;
  }

  ProductDbManager._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'product.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE products(
      id TEXT PRIMARY KEY,
      name TEXT,
      description TEXT,
      price REAL,
      image TEXT,
      category TEXT,
      tags TEXT
    )''');

    await db.execute('''
      CREATE TABLE options(
      id INTEGER PRIMARY KEY AUTO_INCREMENT,
      product_id TEXT,
      name TEXT,
      values TEXT,
      FOREIGN KEY(product_id) REFERENCES products(id)
      )
      ''');

    await db.execute('''
      CREATE TABLE variants(
      id TEXT PRIMARY KEY,'
      product_id TEXT,
      name TEXT,
      price REAL,
      stock INTEGER,
      FOREIGN KEY(product_id) REFERENCES products(id)
      ''');
  }

  // Inserts a product into the db
  Future<void> insertProduct(Product product) async {
    final db = await database;

    await db.insert('products', {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'category': product.category,
      'tags': product.tags.join(','),
      'options': product.options,
      'variants': product.variants,
      'image': product.image
    });

    for (var option in product.options) {
      await db.insert('options', {
        'product_id': product.id,
        'name': option.name,
        'values': option.values.join(',')
      });
    }

    for (var variant in product.variants) {
      await db.insert('variants', {
        'id': variant.id,
        'product_id': product.id,
        'name': variant.name,
        'price': variant.price,
        'stock': variant.stock,
      });
    }
  }

  // Fetch all products
  Future<List<Product>> fetchProducts() async {
    final db = await database;
    final productMaps = await db.query('products');
    List<Product> products = [];

    for (var productMap in productMaps) {
      String productId = productMap['id'] as String;
      List<Option> options = await _fetchOptionsForProduct(productId);
      List<Variant> variants = await _fetchVariantsForProduct(productId);

      products.add(
        Product(
          id: productMap['id'] as String,
          name: productMap['name'] as String,
          description: productMap['description'] as String,
          price: productMap['price'] as double,
          image: productMap['image'] as String,
          category: productMap['category'] as String,
          tags: (productMap['tags'] as String).split(','),
          options: options,
          variants: variants
        )
      );
    }
    return products;
  }

  Future<List<Option>> _fetchOptionsForProduct(String productId) async {
    final db = await database;
    final optionMaps = await db.query('options',where: 'product_id = ?', whereArgs: [productId]);

    return optionMaps.map((optionMap) {
      return Option(
        name: optionMap['name'] as String,
        values: (optionMap['values'] as String).split(',')
      );
    }).toList();
  }

  Future<List<Variant>> _fetchVariantsForProduct(String productId) async {
    final db = await database;
    final variantMaps = await db.query('variants', where: 'product_id = ?', whereArgs: [productId]);

    return variantMaps.map((variantMap) {
      return Variant(
        id: variantMap['id'] as String,
        name: variantMap['name'] as String,
        price: variantMap['price'] as double,
        stock: variantMap['stock'] as int
      );
    }).toList();
  }
}
