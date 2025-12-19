import 'package:canteen_frontend_seller/src/core/const/color.dart';
import 'package:canteen_frontend_seller/src/core/enums/filter.dart';
import 'package:canteen_frontend_seller/src/core/routers/routes.dart';
import 'package:canteen_frontend_seller/src/core/service/injectable/get_it.dart';
import 'package:canteen_frontend_seller/src/features/products/presentation/bloc/product_manage_bloc.dart';
import 'package:canteen_frontend_seller/src/features/products/presentation/widgets/custom_picker.dart';
import 'package:canteen_frontend_seller/src/features/products/presentation/widgets/product_manage_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductManagePage extends StatefulWidget {
  const ProductManagePage({super.key});

  @override
  State<ProductManagePage> createState() => _ProductManagePageState();
}

class _ProductManagePageState extends State<ProductManagePage> {
  late ProductManageBloc _productBloc;
  Filter selectedFilter = Filter.all;

  @override
  void initState() {
    super.initState();
    _productBloc = getIt<ProductManageBloc>();
    _productBloc.add(LoadAllProducts());
  }

  @override
  void dispose() {
    _productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Управление товарами')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: BlocConsumer<ProductManageBloc, ProductManageState>(
              bloc: _productBloc,
              listener: (context, state) {},
              builder: (context, state) {
                if (state is ProductsLoaded && state.products.isNotEmpty) {
                  final filteredList = selectedFilter == Filter.all
                      ? state.products
                      : state.products
                            .where((p) => p.prodType == selectedFilter.name)
                            .toList();
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        child: Picker(
                          onChanged: (filter) {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) => ProductManageTile(
                            product: filteredList[index],
                            bloc: _productBloc,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(color: subColor),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(Routes.createProd),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: subColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Выставить продукт',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
