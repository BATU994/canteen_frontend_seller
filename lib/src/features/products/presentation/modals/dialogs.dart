import 'package:canteen_frontend_seller/src/core/const/color.dart';
import 'package:canteen_frontend_seller/src/features/products/presentation/bloc/product_manage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductDialogs {
  static Future<void> showPriceDialog({
    required BuildContext context,
    required int currentPrice,
    required int productId,
    required Bloc bloc,
  }) async {
    final TextEditingController controller = TextEditingController(
      text: currentPrice.toString(),
    );

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Изменить цену',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Новая цена',
                    prefixText: '₸',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Отмена',
                        color: mainColor,
                        onTap: () => dialogContext.pop(),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        label: 'Сохранить',
                        color: Colors.green,
                        onTap: () {
                          final newPrice = int.tryParse(controller.text);
                          if (newPrice != null) {
                            bloc.add(UpdateProductPrice(productId, newPrice));
                            dialogContext.pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showQuantityDialog({
    required BuildContext context,
    required int currentQuantity,
    required int productId,
    required Bloc bloc,
  }) async {
    final TextEditingController controller = TextEditingController(
      text: currentQuantity.toString(),
    );

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Изменить количество',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Новое количество',
                    suffixText: 'шт.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Отмена',
                        color: mainColor,
                        onTap: () => dialogContext.pop(),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        label: 'Сохранить',
                        color: Colors.green,
                        onTap: () {
                          final newQuantity = int.tryParse(controller.text);
                          if (newQuantity != null) {
                            bloc.add(
                              UpdateProductQuantity(productId, newQuantity),
                            );
                            dialogContext.pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required int productId,
    required Bloc bloc,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Вы уверены?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Это действие удалит продукт и невозвратимо',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Отмена',
                        color: mainColor,
                        onTap: () => dialogContext.pop(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        label: 'Удалить',
                        color: Colors.red,
                        onTap: () {
                          bloc.add(ProductDeleteEvent(productId));
                          dialogContext.pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showEditProductDialog({
    required BuildContext context,
    required int productId,
    required String currentName,
    required int currentQuantity,
    required int currentPrice,
    required String currentProdType,
    required Bloc bloc,
  }) async {
    final nameController = TextEditingController(text: currentName);
    final quantityController = TextEditingController(
      text: currentQuantity.toString(),
    );
    final priceController = TextEditingController(
      text: currentPrice.toString(),
    );

    String selectedProdType = currentProdType;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Редактировать продукт',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.maxFinite,
                        height: 60,
                        child: _ActionButton(
                          label: 'Удалить продукт',
                          color: mainColor,
                          onTap: () {
                            dialogContext.pop();
                            showDeleteConfirmationDialog(
                              context: context,
                              productId: productId,
                              bloc: bloc,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Название',
                          border: OutlineInputBorder(),
                          focusColor: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Количество',
                          suffixText: 'шт.',
                          border: OutlineInputBorder(),
                          focusColor: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Цена',
                          prefixText: '₸',
                          border: OutlineInputBorder(),
                          focusColor: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedProdType.isEmpty
                            ? null
                            : selectedProdType,
                        decoration: InputDecoration(
                          hintText: 'Выберите тип товара',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'foods', child: Text('Еда')),
                          DropdownMenuItem(
                            value: 'drinks',
                            child: Text('Напитки'),
                          ),
                          DropdownMenuItem(
                            value: 'deserts',
                            child: Text('Десерты'),
                          ),
                          DropdownMenuItem(
                            value: 'others',
                            child: Text('Прочее'),
                          ),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            selectedProdType = value ?? '';
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              label: 'Отмена',
                              color: mainColor,
                              onTap: () => dialogContext.pop(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ActionButton(
                              label: 'Сохранить',
                              color: Colors.green,
                              onTap: () {
                                final name = nameController.text.trim();
                                final quantity = int.tryParse(
                                  quantityController.text,
                                );
                                final price = int.tryParse(
                                  priceController.text,
                                );

                                if (name.isEmpty ||
                                    selectedProdType.isEmpty ||
                                    quantity == null ||
                                    price == null) {
                                  return;
                                }

                                bloc.add(
                                  EditProductDetails(
                                    productId,
                                    name,
                                    quantity,
                                    price,
                                    selectedProdType,
                                  ),
                                );

                                dialogContext.pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
