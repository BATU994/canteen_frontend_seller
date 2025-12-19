part of 'orders_bloc.dart';

@immutable
sealed class OrdersEvent {}

class ConnectWsEvent extends OrdersEvent {}

class DisconnectWsEvent extends OrdersEvent {}

class LoadOrdersEvent extends OrdersEvent {}

class RefreshOrdersEvent extends OrdersEvent {}

class OrderNewReceived extends OrdersEvent {
  final OrderDto data;

  OrderNewReceived(this.data);
}


class OrderChangeStatus extends OrdersEvent {
  final String status;
  final int orderId;
  OrderChangeStatus({required this.orderId, required this.status});
}