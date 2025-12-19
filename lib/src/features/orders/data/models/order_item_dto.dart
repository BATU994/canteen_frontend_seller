import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_dto.freezed.dart';
part 'order_item_dto.g.dart';

@freezed
class OrderItemDto with _$OrderItemDto {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OrderItemDto({
    required int productId,
    required String name,
    required int quantity,
    required int price,
  }) = _OrderItemDto;

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);
}
