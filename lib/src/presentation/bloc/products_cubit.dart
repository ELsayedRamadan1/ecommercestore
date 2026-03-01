import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository repository;

  ProductsCubit(this.repository) : super(ProductsInitial());

  Future<void> loadProducts() async {
    try {
      emit(ProductsLoading());
      final products = await repository.fetchProducts();
      if (products.isEmpty) {
        emit(ProductsEmpty());
      } else {
        emit(ProductsLoaded(products));
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
