import 'package:dio/dio.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final response = await dio.get('https://fakestoreapi.com/products');
    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch products: ${response.statusCode}');
  }
}
