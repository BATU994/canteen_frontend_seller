import 'package:bloc/bloc.dart';
import 'package:canteen_frontend_seller/src/core/exceptions/domain_exceptions.dart';
import 'package:canteen_frontend_seller/src/features/products/data/models/create_product_dto.dart';
import 'package:canteen_frontend_seller/src/features/products/data/models/product_dto.dart';
import 'package:canteen_frontend_seller/src/features/products/domain/repositories/i_product_remote.dart';
import 'package:meta/meta.dart';

part 'product_manage_event.dart';
part 'product_manage_state.dart';

class ProductManageBloc extends Bloc<ProductManageEvent, ProductManageState> {
  final IProductRemote _productRepository;

  ProductManageBloc(this._productRepository) : super(ProductManageInitial()) {
    on<LoadAllProducts>(_onLoadProducts);
    on<UpdateProductPrice>(_onUpdatePrice);
    on<UpdateProductQuantity>(_onUpdateQuantity);
    on<EditProductDetails>(_onEditDetails);
    on<PostProductEvent>(_onPostProduct);
    on<ProductDeleteEvent>(_onDeleteProduct);
  }

  Future<void> _onPostProduct(
    PostProductEvent event,
    Emitter<ProductManageState> emit,
  ) async {
    emit(ProductManageLoading());
    try {
      final response = await _productRepository.createProduct(event.product);
      response.fold((error) => emit(ProductManageError(error)), (_) {
        emit(ProductPosted());
      });
    } catch (e) {}
  }

  Future<void> _onLoadProducts(
    LoadAllProducts event,
    Emitter<ProductManageState> emit,
  ) async {
    emit(ProductManageLoading());

    try {
      final response = await _productRepository.getAllProducts();

      response.fold(
        (error) => emit(ProductManageError(error)),
        (products) => emit(ProductsLoaded(products)),
      );
    } catch (e) {
      emit(ProductManageError(UnknownError()));
    }
  }

  Future<void> _onUpdatePrice(
    UpdateProductPrice event,
    Emitter<ProductManageState> emit,
  ) async {
    emit(ProductManageLoading());

    try {
      final response = await _productRepository.patchProductPrice(
        event.productId,
        event.newPrice,
      );

      response.fold((error) => emit(ProductManageError(error)), (_) {
        emit(ProductManageSuccess('Цена обновлена успешно'));
        add(LoadAllProducts());
      });
    } catch (e) {
      emit(ProductManageError(UnknownError()));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateProductQuantity event,
    Emitter<ProductManageState> emit,
  ) async {
    emit(ProductManageLoading());

    try {
      final response = await _productRepository.patchProductQuantity(
        event.productId,
        event.newQuantity,
      );

      response.fold((error) => emit(ProductManageError(error)), (_) {
        emit(ProductManageSuccess('Количество обновлено успешно'));
        add(LoadAllProducts());
      });
    } catch (e) {
      emit(ProductManageError(UnknownError()));
    }
  }

  Future<void> _onEditDetails(
    EditProductDetails event,
    Emitter<ProductManageState> emit,
  ) async {
    emit(ProductManageLoading());

    try {
      final response = await _productRepository.patchProductOther(
        event.productId,
        event.name,
        event.quantity,
        event.price,
        event.selectedProdType,
      );

      response.fold((error) => emit(ProductManageError(error)), (_) {
        emit(ProductManageSuccess('Обновлено успешно'));
        add(LoadAllProducts());
      });
    } catch (e) {
      emit(ProductManageError(UnknownError()));
    }
  }

  Future<void> _onDeleteProduct(
    ProductDeleteEvent event,
    Emitter<ProductManageState> emit,
  ) async {
    emit(ProductManageLoading());
    try {
      final response = await _productRepository.deleteProduct(event.productId);

      response.fold((error) => emit(ProductManageError(error)), (_) {
        emit(ProductManageSuccess('Удалено успешно'));
        add(LoadAllProducts());
      });
    } catch (e) {
      emit(ProductManageError(UnknownError()));
    }
  }
}