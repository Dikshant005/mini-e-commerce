import '../../core/models/product.dart';

abstract class WishlistEvent {}

class LoadWishlist extends WishlistEvent {}

class AddToWishlist extends WishlistEvent {
  final Product product;
  AddToWishlist(this.product);
}

class RemoveFromWishlist extends WishlistEvent {
  final Product product;
  RemoveFromWishlist(this.product);
}