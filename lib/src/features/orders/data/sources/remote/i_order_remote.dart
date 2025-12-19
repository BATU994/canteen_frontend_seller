import 'package:canteen_frontend_seller/src/core/exceptions/domain_exceptions.dart';
import 'package:canteen_frontend_seller/src/features/orders/data/models/order_dto.dart';
import 'package:dartz/dartz.dart';

abstract interface class IOrderRemote {
  Future<Either<DomainException,List<OrderDto>>> getAllOrders();
  Future<Either<DomainException, void>> changeOrderStatus(String status, int orderId);
}