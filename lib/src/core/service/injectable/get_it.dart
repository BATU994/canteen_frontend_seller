import 'package:canteen_frontend_seller/src/features/orders/data/sources/remote/i_order_remote.dart';
import 'package:canteen_frontend_seller/src/features/orders/data/sources/remote/order_remote_impl.dart';
import 'package:canteen_frontend_seller/src/features/orders/presentation/bloc/orders_main_bloc/orders_bloc.dart';
import 'package:canteen_frontend_seller/src/features/products/data/repositories/product_remote_impl.dart';
import 'package:canteen_frontend_seller/src/features/products/domain/repositories/i_product_remote.dart';
import 'package:canteen_frontend_seller/src/features/products/presentation/bloc/product_manage_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<IOrderRemote>(
    () => OrderRemoteImpl(dio: getIt()),
  );

  getIt.registerFactory<OrdersBloc>(() => OrdersBloc(getIt()));

  getIt.registerLazySingleton<IProductRemote>(
    () => ProductRemoteImpl(dio: getIt()),
  );

  getIt.registerFactory<ProductManageBloc>(() => ProductManageBloc(getIt()));
}
