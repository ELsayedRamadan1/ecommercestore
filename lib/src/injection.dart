import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'presentation/bloc/auth_cubit.dart';
import 'presentation/bloc/cart_cubit.dart';
import 'presentation/bloc/products_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // external
  sl.registerLazySingleton(() => Dio());
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // datasources
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(sl<Dio>()));

  // repositories (register under the interface type)
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl<ProductRemoteDataSource>()));

  // cubits
  sl.registerFactory(() => ProductsCubit(sl<ProductRepository>()));
  sl.registerFactory(() => AuthCubit(sl<SharedPreferences>()));
  sl.registerFactory(() => CartCubit(sl<SharedPreferences>()));
}
