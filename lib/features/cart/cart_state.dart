import '../../core/models/product.dart';

abstract class CartState {
  final List<Product> products;
  CartState(this.products);
}

class CartLoading extends CartState {
  CartLoading() : super([]);
}

class CartLoaded extends CartState {
  CartLoaded(List<Product> products) : super(products);
  List<Product> get items => products;
}

class CartError extends CartState {
  final String message;
  CartError(this.message) : super([]);
}