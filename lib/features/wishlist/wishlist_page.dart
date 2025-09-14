import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_simple/features/products/products_bloc.dart';
import 'package:my_shop_simple/features/products/products_detail_page.dart';
import 'wishlist_bloc.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // current full product list from ProductsBloc
    final products = context.read<ProductsBloc>().state.products;
    context.read<WishlistBloc>().add(LoadWishlist());

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (_, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final ids = state.ids;
          if (ids.isEmpty) return const Center(child: Text('Wishlist is empty'));
          // convert ids → products
          final items = products.where((p) => ids.contains(p.id)).toList();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final p = items[i];
              return ListTile(
                leading: Image.network(p.thumbnail, width: 60, fit: BoxFit.cover),
                title: Text(p.title),
                subtitle: Text('\$${p.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () { context.read<WishlistBloc>().add(RemoveFromWishlist(p));
                  context.read<WishlistBloc>().add(LoadWishlist());
                  }
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}