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
            return _EmptyCart();
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
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (c, i) {
                      final it = items[i];
                      return _CartItemCard(
                        item: it,
                        onRemove: () => context.read<CartCubit>().removeItem(it.id),
                      );
                    },
                    padding: const EdgeInsets.only(bottom: 12),
                  ),
                ),
                _SummaryFooter(totalPrice: state.totalPrice, onCheckout: () => _onCheckout(context)),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  void _onCheckout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الطلب'),
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
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  const _CartItemCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onRemove(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(item.image, width: 72, height: 72, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey.shade200, width: 72, height: 72)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      _QuantityControl(item: item),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final CartItem item;
  const _QuantityControl({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.read<CartCubit>().updateQuantity(item.id, item.qty - 1),
            icon: const Icon(Icons.remove, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('${item.qty}', style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          IconButton(
            onPressed: () => context.read<CartCubit>().updateQuantity(item.id, item.qty + 1),
            icon: const Icon(Icons.add, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
        ],
      ),
    );
  }
}

class _SummaryFooter extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onCheckout;
  const _SummaryFooter({required this.totalPrice, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('المجموع', style: TextStyle(color: Colors.grey)),
                Text('${totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onCheckout,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('الدفع'),
          )
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(100)),
            child: const Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text('السلة فارغة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextButton(onPressed: () => Navigator.of(context).pushReplacementNamed('/home'), child: const Text('تسوق الآن'))
        ],
      ),
    );
  }
}
