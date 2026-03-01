import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommercestore/src/presentation/bloc/products_cubit.dart';
import 'package:ecommercestore/src/domain/entities/product.dart';
import 'package:ecommercestore/src/domain/repositories/product_repository.dart';

class _MockRepo extends Mock implements ProductRepository {}

void main() {
  late _MockRepo repo;
  setUp(() {
    repo = _MockRepo();
  });

  blocTest<ProductsCubit, ProductsState>(
    'emits [Loading, Loaded] when repository returns products',
    build: () {
      when(() => repo.fetchProducts()).thenAnswer((_) async => [
            const Product(id: 1, title: 'a', price: 1.0, description: '', category: '', image: '', rating: 0.0, ratingCount: 0)
          ]);
      return ProductsCubit(repo);
    },
    act: (c) => c.loadProducts(),
    expect: () => [isA<ProductsLoading>(), isA<ProductsLoaded>()],
  );

  blocTest<ProductsCubit, ProductsState>(
    'emits [Loading, Empty] when repository returns empty',
    build: () {
      when(() => repo.fetchProducts()).thenAnswer((_) async => []);
      return ProductsCubit(repo);
    },
    act: (c) => c.loadProducts(),
    expect: () => [isA<ProductsLoading>(), isA<ProductsEmpty>()],
  );

  blocTest<ProductsCubit, ProductsState>(
    'emits [Loading, Error] when repository throws',
    build: () {
      when(() => repo.fetchProducts()).thenThrow(Exception('fail'));
      return ProductsCubit(repo);
    },
    act: (c) => c.loadProducts(),
    expect: () => [isA<ProductsLoading>(), isA<ProductsError>()],
  );
}

