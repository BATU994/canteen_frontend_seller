import 'package:canteen_frontend_seller/src/core/service/injectable/get_it.dart';
import 'package:canteen_frontend_seller/src/features/orders/data/models/order_dto.dart';
import 'package:canteen_frontend_seller/src/features/orders/presentation/bloc/orders_main_bloc/orders_bloc.dart';
import 'package:canteen_frontend_seller/src/features/orders/presentation/widgets/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();
    _ordersBloc = getIt<OrdersBloc>();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    _ordersBloc.add(LoadOrdersEvent());
    _ordersBloc.add(ConnectWsEvent());
  }

  @override
  void dispose() {
    _ordersBloc.add(DisconnectWsEvent());
    _ordersBloc.close();
    super.dispose();
  }

  Widget _buildOrderList(List<OrderDto> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('Нет заказов'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders.reversed.toList()[index];
        return OrderTile(order: order, ordersBloc: _ordersBloc);
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Произошла ошибка при загрузке заказов',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _ordersBloc.add(LoadOrdersEvent()),
            child: const Text('Повторить попытку'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _ordersBloc.add(LoadOrdersEvent()),
          ),
        ],
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        bloc: _ordersBloc,
        builder: (context, state) {
          if (state is OrdersLoading) {
            // Show loading indicator with existing orders if available
            if (state.orders != null && state.orders!.isNotEmpty) {
              return Column(
                children: [
                  const LinearProgressIndicator(minHeight: 2),
                  Expanded(child: _buildOrderList(state.orders!)),
                ],
              );
            }
            // Show full screen loader if no orders yet
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrdersLoaded) {
            return _buildOrderList(state.orders);
          }

          if (state is OrdersError) {
            return _buildErrorState();
          }

          // Initial state or unknown state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
