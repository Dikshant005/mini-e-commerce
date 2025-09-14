abstract class ProductsEvent {}

class FetchProducts extends ProductsEvent {}

class SearchProducts extends ProductsEvent {
  final String query;
  SearchProducts(this.query);
}

class RefreshProducts extends ProductsEvent {} 