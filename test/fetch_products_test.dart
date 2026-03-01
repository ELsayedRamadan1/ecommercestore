import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommercestore/src/data/datasources/product_remote_datasource.dart';

void main() {
  test('fetch products from fakestore', () async {
    final dio = Dio();
    final ds = ProductRemoteDataSourceImpl(dio);
    final products = await ds.fetchProducts();
    expect(products, isNotEmpty);
    print('Fetched ${products.length} products. First: ${products.first.title}');
  }, timeout: Timeout(Duration(seconds: 10)));
}

