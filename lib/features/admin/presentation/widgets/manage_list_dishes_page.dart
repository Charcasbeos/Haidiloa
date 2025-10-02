import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
// import 'package:haidiloa/features/admin/presentation/widgets/manage_dishes_page.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_bloc.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_event.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_state.dart';
// import 'package:haidiloa/features/dishes/presentation/widgets/create_dish_page.dart';

class ManageListDishesPage extends StatefulWidget {
  final void Function(DishEntity dish)? onEdit;
  final void Function()? onCreate;

  const ManageListDishesPage({super.key, this.onEdit, this.onCreate});

  @override
  State<ManageListDishesPage> createState() => _ManageListDishesPageState();
}

class _ManageListDishesPageState extends State<ManageListDishesPage> {
  @override
  void initState() {
    super.initState();
    context.read<DishBloc>().add(GetListDishesEvent());
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DishBloc, DishState>(
        builder: (context, state) {
          if (state is DishLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetListDishesSuccess) {
            final dishes = state.listDishesEntity;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: dishes.length,
                    itemBuilder: (context, index) {
                      final dish = dishes[index];
                      return _slidable(context, dish);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        widget
                            .onCreate!(); // gọi callback để AdminPage đổi body
                      },
                      icon: Icon(Icons.add, color: Colors.white),
                      label: Text(
                        'Create new dish',

                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is GetListDishesFailure) {
            return Center(child: Text('Lỗi: ${state.error.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _slidable(BuildContext context, DishEntity dish) {
    return Slidable(
      key: ValueKey(dish.id),
      // Xoá
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete this dish?'),
                  content: Text('Bạn có chắc muốn xoá "${dish.name}" không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Không'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Có'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                context.read<DishBloc>().add(DeleteDishEvent(dish.id!));
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Xoá',
          ),
        ],
      ),
      // Vuốt sang phải để sửa
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              if (widget.onEdit != null) {
                widget.onEdit!(dish); // gọi callback để AdminPage đổi body
              }
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Sửa',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: dish.imageURL.isNotEmpty
                    ? Image.network(
                        dish.imageURL,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.fastfood, size: 60),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${NumberFormat("#,##0", "vi_VN").format(dish.price)} VNĐ',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // thêm phần SL
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SL', // chữ hiển thị nhãn Số lượng
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${dish.quantity}', // số lượng thực tế
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
