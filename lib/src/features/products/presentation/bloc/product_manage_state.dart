part of 'product_manage_bloc.dart';

abstract class ProductManageState {}

class ProductManageInitial extends ProductManageState {}

class ProductManageLoading extends ProductManageState {}

class ProductsLoaded extends ProductManageState {
  final List<ProductDto> products;

  ProductsLoaded(this.products);
}

class ProductManageSuccess extends ProductManageState {
  final String message;

  ProductManageSuccess(this.message);
}

class ProductManageError extends ProductManageState {
  final DomainException error;

  ProductManageError(this.error);
}

class ProductPosted extends ProductManageState {}