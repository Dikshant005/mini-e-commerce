import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/product.dart';

class CacheService {
  static const _key = 'products';

  static List<Product> getProducts() {
    final box = Hive.box<String>('products_cache');
    final jsonList = box.get(_key, defaultValue: '[]')!; 
    final List<dynamic> decoded = jsonDecode(jsonList);
    return decoded.map((e) => Product.fromJson(e)).toList();
  }

  static void saveProducts(List<Product> products) {
    final jsonList = jsonEncode(products.map((p) => p.toJson()).toList());
    box.put(_key, jsonList);
  }

  static Box<String> get box => Hive.box<String>('products_cache');
}