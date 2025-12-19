class OrderUpdateEntity {
  final int orderId;
  final String status;

  const OrderUpdateEntity({
    required this.orderId,
    required this.status,
  });

  factory OrderUpdateEntity.fromJson(Map<String, dynamic> json) {
    return OrderUpdateEntity(
      orderId: json['order_id'],
      status: json['status'],
    );
  }
}
