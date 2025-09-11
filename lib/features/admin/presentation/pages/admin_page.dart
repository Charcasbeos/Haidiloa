import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/features/admin/presentation/widgets/manage_dishes_page.dart';
import 'package:haidiloa/features/admin/presentation/widgets/manage_orders_page.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_state.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // List widget manage
  final List<Widget> _pages = const [ManageDishesPage(), ManageOrdersPage()];

  int _selectedIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // đóng drawer sau khi chọn
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xfffcf4db)),
        backgroundColor: Color(0xffdc0405),
        title: Text(
          style: TextStyle(color: Color(0xfffcf4db)),
          _selectedIndex == 0
              ? 'Manage Dishes'
              : _selectedIndex == 1
              ? 'Manage Orders'
              : 'Manage',
        ),
        // Nút hamburger tự động hiển thị khi có drawer
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
                ListTile(
                  leading: const Icon(Icons.fastfood),
                  title: const Text('Dishes'),
                  selectedColor: Color(0xffdc0405),
                  selected: _selectedIndex == 0,
                  onTap: () => _selectPage(0),
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  selectedColor: Color(0xffdc0405),
                  title: const Text('Orders'),
                  selected: _selectedIndex == 1,
                  onTap: () => _selectPage(1),
                ),
                ListTile(
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Logout'),
                  selected: _selectedIndex == 2,
                  onTap: () => context.read<AuthBloc>().add(SignOutEvent()),
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
          // Hiển thị trang quản lý
          return _pages[_selectedIndex];
        },
      ),
    );
  }
}
