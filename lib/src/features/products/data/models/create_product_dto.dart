import 'dart:typed_data';

import 'package:dio/dio.dart';

class CreateProductRequest {
  final String name;
  final int quantity;
  final int price;
  final String prodType;
  final Uint8List imageBytes;

  CreateProductRequest({
    required this.name,
    required this.quantity,
    required this.price,
    required this.prodType,
    required this.imageBytes,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'name': name,
      'quantity': quantity,
      'price': price,
      'prod_type': prodType,
      'image': MultipartFile.fromBytes(
        imageBytes,
        filename: 'item.jpg',
      ),
    });
  }
}