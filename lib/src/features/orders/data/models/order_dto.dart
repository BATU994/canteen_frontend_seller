import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_item_dto.dart';

part 'order_dto.freezed.dart';
part 'order_dto.g.dart';

@freezed
class OrderDto with _$OrderDto {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OrderDto({
    required int id,
    required int userId,
    required int price,
    required String userName,
    required String code,
    required List<OrderItemDto> items,
    required String comment,
    required String timestamp,
    required String status,
  }) = _OrderDto;

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);
}
