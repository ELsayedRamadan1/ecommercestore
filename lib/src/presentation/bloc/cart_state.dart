// filepath: d:\ecommercestore\lib\src\presentation\bloc\cart_state.dart
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int id;
  final String title;
  final double price;
  final String image;
  final int qty;

  const CartItem({required this.id, required this.title, required this.price, required this.image, required this.qty});

  CartItem copyWith({int? qty}) => CartItem(id: id, title: title, price: price, image: image, qty: qty ?? this.qty);

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'price': price, 'image': image, 'qty': qty};

  static CartItem fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'] as int,
        title: json['title'] as String,
        price: (json['price'] as num).toDouble(),
        image: json['image'] as String,
        qty: json['qty'] as int,
      );

  @override
  List<Object?> get props => [id, title, price, image, qty];
}

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded(this.items);

  int get totalItems => items.fold(0, (s, i) => s + i.qty);

  double get totalPrice => items.fold(0.0, (s, i) => s + (i.price * i.qty));

  @override
  List<Object?> get props => [items];
}

class CartEmpty extends CartState {}

class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

