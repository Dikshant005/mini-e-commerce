import '../../core/models/product.dart';

abstract class ProductsState {
  final List<Product> products;
  ProductsState(this.products);
}

class ProductsInitial extends ProductsState {
  ProductsInitial() : super([]);
}

class ProductsLoading extends ProductsState {          
  ProductsLoading() : super([]);
}

class ProductsLoaded extends ProductsState {
  final bool reachEnd;
  ProductsLoaded(List<Product> products, {this.reachEnd = false})
      : super(products);
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message) : super([]);
}