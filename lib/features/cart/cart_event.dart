import '../../core/models/product.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {}

class LoadCartWithProducts extends CartEvent {
  final List<Product> products;
  LoadCartWithProducts(this.products);
}

class AddToCart extends CartEvent {
  final int productId;
  AddToCart(this.productId);
}

class RemoveFromCart extends CartEvent {
  final int productId;
  RemoveFromCart(this.productId);
}

class ClearCart extends CartEvent {}