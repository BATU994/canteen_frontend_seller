import 'package:canteen_frontend_seller/src/features/orders/domain/entities/order_update_entity.dart';

abstract class IOrderWsRepository {
  Stream<OrderUpdateEntity> listenOrderUpdates();
}