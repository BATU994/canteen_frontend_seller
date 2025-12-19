import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:canteen_frontend_seller/src/core/api/adress/api_client.dart';
import 'package:canteen_frontend_seller/src/core/api/adress/endpoints.dart';
import 'package:canteen_frontend_seller/src/core/exceptions/domain_exceptions.dart';
import 'package:canteen_frontend_seller/src/features/orders/data/models/order_dto.dart';
import 'package:canteen_frontend_seller/src/features/orders/data/sources/remote/i_order_remote.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  WebSocketChannel? _channel;
  StreamSubscription? _wsSubscription;
  bool _isConnecting = false;
  bool _isConnected = false;
  Timer? _reconnectTimer;
  final IOrderRemote _orderRepository;

  OrdersBloc(this._orderRepository) : super(OrdersInitial()) {
    on<ConnectWsEvent>(_onConnectWs);
    on<DisconnectWsEvent>(_onDisconnectWs);
    on<LoadOrdersEvent>(_onLoadOrders);
    on<OrderNewReceived>(_onNewOrder);
    on<OrderChangeStatus>(_onChangeStatus);
  }

  Future<void> _onConnectWs(
    ConnectWsEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (_isConnecting || _isConnected) {
      return;
    }

    _isConnecting = true;

    try {
      await _closeWebSocket();

      final wsUrl = ApiClient.defaultBaseWs + EndPoints.ordersWsMain;

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _wsSubscription = _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);

            if (data['type'] == 'connection_established' ||
                data['message'] != null) {
              _isConnected = true;
              _isConnecting = false;
              emit(OrdersWsConnected());
              return;
            }

            if (data['type'] == 'pong') {
              return;
            }

            if (data['type'] == 'order_created' ||
                data['type'] == 'order_updated') {
              try {
                final orderData = data['data'] ?? data;

                final order = OrderDto.fromJson(
                  orderData is Map ? orderData : jsonDecode(orderData),
                );
                add(OrderNewReceived(order));
              } catch (e) {}
            }
          } catch (e) {}
        },
        onError: (error) {
          _handleDisconnection(emit);
        },
        onDone: () {
          _handleDisconnection(emit);
        },
        cancelOnError: true,
      );
      await _channel!.ready.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('WebSocket connection timed out');
        },
      );
    } on TimeoutException catch (e) {
      _handleDisconnection(emit);
    } catch (e) {
      _handleDisconnection(emit);
    } finally {
      _isConnecting = false;
    }
  }

  void _handleDisconnection(Emitter<OrdersState> emit) {
    _isConnected = false;
    _isConnecting = false;

    if (!isClosed) {
      emit(OrdersWsDisconnected());
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectTimer?.isActive ?? false) return;

    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!isClosed && !_isConnected && !_isConnecting) {
        add(ConnectWsEvent());
      }
    });
  }

  Future<void> _onDisconnectWs(
    DisconnectWsEvent event,
    Emitter<OrdersState> emit,
  ) async {
    await _closeWebSocket();
    emit(OrdersWsDisconnected());
  }

  Future<void> _onLoadOrders(
    LoadOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      if (state is OrdersLoaded) {
        emit(OrdersLoading(orders: (state as OrdersLoaded).orders));
      } else {
        emit(OrdersLoading());
      }

      final response = await _orderRepository.getAllOrders();

      response.fold(
        (error) =>
            emit(OrdersError(error, previousOrders: _getCurrentOrders())),
        (List<OrderDto> list) => emit(OrdersLoaded(list)),
      );
    } catch (e) {
      emit(
        OrdersError(
          NetworkException(message: e.toString()),
          previousOrders: _getCurrentOrders(),
        ),
      );
    }
  }

  Future<void> _onNewOrder(
    OrderNewReceived event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final newOrder = event.data;
      add(LoadOrdersEvent());
    } catch (e) {
      emit(OrdersError(NetworkException(message: e.toString())));
    }
  }

  Future<void> _onChangeStatus(
    OrderChangeStatus event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final currentOrders = _getCurrentOrders();
      emit(OrdersLoading(orders: currentOrders));

      String status = 'pending';
      if (event.status == "pending") {
        status = 'ready';
      } else if (event.status == "ready") {
        status = 'paid';
      }

      final response = await _orderRepository.changeOrderStatus(
        status,
        event.orderId,
      );

      await response.fold(
        (error) {
          emit(OrdersError(error, previousOrders: currentOrders));

          add(LoadOrdersEvent());
        },
        (_) {
          if (currentOrders != null) {
            final updatedOrders = currentOrders.map((order) {
              if (order.id == event.orderId) {
                return order.copyWith(status: status);
              }
              return order;
            }).toList();
            emit(OrdersLoaded(updatedOrders));
          } else {
            add(LoadOrdersEvent());
          }
        },
      );
    } catch (e) {
      final currentOrders = _getCurrentOrders();
      emit(
        OrdersError(
          NetworkException(message: e.toString()),
          previousOrders: currentOrders,
        ),
      );
    }
  }

  List<OrderDto>? _getCurrentOrders() {
    if (state is OrdersLoaded) {
      return (state as OrdersLoaded).orders;
    } else if (state is OrdersLoading) {
      return (state as OrdersLoading).orders;
    } else if (state is OrdersError) {
      return (state as OrdersError).previousOrders;
    }
    return null;
  }

  Future<void> _closeWebSocket() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    try {
      await _wsSubscription?.cancel();
      await _channel?.sink.close();
    } finally {
      _wsSubscription = null;
      _channel = null;
      _isConnected = false;
      _isConnecting = false;
    }
  }

  @override
  Future<void> close() async {
    _reconnectTimer?.cancel();
    await _closeWebSocket();
    return super.close();
  }
}
