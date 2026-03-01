// filepath: d:\ecommercestore\lib\src\presentation\bloc\cart_cubit.dart
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final SharedPreferences prefs;
  static const _kCartKey = 'cart_items';

  CartCubit(this.prefs) : super(CartInitial()) {
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      final raw = prefs.getString(_kCartKey);
      if (raw == null || raw.isEmpty) {
        emit(CartEmpty());
        return;
      }
      final List decoded = json.decode(raw) as List;
      final items = decoded.map((e) => CartItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      if (items.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartLoaded(items));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _persist(List<CartItem> items) async {
    final jsonList = items.map((e) => e.toJson()).toList();
    await prefs.setString(_kCartKey, json.encode(jsonList));
  }

  Future<void> addItem(CartItem item) async {
    try {
      final current = state is CartLoaded ? List<CartItem>.from((state as CartLoaded).items) : <CartItem>[];
      final idx = current.indexWhere((i) => i.id == item.id);
      if (idx >= 0) {
        final existing = current[idx];
        current[idx] = existing.copyWith(qty: existing.qty + item.qty);
      } else {
        current.add(item);
      }
      await _persist(current);
      emit(CartLoaded(current));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> removeItem(int productId) async {
    try {
      final current = state is CartLoaded ? List<CartItem>.from((state as CartLoaded).items) : <CartItem>[];
      current.removeWhere((i) => i.id == productId);
      await _persist(current);
      if (current.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartLoaded(current));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> updateQuantity(int productId, int qty) async {
    try {
      final current = state is CartLoaded ? List<CartItem>.from((state as CartLoaded).items) : <CartItem>[];
      final idx = current.indexWhere((i) => i.id == productId);
      if (idx >= 0) {
        if (qty <= 0) {
          current.removeAt(idx);
        } else {
          current[idx] = current[idx].copyWith(qty: qty);
        }
        await _persist(current);
        if (current.isEmpty) {
          emit(CartEmpty());
        } else {
          emit(CartLoaded(current));
        }
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> clearCart() async {
    try {
      await prefs.remove(_kCartKey);
      emit(CartEmpty());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}

