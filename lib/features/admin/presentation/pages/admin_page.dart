import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/features/admin/presentation/widgets/manage_bills_page.dart';
import 'package:haidiloa/features/admin/presentation/widgets/manage_tables_page.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth_event.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth_state.dart';
import 'package:haidiloa/features/admin/presentation/widgets/manage_booking_page.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/admin/presentation/widgets/manage_list_dishes_page.dart';
import 'package:haidiloa/features/dishes/presentation/widgets/create_dish_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  DishEntity? selectedDish;
  bool isCreatingDish = false;

  // List widget manage
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      // ManageDishesPage(),
      ManageListDishesPage(
        onEdit: (dish) {
          setState(() {
            selectedDish = dish; // gán dish -> sẽ show CreateDishPage
          });
        },
        onCreate: () {
          setState(() {
            selectedDish = null;
            isCreatingDish = true; // chuyển sang chế độ thêm món
          });
        },
      ),
      ManageBookingPage(),
      ManageTablesPage(),
      ManageBillsPage(),
    ]);
  }

  int _selectedIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // đóng drawer sau khi chọn
  }

  @override
  Widget build(BuildContext context) {
    // Nếu đang trong trạng thái sửa món → hiển thị CreateDishPage luôn
    if (selectedDish != null && isCreatingDish == false) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xfffcf4db)),
          backgroundColor: const Color(0xffdc0405),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                selectedDish = null; // quay về danh sách
              });
            },
          ),
          title: const Text(
            'Update dish',
            style: TextStyle(color: Color(0xfffcf4db)),
          ),
        ),
        body: CreateDishPage(
          dishUpdate: selectedDish!,
          onDone: () {
            setState(() {
              selectedDish = null; // trở lại danh sách
            });
          },
        ), // trang sửa
      );
    }
    // Trang thai theo mon
    if (isCreatingDish && selectedDish == null) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xfffcf4db)),
          backgroundColor: const Color(0xffdc0405),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                selectedDish = null;
                isCreatingDish = false; // quay về danh sách
              });
            },
          ),
          title: const Text(
            'Create dish',
            style: TextStyle(color: Color(0xfffcf4db)),
          ),
        ),
        body: CreateDishPage(
          dishUpdate: selectedDish,
          onDone: () {
            setState(() {
              selectedDish = null;
              isCreatingDish = false; // trở lại danh sách
            });
          },
        ), // trang sửa
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xfffcf4db)),
        backgroundColor: Color(0xffdc0405),
        leading: selectedDish != null
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedDish = null; // quay về list dishes
                  });
                },
              )
            : null,
        title: Text(
          style: TextStyle(color: Color(0xfffcf4db)),
          selectedDish != null
              ? 'Sửa món'
              : (_selectedIndex == 0
                    ? 'Manage Dishes'
                    : _selectedIndex == 1
                    ? 'Manage Bookings'
                    : _selectedIndex == 2
                    ? 'Manage Tables'
                    : _selectedIndex == 3
                    ? 'Manage Bills'
                    : 'Manage'),
        ),
      ),

      drawer: Drawer(
        width: 200,
        child: Container(
          color: Color(0xfffcf4db),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xffdc0405)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Manage',
                      style: TextStyle(fontSize: 24, color: Color(0xfffcf4db)),
                    ),
                  ),
                ),
                // ListTile(
                //   leading: const Icon(Icons.fastfood),
                //   title: const Text('Dish'),
                //   selectedColor: Color(0xffdc0405),
                //   selected: _selectedIndex == 0,
                //   onTap: () => _selectPage(0),
                // ),
                ListTile(
                  leading: const Icon(Icons.fastfood),
                  title: const Text('List Dishes'),
                  selectedColor: Color(0xffdc0405),
                  selected: _selectedIndex == 0,
                  onTap: () => _selectPage(0),
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  selectedColor: Color(0xffdc0405),
                  title: const Text('List Bookings'),
                  selected: _selectedIndex == 1,
                  onTap: () => _selectPage(1),
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  selectedColor: Color(0xffdc0405),
                  title: const Text('List Tables'),
                  selected: _selectedIndex == 2,
                  onTap: () => _selectPage(2),
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  selectedColor: Color(0xffdc0405),
                  title: const Text('List Bills'),
                  selected: _selectedIndex == 3,
                  onTap: () => _selectPage(3),
                ),

                ListTile(
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Logout'),
                  selected: _selectedIndex == 4,
                  onTap: () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xác nhận'),
                        content: const Text(
                          'Bạn có chắc chắn muốn đăng xuất không?',
                        ),
                        actions: [
                          Align(
                            alignment: AlignmentGeometry.center,
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Hủy'),
                            ),
                          ),

                          Align(
                            alignment: AlignmentGeometry.center,

                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Đăng xuất'),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (shouldLogout == true) {
                      context.read<AuthBloc>().add(SignOutEvent());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthFailure) {
            return Center(
              child: Text(
                state.error.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          // hiển thị trang sửa
          return _pages[_selectedIndex];
        },
      ),
    );
  }
}
