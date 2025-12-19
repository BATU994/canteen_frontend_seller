import 'package:canteen_frontend_seller/src/features/orders/data/models/order_item_dto.dart';

class OrderEntity {
  final int userId;
  final List<OrderItemDto> items;
  final String comment;
  final int price;

  OrderEntity({
    required this.userId,
    required this.items,
    required this.comment,
    required this.price,
  });
}
