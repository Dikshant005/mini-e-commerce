abstract class WishlistState {
  final List<int> ids; // only ids
  WishlistState(this.ids);
}

class WishlistLoading extends WishlistState {
  WishlistLoading() : super([]);
}

class WishlistLoaded extends WishlistState {
  WishlistLoaded(super.ids);
}