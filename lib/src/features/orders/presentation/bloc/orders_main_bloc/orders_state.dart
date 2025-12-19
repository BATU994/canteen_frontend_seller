
part of 'orders_bloc.dart';


@immutable
sealed class OrdersState extends Equatable {
  const OrdersState();
  
  @override
  List<Object?> get props => [];
}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {
  final List<OrderDto>? orders;
  
  const OrdersLoading({this.orders}) : super();
  
  @override
  List<Object?> get props => [orders];
}

final class OrdersLoaded extends OrdersState {
  final List<OrderDto> orders;
  
  const OrdersLoaded(this.orders) : super();
  
  @override
  List<Object?> get props => [orders];
}

final class OrdersError extends OrdersState {
  final DomainException error;
  final List<OrderDto>? previousOrders;
  
  const OrdersError(this.error, {this.previousOrders}) : super();
  
  @override
  List<Object?> get props => [error, previousOrders];
}

final class OrdersWsConnected extends OrdersState {
  const OrdersWsConnected() : super();
}

final class OrdersWsDisconnected extends OrdersState {
  const OrdersWsDisconnected() : super();
}
