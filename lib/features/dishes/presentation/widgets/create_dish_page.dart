import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/app/core/permission/permission_service.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_bloc.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_event.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_state.dart';
import 'package:image_picker/image_picker.dart';

class CreateDishPage extends StatefulWidget {
  const CreateDishPage({super.key});

  @override
  State<CreateDishPage> createState() => _CreateDishPageState();
}

class _CreateDishPageState extends State<CreateDishPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final permissionService = PermissionService();

  String imageUploadedPath = '';
  File? _pickedImage;
  Future<void> pickImage() async {
    if (await permissionService.requestPhotosPermission()) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DishBloc, DishState>(
      listener: (context, state) {
        if (state is CreateDishSuccess) {
          // hiện snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)), // "Success create"
          );

          // clear form
          _nameController.clear();
          _descriptionController.clear();
          _noteController.clear();
          _quantityController.clear();
          _priceController.clear();
          setState(() {
            _pickedImage = null; // xoá ảnh đã chọn
          });
        } else if (state is CreateDishFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thêm món thất bại: ${state.error.message}'),
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên món'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nhập tên món' : null,
              ),
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
                maxLines: 2,
              ),
              // Note
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
                maxLines: 2,
              ),
              // Quantity
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Số lượng'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // chỉ cho nhập số
                ],
              ),
              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Giá'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  // cho phép số + 1 dấu chấm thập phân
                ],
              ),
              const SizedBox(height: 12),
              // Image picker
              Row(
                children: [
                  _pickedImage != null
                      ? Image.file(
                          _pickedImage!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image),
                        ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage();
                    },
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text('Chọn ảnh'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Check validate form
                  if (_formKey.currentState!.validate()) {
                    if (_pickedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng chọn ảnh')),
                      );
                      return;
                    }

                    final Uint8List data = await _pickedImage!.readAsBytes();
                    final dishEntity = DishEntity(
                      id: null,
                      name: _nameController.text.trim(),
                      imageURL: '', // để trống vì sẽ cập nhật sau khi upload
                      description: _descriptionController.text.trim(),
                      note: _noteController.text.trim(),
                      quantity: int.tryParse(_quantityController.text) ?? 0,
                      price: double.tryParse(_priceController.text) ?? 0,
                    );

                    context.read<DishBloc>().add(
                      CreateDishEvent(data, dishEntity),
                    );
                  }
                },
                child: const Text('Thêm món'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
