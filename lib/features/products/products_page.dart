import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_simple/core/theme/cubit/theme_cubit.dart';
import 'package:my_shop_simple/features/products/products_detail_page.dart';
import '../auth/auth_bloc.dart';
import '../auth/auth_event.dart';
import '../cart/cart_bloc.dart';
import '../cart/cart_event.dart';
import '../wishlist/wishlist_bloc.dart';
import '../wishlist/wishlist_event.dart';
import 'products_bloc.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle theme',
            onPressed: () => context.read<ThemeCubit>().toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/wishlist'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
          ),
        ],
      ),
      body: const ProductList(),
    );
  }

  void _showSearch(BuildContext ctx) {
    final ctrl = TextEditingController();
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Search'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Type product name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ctx.read<ProductsBloc>().add(SearchProducts(ctrl.text.trim()));
              Navigator.pop(ctx);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}

/* -------------------- Product List with Refresh -------------------- */

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    context.read<ProductsBloc>().add(FetchProducts()); // first page
  }

  void _onScroll() {
    if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
      context.read<ProductsBloc>().add(FetchProducts()); // pagination
    }
  }

  /* ---------- pull-to-refresh ---------- */
  Future<void> _refresh() async {
    context.read<ProductsBloc>().add(RefreshProducts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (_, state) {
        if (state is ProductsError) return Center(child: Text(state.message));
        if (state is ProductsInitial && state.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = state.products;
        final reachEnd = state is ProductsLoaded ? state.reachEnd : false;

        return RefreshIndicator(
          onRefresh: _refresh,
          child: GridView.builder(
            controller: _scroll,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 600, // Adjust this value as needed
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: reachEnd ? list.length : list.length + 1,
            itemBuilder: (_, i) {
              if (i >= list.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final p = list[i];
              return Card(
                elevation: 4,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          p.thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('\$${p.price}'),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () => context.read<CartBloc>().add(AddToCart(p.id)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () => context.read<WishlistBloc>().add(AddToWishlist(p)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}