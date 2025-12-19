part of 'product_manage_bloc.dart';

@immutable
abstract class ProductManageEvent {}

class LoadAllProducts extends ProductManageEvent {}

class UpdateProductPrice extends ProductManageEvent {
  final int productId;
  final int newPrice;

  UpdateProductPrice(this.productId, this.newPrice);
}

class UpdateProductQuantity extends ProductManageEvent {
  final int productId;
  final int newQuantity;

  UpdateProductQuantity(this.productId, this.newQuantity);
}

class EditProductDetails extends ProductManageEvent {
  final int productId;
  final String name;
  final int quantity;
  final int price;
  final String selectedProdType;
  EditProductDetails(
    this.productId,
    this.name,
    this.quantity,
    this.price,
    this.selectedProdType,
  );
}

class PostProductEvent extends ProductManageEvent {
  final CreateProductRequest product;

  PostProductEvent(this.product);
}

class ProductDeleteEvent extends ProductManageEvent {
  final int productId;
  ProductDeleteEvent(this.productId);
}
