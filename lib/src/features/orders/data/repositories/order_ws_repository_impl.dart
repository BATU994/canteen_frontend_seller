// import 'dart:async';
// import 'dart:convert';

// import 'package:canteen_frontend/features/orders/domain/entities/order_update_entity.dart';
// import 'package:canteen_frontend/features/orders/domain/repositories/i_order_ws_repository.dart';
// import 'package:canteen_frontend/features/orders/data/sources/remote/i_order_ws_service.dart';
// import 'package:canteen_frontend_buyer/src/features/orders/data/sources/remote/i_order_ws_service.dart';
// import 'package:canteen_frontend_buyer/src/features/orders/domain/repositories/i_order_ws_repository.dart';

// class OrderWsRepositoryImpl implements IOrderWsRepository {
//   final IOrderWsService wsService;

//   OrderWsRepositoryImpl(this.wsService);

//   @override
//   Stream<OrderUpdateEntity> listenOrderUpdates() {
//     return wsService.connect().transform(
//       StreamTransformer<String, OrderUpdateEntity>.fromHandlers(
//         handleData: (jsonString, sink) {
//           try {
//             final data = jsonDecode(jsonString);
//             final orderUpdate = OrderUpdateEntity.fromJson(data);
//             sink.add(orderUpdate);
//           } catch (e) {
//             // You might want to handle or log the error
//             print('Error parsing order update: $e');
//           }
//         },
//         handleError: (error, stackTrace, sink) {
//           // Handle WebSocket errors here
//           print('WebSocket error: $error');
//           sink.addError(error);
//         },
//       ),
//     );
//   }
// }
