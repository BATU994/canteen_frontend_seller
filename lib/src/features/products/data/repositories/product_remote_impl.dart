import 'package:canteen_frontend_seller/src/core/api/adress/api_client.dart';
import 'package:canteen_frontend_seller/src/core/api/adress/endpoints.dart';
import 'package:canteen_frontend_seller/src/core/exceptions/domain_exceptions.dart';
import 'package:canteen_frontend_seller/src/features/orders/data/sources/remote/i_order_remote.dart';
import 'package:canteen_frontend_seller/src/features/products/data/models/create_product_dto.dart';
import 'package:canteen_frontend_seller/src/features/products/data/models/product_dto.dart';
import 'package:canteen_frontend_seller/src/features/products/domain/repositories/i_product_remote.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ProductRemoteImpl implements IProductRemote {
  ProductRemoteImpl({required this.dio});
  final Dio dio;
  @override
  Future<Either<DomainException, List<ProductDto>>> getAllProducts() async {
    try {
      final response = await dio.get(
        ApiClient.defaultBaseUrl + EndPoints.productsGet,
      );
      print(response.data);
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;

        final products = data
            .map((json) => ProductDto.fromJson(json as Map<String, dynamic>))
            .toList();
        return Right(products);
      } else if (response.statusCode == 404) {
        return Left(UnknownException(message: '404 Error'));
      } else {
        return Left(UnknownException(message: response.statusMessage));
      }
    } catch (e) {
      return Left(NetworkException(message: e.toString()));
    }
  }

  @override
  Future<Either<DomainException, void>> patchProductPrice(
    int productId,
    int price,
  ) async {
    try {
      final response = await dio.patch(
        ApiClient.defaultBaseUrl +
            EndPoints.productPatch +
            productId.toString(),
        data: {"price": price},
      );
      print(response.data);
      if (response.statusCode == 200) {
        return Right(null);
      } else if (response.statusCode == 404) {
        return Left(UnknownException(message: '404 Error'));
      } else {
        return Left(UnknownException(message: response.statusMessage));
      }
    } catch (e) {
      return Left(NetworkException(message: e.toString()));
    }
  }

  @override
  Future<Either<DomainException, void>> patchProductQuantity(
    int productId,
    int quantity,
  ) async {
    try {
      final response = await dio.patch(
        ApiClient.defaultBaseUrl +
            EndPoints.productPatch +
            productId.toString(),
        data: {"quantity": quantity},
      );
      print(response.data);
      if (response.statusCode == 200) {
        return Right(null);
      } else if (response.statusCode == 404) {
        return Left(UnknownException(message: '404 Error'));
      } else {
        return Left(UnknownException(message: response.statusMessage));
      }
    } catch (e) {
      return Left(NetworkException(message: e.toString()));
    }
  }

  @override
  Future<Either<DomainException, void>> createProduct(
    CreateProductRequest product,
  ) async {
    try {
      final response = await dio.post(
        ApiClient.defaultBaseUrl + EndPoints.productsPost,
        data: product.toFormData(),
      );
      if (response.statusCode == 200) {
        return Right(null);
      } else if (response.statusCode == 404) {
        return Left(UnknownException(message: '404 Error'));
      } else {
        return Left(UnknownException(message: response.statusMessage));
      }
    } catch (e) {
      return Left(NetworkException(message: e.toString()));
    }
  }

  @override
  Future<Either<DomainException, void>> patchProductOther(
    int productId,
    String name,
    int quantity,
    int price,
    String selectedProdType,
  ) async {
    try {
      final response = await dio.patch(
        ApiClient.defaultBaseUrl +
            EndPoints.productPatch +
            productId.toString(),
        data: {
          "name": name,
          "quantity": quantity,
          "price": price,
          "prod_type": selectedProdType,
        },
      );
      if (response.statusCode == 200) {
        return Right(null);
      } else if (response.statusCode == 404) {
        return Left(UnknownException(message: '404 Error'));
      } else {
        return Left(UnknownException(message: response.statusMessage));
      }
    } catch (e) {
      return Left(NetworkException(message: e.toString()));
    }
  }

  @override
  Future<Either<DomainException, void>> deleteProduct(int productId) async {
    try {
      final response = await dio.delete(
        ApiClient.defaultBaseUrl +
            EndPoints.productDelete +
            productId.toString(),
      );
      if (response.statusCode == 204) {
        return Right(null);
      } else if (response.statusCode == 404) {
        return Left(UnknownException(message: '404 Error'));
      } else {
        return Left(UnknownException(message: response.statusMessage));
      }
    } catch (e) {
      return Left(NetworkException(message: e.toString()));
    }
  }
}
