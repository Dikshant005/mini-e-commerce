import 'package:bloc/bloc.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';
import 'wishlist_repository.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository repo;
  WishlistBloc(this.repo) : super(WishlistLoading()) {
    on<LoadWishlist>(_onLoad);
    on<AddToWishlist>((e, _) => repo.add(e.product.id));
    on<RemoveFromWishlist>((e, _) => repo.remove(e.product.id));
  }

  void _onLoad(LoadWishlist event, Emitter<WishlistState> emit) {
    emit(WishlistLoaded(repo.ids));
  }
}