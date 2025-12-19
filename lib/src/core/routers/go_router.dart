import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:canteen_frontend_seller/src/core/routers/layout_scaffold.dart';
import 'package:canteen_frontend_seller/src/core/routers/routes.dart';
import 'package:canteen_frontend_seller/src/core/service/injectable/get_it.dart';

import 'package:canteen_frontend_seller/src/features/orders/presentation/bloc/orders_main_bloc/orders_bloc.dart';
import 'package:canteen_frontend_seller/src/features/orders/presentation/pages/order_page.dart';

import 'package:canteen_frontend_seller/src/features/products/presentation/bloc/product_manage_bloc.dart';
import 'package:canteen_frontend_seller/src/features/products/presentation/pages/product_manage_page.dart';
import 'package:canteen_frontend_seller/src/features/products/presentation/pages/product_create_page.dart';

final _rootNavigationKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigationKey,
  initialLocation: Routes.orders,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return LayoutScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.orders,
              pageBuilder: (context, state) => NoTransitionPage(
                child: BlocProvider(
                  create: (_) => getIt<OrdersBloc>()..add(LoadOrdersEvent()),
                  child: OrderPage(),
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.shop,
              pageBuilder: (context, state) => NoTransitionPage(
                child: BlocProvider(
                  create: (_) =>
                      getIt<ProductManageBloc>()..add(LoadAllProducts()),
                  child: const ProductManagePage(),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.createProd,
      pageBuilder: (context, state) => NoTransitionPage(
        child: BlocProvider(
          create: (context) => getIt<ProductManageBloc>(),
          child: ProductCreatePage(),
        ),
      ),
    ),
  ],
);
