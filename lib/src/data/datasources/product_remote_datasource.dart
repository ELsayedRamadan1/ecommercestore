import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await dio.get('https://fakestoreapi.com/products');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch products: ${response.statusCode}');
    } catch (e) {
      // Fallback: load local products JSON from assets
      try {
        final jsonString = await rootBundle.loadString('assets/data/products.json');
        final data = json.decode(jsonString) as List<dynamic>;
        return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (assetError) {
        // If even the asset loading failed, rethrow the original error to be handled upstream
        throw Exception('Network error: $e; Fallback asset error: $assetError');
      }
    }
  }
}
