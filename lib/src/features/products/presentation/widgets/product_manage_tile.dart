import 'package:canteen_frontend_seller/src/core/api/adress/api_client.dart';
import 'package:canteen_frontend_seller/src/features/products/data/models/product_dto.dart';
import 'package:canteen_frontend_seller/src/features/products/presentation/bloc/product_manage_bloc.dart';
import 'package:canteen_frontend_seller/src/features/products/presentation/modals/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductManageTile extends StatelessWidget {
  final ProductDto product;
  final ProductManageBloc bloc;

  const ProductManageTile({
    super.key,
    required this.product,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductManageBloc, ProductManageState>(
      bloc: bloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: product.imagePath.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  ApiClient.defaultBaseUrl + product.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.grey[500],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  'IMAGE',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Количество:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      '${product.quantity}шт.',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Цена:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      '₸${product.price.toInt()}',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.attach_money,
                          label: 'Цена',
                          color: Colors.green,
                          onTap: () => ProductDialogs.showPriceDialog(
                            context: context,
                            currentPrice: product.price,
                            productId: product.id,
                            bloc: bloc,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.download,
                          label: 'Число',
                          color: Colors.blue,
                          onTap: () => ProductDialogs.showQuantityDialog(
                            context: context,
                            currentQuantity: product.quantity,
                            productId: product.id,
                            bloc: bloc,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.edit,
                          label: 'Другое',
                          color: Colors.orange,
                          onTap: () {
                            ProductDialogs.showEditProductDialog(
                              context: context,
                              productId: product.id,
                              currentName: product.name,
                              currentQuantity: product.quantity,
                              currentPrice: product.price,
                              currentProdType: product.prodType,
                              bloc: bloc,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (state is ProductManageLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: LinearProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
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
              Icon(icon, color: Colors.white, size: 24),
              SizedBox(width: 8),
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
