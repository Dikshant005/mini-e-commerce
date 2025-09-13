import 'package:flutter/material.dart';
import '../../core/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(product.thumbnail, height: 200)),
            const SizedBox(height: 12),
            Text(product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Category: ${product.category}'),
            Text('Price: \$${product.price}'),
            Text('Rating: ${product.rating} ⭐'),
            Text('In stock: ${product.stock}'),
          ],
        ),
      ),
    );
  }
}