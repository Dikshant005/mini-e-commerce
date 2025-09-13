import 'package:hive/hive.dart';

class WishlistRepository {
  final Box<int> _box = Hive.box('wishlist'); // key: productId

  List<int> get ids => _box.keys.cast<int>().toList();

  void add(int id) => _box.put(id, 1);
  void remove(int id) => _box.delete(id);
}