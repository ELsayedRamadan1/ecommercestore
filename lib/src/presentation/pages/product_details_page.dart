import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'product_${product.id}',
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 12),
            Text(product.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('${product.price.toStringAsFixed(2)} ', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(product.description),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final cartItem = CartItem(id: product.id, title: product.title, price: product.price, image: product.image, qty: 1);
                context.read<CartCubit>().addItem(cartItem);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أضيف إلى السلة')));
              },
              child: const Text('أضف إلى السلة'),
            )
          ],
        ),
      ),
    );
  }
}
