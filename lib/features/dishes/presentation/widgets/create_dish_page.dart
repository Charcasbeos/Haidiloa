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
  final DishEntity? dishUpdate;
  final VoidCallback? onDone;

  const CreateDishPage({super.key, this.dishUpdate, this.onDone});

  @override
  State<CreateDishPage> createState() => _CreateDishPageState();
}

class _CreateDishPageState extends State<CreateDishPage> {
  DishEntity? dish;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final permissionService = PermissionService();
  String? _imageURL;
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

  // Update neu dish duoc truyen sang
  @override
  void initState() {
    super.initState();
    if (widget.dishUpdate != null) {
      dish = widget.dishUpdate!;
      _nameController.text = dish!.name;
      _descriptionController.text = dish!.description;
      _noteController.text = dish!.note;
      _quantityController.text = dish!.quantity.toString();
      _priceController.text = dish!.price.toString();
      _imageURL = dish!.imageURL;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Uint8List? data;
      if (_pickedImage != null) {
        data = await _pickedImage!.readAsBytes();
      }
      final dishEntity = DishEntity(
        id: dish?.id,
        name: _nameController.text.trim(),
        imageURL: dish != null && _pickedImage == null ? dish!.imageURL : '',
        description: _descriptionController.text.trim(),
        note: _noteController.text.trim(),
        quantity: int.tryParse(_quantityController.text) ?? 0,
        price: double.tryParse(_priceController.text) ?? 0,
      );
      if (dish == null) {
        if (data == null && _imageURL == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Bạn phải chọn ảnh')));
          return;
        }
        context.read<DishBloc>().add(CreateDishEvent(data!, dishEntity));
      } else {
        context.read<DishBloc>().add(UpdateDishEvent(data, dishEntity));
      }
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: BlocListener<DishBloc, DishState>(
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
            context.read<DishBloc>().add(GetListDishesEvent());

            // gọi callback để AdminPage set selectedDish = null
            widget.onDone?.call();
          } else if (state is CreateDishFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Thêm món thất bại: ${state.error.message}'),
              ),
            );
          }

          if (state is UpdateDishSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));

            context.read<DishBloc>().add(GetListDishesEvent());

            // gọi callback để AdminPage set selectedDish = null
            widget.onDone?.call();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(6),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      _nameController,
                      'Tên món',
                      'Nhập tên món',
                      _formKey,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      _descriptionController,
                      'Mô tả',
                      'Nhập mô tả món',
                      _formKey,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      _noteController,
                      'Ghi chú',
                      'Nhập ghi chú món',
                      _formKey,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            _quantityController,
                            'Số lượng',
                            'Nhập số lượng món',
                            _formKey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPriceField(
                            _priceController,
                            'Giá',
                            'Nhập giá món',
                            _formKey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildImagePicker(),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _submitForm,
                        icon: Icon(
                          widget.dishUpdate == null ? Icons.add : Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          widget.dishUpdate == null
                              ? 'Thêm món'
                              : 'Cập nhật món',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String error,
    GlobalKey<FormState> formKey, // truyền formKey vào
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) => value == null || value.isEmpty ? error : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: (_) {
      //   // validate lại form để cập nhật lỗi ngay khi gõ
      //   formKey.currentState?.validate();
      // },
    );
  }

  Widget _buildNumberField(
    TextEditingController controller,
    String label,
    String error,
    GlobalKey<FormState> formKey,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) => value == null || value.isEmpty ? error : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: (_) {
      //   // validate lại form để cập nhật lỗi ngay khi gõ
      //   formKey.currentState?.validate();
      // },
    );
  }

  Widget _buildPriceField(
    TextEditingController controller,
    String label,
    String error,
    GlobalKey<FormState> formKey,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) => value == null || value.isEmpty ? error : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: (_) {
      //   // validate lại form để cập nhật lỗi ngay khi gõ
      //   formKey.currentState?.validate();
      // },
    );
  }

  Widget _buildImagePicker() {
    return FormField<File>(
      validator: (value) {
        // Nếu chưa chọn ảnh và URL trống → lỗi
        if (_pickedImage == null && (_imageURL == null || _imageURL!.isEmpty)) {
          return 'Bạn phải chọn ảnh';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _pickedImage != null
                      ? Image.file(
                          _pickedImage!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : (_imageURL != null && _imageURL!.isNotEmpty)
                      ? Image.network(
                          _imageURL!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    await pickImage();
                    // validate lại ngay khi chọn ảnh
                    field.validate();
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Choose picture '),
                ),
              ],
            ),
            // 👇 phần lỗi nằm ngay dưới nút “Chọn ảnh”
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  field.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
