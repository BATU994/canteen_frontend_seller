// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderDtoImpl _$$OrderDtoImplFromJson(Map<String, dynamic> json) =>
    _$OrderDtoImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      userName: json['user_name'] as String,
      code: json['code'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      comment: json['comment'] as String,
      timestamp: json['timestamp'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$OrderDtoImplToJson(_$OrderDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'price': instance.price,
      'user_name': instance.userName,
      'code': instance.code,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'comment': instance.comment,
      'timestamp': instance.timestamp,
      'status': instance.status,
    };
