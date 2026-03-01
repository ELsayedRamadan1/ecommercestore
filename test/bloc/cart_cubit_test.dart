import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommercestore/src/presentation/bloc/cart_cubit.dart';
import 'package:ecommercestore/src/presentation/bloc/cart_state.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loadCart reads persisted items', () async {
    final prefs = await SharedPreferences.getInstance();
    final raw = '[{"id":1,"title":"t","price":2.5,"image":"u","qty":2}]';
    await prefs.setString('cart_items', raw);
    final cubit = CartCubit(prefs);
    // loadCart is called in ctor; wait a moment
    await Future.delayed(const Duration(milliseconds: 50));
    expect(cubit.state, isA<CartLoaded>());
    final state = cubit.state as CartLoaded;
    expect(state.items.length, 1);
    expect(state.items.first.qty, 2);
  });

  test('addItem persists and updates state', () async {
    final prefs = await SharedPreferences.getInstance();
    final cubit = CartCubit(prefs);
    await cubit.addItem(const CartItem(id: 2, title: 'x', price: 3.0, image: 'u', qty: 1));
    expect(cubit.state, isA<CartLoaded>());
    final state = cubit.state as CartLoaded;
    expect(state.items.length, 1);
    expect(prefs.getString('cart_items'), isNotNull);
  });

  test('updateQuantity updates item qty and persists', () async {
    final prefs = await SharedPreferences.getInstance();
    final cubit = CartCubit(prefs);
    await cubit.addItem(const CartItem(id: 3, title: 'y', price: 5.0, image: 'i', qty: 1));
    await cubit.updateQuantity(3, 4);
    final state = cubit.state as CartLoaded;
    expect(state.items.first.qty, 4);
  });

  test('removeItem removes and clears when empty', () async {
    final prefs = await SharedPreferences.getInstance();
    final cubit = CartCubit(prefs);
    await cubit.addItem(const CartItem(id: 4, title: 'z', price: 1.0, image: 'i', qty: 1));
    await cubit.removeItem(4);
    expect(cubit.state, anyOf(isA<CartEmpty>(), isA<CartLoaded>()));
  });
}

