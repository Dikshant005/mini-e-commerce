import 'package:bloc/bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'cart_repository.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repo;

  CartBloc(this.repo) : super(CartLoading()) {
    on<LoadCart>(_onLoad);
    on<LoadCartWithProducts>(_onLoadWithProducts);
    on<AddToCart>((e, _) {
      repo.add(e.productId);
      add(LoadCart());
    });
    on<RemoveFromCart>((e, _) {
      repo.remove(e.productId);
      add(LoadCart());
    });
    on<ClearCart>((_, __) {
      repo.clear();
      add(LoadCart());
    });
  }

  void _onLoad(LoadCart event, Emitter<CartState> emit) {
    emit(CartLoaded([])); // no products supplied → empty
  }

  void _onLoadWithProducts(LoadCartWithProducts event, Emitter<CartState> emit) {
    final ids = repo.ids;
    final items = event.products.where((p) => ids.contains(p.id)).toList();
    emit(CartLoaded(items));
  }
}