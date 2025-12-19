import 'dart:io';
import 'package:canteen_frontend_seller/src/core/api/adress/api_client.dart';
import 'package:canteen_frontend_seller/src/core/api/adress/endpoints.dart';
import 'package:canteen_frontend_seller/src/core/exceptions/domain_exceptions.dart';
import 'package:canteen_frontend_seller/src/features/orders/data/models/order_dto.dart';
import 'package:canteen_frontend_seller/src/features/orders/data/sources/remote/i_order_remote.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class OrderRemoteImpl implements IOrderRemote {
  final Dio dio;

  OrderRemoteImpl({required this.dio});

  @override
  Future<Either<DomainException, List<OrderDto>>> getAllOrders() async {
    try {
      final response = await dio.get(
        ApiClient.defaultBaseUrl + EndPoints.getOrders,
      );
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final products = data
            .map((json) => OrderDto.fromJson(json as Map<String, dynamic>))
            .toList();
        return Right(products);
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException(
          message: 'Server is taking too long to respond.',
        );
      } else if (e.type == DioExceptionType.badResponse) {
        throw BadRequest();
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          message: 'No internet connection. Please check your network.',
        );
      } else {
        throw NetworkException(message: 'Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<DomainException, void>> changeOrderStatus(
    String status,
    int orderId,
  ) async {
    try {
      final response = await dio.patch(
        '${ApiClient.defaultBaseUrl}${EndPoints.orderPatch}${orderId.toString()}',
        data: {"status": status},
      );
      if (response.statusCode == 200) {
        return Right(null);
      } else {
        return Left(UnknownError());
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        return Left(BadRequest());
      } else if (e.response!.statusCode == 400) {
        return Left(OrderNotFound());
      } else {
        return Left(NetworkException(message: e.toString()));
      }
    }
  }
}
