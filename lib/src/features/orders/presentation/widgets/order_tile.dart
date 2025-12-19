import 'package:canteen_frontend_seller/src/core/const/const.dart';
import 'package:canteen_frontend_seller/src/features/orders/data/models/order_dto.dart';
import 'package:canteen_frontend_seller/src/features/orders/data/models/order_item_dto.dart';
import 'package:canteen_frontend_seller/src/features/orders/presentation/bloc/orders_main_bloc/orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderTile extends StatelessWidget {
  final OrderDto order;
  final OrdersBloc ordersBloc;
  const OrderTile({super.key, required this.order, required this.ordersBloc});

  @override
  Widget build(BuildContext context) {
    return _OrderTileContent(order: order, ordersBloc: ordersBloc);
  }
}

class _OrderTileContent extends StatelessWidget {
  final OrderDto order;
  final OrdersBloc ordersBloc;
  const _OrderTileContent({required this.order, required this.ordersBloc});
  String _nextStatus(String status) {
    if (status == "pending") {
      return 'Подтвердить готовность';
    } else if (status == "paid") {
      return 'Оплачено';
    } else if (status == 'ready') {
      return 'Подтвердить оплату';
    } else if (status == 'cancelled') {
      return 'Отменено';
    } else {
      return 'Ошибка';
    }
  }

  Color _colorStatus(String status) {
    if (status == "pending") {
      return Color.fromARGB(255, 233, 159, 0);
    } else if (status == "paid") {
      return Colors.green;
    } else if (status == 'ready') {
      return Colors.blue;
    } else if (status == 'cancelled') {
      return Colors.redAccent;
    } else {
      return Colors.grey;
    }
  }

  IconData _iconStatus(String status) {
    if (status == "pending") {
      return Icons.pending_rounded;
    } else if (status == "paid") {
      return Icons.check;
    } else if (status == 'ready') {
      return Icons.payment;
    } else if (status == 'cancelled') {
      return Icons.delete;
    } else {
      return Icons.abc;
    }
  }

  Widget _buildButton(BuildContext context, OrderDto order) {
    Color btnColor = _colorStatus(order.status);
    final isPaid = order.status == 'paid';
    return GestureDetector(
      onTap: isPaid ? null : () {
        ordersBloc.add(
          OrderChangeStatus(orderId: order.id, status: order.status),
        );
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 80, minHeight: 80),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(borderRadiusSet),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  _iconStatus(order.status),
                  color: _colorStatus(order.status),
                  size: 30,
                ),
              ),
              SizedBox(width: 20),
              Text(
                _nextStatus(order.status),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemTile(OrderItemDto item) {
    final int itemPrice = (item.price * item.quantity).toInt();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '${item.name} - ${item.quantity.toString()} штук',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
              ),
              SizedBox(width: 5),
            ],
          ),
          Text(
            '₸${itemPrice.toString()}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 150),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.code,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₸${order.price.toString()}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      order.userName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order.items.length,
                      itemBuilder: (context, index) {
                        final item = order.items[index];
                        return _buildItemTile(item);
                      },
                    ),
                    Divider(),
                    _buildButton(context, order),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
