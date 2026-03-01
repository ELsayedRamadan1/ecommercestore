import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/products_cubit.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';
import '../widgets/product_card.dart';
import 'product_details_page.dart';
import '../widgets/app_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('المتجر'),
        actions: [
          BlocBuilder<CartCubit, CartState>(builder: (context, state) {
            int count = 0;
            if (state is CartLoaded) count = state.totalItems;
            return IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/cart'),
              icon: Stack(
                alignment: Alignment.topRight,
                children: [
                  const Icon(Icons.shopping_cart),
                  if (count > 0)
                    CircleAvatar(radius: 8, backgroundColor: Colors.red, child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white))),
                ],
              ),
            );
          })
        ],
      ),
      body: AppBackground(
        padding: const EdgeInsets.fromLTRB(12, 100, 12, 12),
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading || state is ProductsInitial) {
              return GridView.builder(
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.66, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemBuilder: (c, i) => const Card(child: SizedBox.shrink()),
              );
            }
            if (state is ProductsError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('حدث خطأ: ${state.message}'),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: () => context.read<ProductsCubit>().loadProducts(), child: const Text('إعادة المحاولة'))
                  ],
                ),
              );
            }
            if (state is ProductsEmpty) {
              return const Center(child: Text('لا يوجد منتجات حالياً'));
            }
            if (state is ProductsLoaded) {
              final products = state.products;
              return GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.66, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemBuilder: (c, i) {
                  final p = products[i];
                  return ProductCard(
                    product: p,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailsPage(product: p))),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
