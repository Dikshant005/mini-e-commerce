import 'package:hive/hive.dart';

class CartRepository {
  final Box<int> _box = Hive.box('cart'); // key: productId, value: qty

  List<int> get ids => _box.keys.cast<int>().toList();

  void add(int id) => _box.put(id, (_box.get(id) ?? 0) + 1);
  void remove(int id) => _box.delete(id);
  void clear() => _box.clear();
}