import 'package:canteen_frontend_seller/src/core/const/color.dart';
import 'package:canteen_frontend_seller/src/core/routers/routes.dart';
import 'package:canteen_frontend_seller/src/features/products/data/models/create_product_dto.dart';
import 'package:canteen_frontend_seller/src/features/products/presentation/bloc/product_manage_bloc.dart';
import 'package:canteen_frontend_seller/src/features/products/presentation/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ProductCreatePage extends StatefulWidget {
  const ProductCreatePage({super.key});

  @override
  State<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _prodTypeController = TextEditingController();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _prodTypeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите источник изображения'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Камера'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Галерея'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать товар'),
        elevation: 0,
        leading: BackButton(onPressed: () => context.push(Routes.shop)),
      ),
      body: BlocConsumer<ProductManageBloc, ProductManageState>(
        listener: (context, state) {
          if (state is ProductPosted) {
            context.push(Routes.shop);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Опубликовано успешно'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: _imageBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                _imageBytes!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 50,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Нажмите, чтобы выбрать изображение',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextForm(
                    textController: _nameController,
                    hintText: 'Название товара',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите название товара';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextForm(
                    textController: _quantityController,
                    hintText: 'Количество',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите количество';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Пожалуйста, введите корректное число';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextForm(
                    textController: _priceController,
                    hintText: 'Цена',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите цену';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Пожалуйста, введите корректную цену';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Тип товара:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _prodTypeController.text.isEmpty
                        ? null
                        : _prodTypeController.text,
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
                      DropdownMenuItem(value: 'drinks', child: Text('Напитки')),
                      DropdownMenuItem(
                        value: 'deserts',
                        child: Text('Десерты'),
                      ),
                      DropdownMenuItem(value: 'others', child: Text('Прочее')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _prodTypeController.text = value ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, выберите тип товара';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProductManageBloc>().add(
                            PostProductEvent(
                              CreateProductRequest(
                                name: _nameController.text,
                                quantity: int.parse(_quantityController.text),
                                price: int.parse(_priceController.text),
                                prodType: _prodTypeController.text,
                                imageBytes: _imageBytes!,
                              ),
                            ),
                          );

                          context.read<ProductManageBloc>().add(
                            LoadAllProducts(),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: subColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Выставить товар',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
