import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';
import '../widgets/app_background.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سلة المشتريات')),
      body: AppBackground(
        padding: const EdgeInsets.fromLTRB(12, 80, 12, 12),
        child: BlocBuilder<CartCubit, CartState>(builder: (context, state) {
          if (state is CartInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartEmpty) {
            return const Center(child: Text('السلة فارغة'));
          }
          if (state is CartError) {
            return Center(child: Text('خطأ: ${state.message}'));
          }
          if (state is CartLoaded) {
            final items = state.items;
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (c, i) {
                      final it = items[i];
                      return ListTile(
                        leading: Image.network(it.image, width: 56, height: 56, fit: BoxFit.cover),
                        title: Text(it.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('${it.price.toStringAsFixed(2)} x ${it.qty}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: () => context.read<CartCubit>().updateQuantity(it.id, it.qty - 1), icon: const Icon(Icons.remove)),
                            Text('${it.qty}'),
                            IconButton(onPressed: () => context.read<CartCubit>().updateQuantity(it.id, it.qty + 1), icon: const Icon(Icons.add)),
                            IconButton(onPressed: () => context.read<CartCubit>().removeItem(it.id), icon: const Icon(Icons.delete_outline)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('المجموع: ${state.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () {
                        // simple clear as "checkout"
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('تأكيد'),
                            content: const Text('هل تريد إنهاء الطلب ومسح السلة؟'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
                              TextButton(
                                onPressed: () {
                                  context.read<CartCubit>().clearCart();
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنهاء الطلب')));
                                },
                                child: const Text('نعم'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('الدفع'),
                    )
                  ],
                )
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
