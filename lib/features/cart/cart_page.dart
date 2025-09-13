import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../products/products_bloc.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // send current product list together with load event
    final products = context.read<ProductsBloc>().state.products;
    context.read<CartBloc>().add(LoadCartWithProducts(products));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear all',
            onPressed: () => context.read<CartBloc>().add(ClearCart()),
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (_, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartError) {
            return Center(child: Text(state.message));
          }
          final items = (state as CartLoaded).items;
          if (items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          final total = items.fold<double>(0, (sum, p) => sum + p.price);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final p = items[i];
                    return ListTile(
                      leading: Image.network(p.thumbnail,
                          width: 60, fit: BoxFit.cover),
                      title: Text(p.title),
                      subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () =>
                            context.read<CartBloc>().add(RemoveFromCart(p.id)),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}