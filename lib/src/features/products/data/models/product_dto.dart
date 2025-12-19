import 'package:canteen_frontend_seller/src/features/products/domain/entity/product_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_dto.freezed.dart';
part 'product_dto.g.dart';

@freezed
class ProductDto with _$ProductDto {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ProductDto({
    required int id,
    required String name,
    required int quantity,
    required int price,
    required String prodType,
    required String imagePath,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  const ProductDto._();
  ProductEntity toEntity() => ProductEntity(
    id: id,
    name: name,
    quantity: quantity,
    price: price,
    prodType: prodType,
    imagePath: imagePath,
  );
}
