import 'package:canteen_frontend_seller/src/core/exceptions/domain_exceptions.dart';
import 'package:canteen_frontend_seller/src/features/products/data/models/create_product_dto.dart';
import 'package:canteen_frontend_seller/src/features/products/data/models/product_dto.dart';
import 'package:dartz/dartz.dart';

abstract interface class IProductRemote {
  Future<Either<DomainException, List<ProductDto>>> getAllProducts();
  Future<Either<DomainException, void>> patchProductPrice(
    int productId,
    int price,
  );
  Future<Either<DomainException, void>> patchProductQuantity(
    int productId,
    int quantity,
  );
  Future<Either<DomainException, void>> createProduct(
    CreateProductRequest product,
  );

  Future<Either<DomainException, void>> patchProductOther(
    int productId,
    String name,
    int quantity,
    int price,
    String selectedProdType,
  );

  Future<Either<DomainException, void>> deleteProduct(int productId);
}
