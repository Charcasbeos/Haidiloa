import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/features/admin/presentation/widgets/manage_tables_page.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth_event.dart';
import 'package:haidiloa/features/bills/presentation/pages/bill_page.dart';
import 'package:haidiloa/features/bookings/presentation/pages/create_booking_page.dart';
import 'package:haidiloa/features/dishes/presentation/pages/list_dishes_page.dart';
import 'package:haidiloa/features/user/presentation/bloc/user_bloc.dart';
import 'package:haidiloa/features/user/presentation/bloc/user_event.dart';
import 'package:haidiloa/features/user/presentation/bloc/user_state.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ScrollController _bookingController = ScrollController();
  final ScrollController _billController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(String status) {
      print(status);
      switch (status) {
        case 'Pending':
          return Colors.orange;
        case 'Approved':
          return Colors.green;
        case 'Checkin':
          return Colors.blue;
        case 'Checkout':
          return Colors.indigoAccent;
        case 'Reject':
          return Colors.red;
        case 'Missed':
          return Colors.grey;
        default:
          return Colors.black;
      }
    }

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          print(state.tableId!);
          final user = state.user;
          final bookings = state.bookings;
          final bills = state.bills;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xfffcf4db),
              title: const Text(
                "Haidiloa",
                style: TextStyle(
                  color: Color(0xffdc0405),
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Color(0xffdc0405)),
                  onPressed: () async {
                    // Kiem tra neu co bill chua thanh toan xong thi ko cho logout
                    // lọc các bill của hôm nay và chưa thanh toán
                    final unpaidBillsToday = bills.where((b) {
                      final isUnpaid =
                          !b.paymented; // hoặc b.paymented == false
                      return isUnpaid;
                    }).toList();

                    if (unpaidBillsToday.isNotEmpty) {
                      // có hóa đơn chưa thanh toán -> thông báo & không logout
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Bạn còn hóa đơn chưa thanh toán, không thể logout.',
                          ),
                        ),
                      );
                      return;
                    }
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
                      // Nếu bạn có ClearUserEvent để reset UserBloc về Initial:
                      context.read<UserBloc>().add(ClearUserEvent());
                      // gửi sự kiện logout
                      context.read<AuthBloc>().add(SignOutEvent());
                    }
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header user info
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xffdc0405),
                        child: Icon(
                          Icons.account_circle,
                          size: 40,
                          color: Color(0xfffcf4db),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Point: ${user.point}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: const Icon(
                            Icons.book_online_outlined,
                            size: 24,
                            color: Color(0xffdc0405),
                          ),

                          label: const Text(
                            'Booking',
                            style: TextStyle(color: Color(0xffdc0405)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreateBookingPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 24,
                            color: Color(0xffdc0405),
                          ),
                          label: const Text(
                            'Order',
                            style: TextStyle(color: Color(0xffdc0405)),
                          ),
                          onPressed: () async {
                            if (state.tableId == -1) {
                              final tableId = await Navigator.push<int>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ManageTablesPage(noBooking: true),
                                ),
                              );

                              if (tableId != null) {
                                print(
                                  "Sau khi chon ban : " + tableId.toString(),
                                );
                                // update UserLoaded
                                context.read<UserBloc>().add(
                                  UpdateTableIdUserEvent(tableId),
                                );
                              }
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ListDishesPage(tableId: state.tableId!),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // list bookings
                  const Text(
                    'Bookings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  bookings.isEmpty
                      ? const Center(child: Text("No booking."))
                      : SizedBox(
                          height:
                              3 * 70, // mỗi item khoảng 70px, hiển thị 3 item
                          child: Scrollbar(
                            controller: _bookingController,
                            thumbVisibility: true,
                            child: ListView.builder(
                              controller: _bookingController,

                              itemCount: bookings.length,
                              itemBuilder: (context, index) {
                                final b = bookings[index];
                                print(b.toString());
                                return Card(
                                  shadowColor: getStatusColor(b.status),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    leading: const Icon(Icons.event),
                                    title: Text(
                                      '${DateFormat('HH:mm dd/MM').format(b.time)} - ${b.persons} ${b.persons == 1 ? 'person' : 'persons'}\nNote: ${b.note ?? ""}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    subtitle: Text(
                                      'Status: ${b.status}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: getStatusColor(b.status),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () {
                                      // xử lý khi chọn booking
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),

                  // list bills
                  const Text(
                    'Receipts',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  bills.isEmpty
                      ? const Center(child: Text("No receipt."))
                      : SizedBox(
                          height:
                              3 * 70, // mỗi item khoảng 70px, hiển thị 3 item
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: _billController,
                            child: ListView.builder(
                              controller: _billController,

                              itemCount: bills.length,
                              itemBuilder: (context, index) {
                                final bill = bills[index];
                                return Card(
                                  shadowColor: bill.paymented
                                      ? Colors.green
                                      : bill.requestPayment
                                      ? Colors.orange
                                      : Colors.red,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    leading: Icon(
                                      Icons.receipt_long,
                                      color: bill.paymented
                                          ? Colors.green
                                          : bill.requestPayment
                                          ? Colors.orange
                                          : Colors.red,
                                    ),
                                    title: Text(
                                      'Bill ${bill.id} - Table: ${bill.tableId}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Date: ${DateFormat('dd/MM/yyyy').format(bill.createdAt)}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          'Status: ${bill.paymented
                                              ? 'Paymented'
                                              : bill.requestPayment
                                              ? 'Requested'
                                              : 'Pending'}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: bill.paymented
                                                ? Colors.green
                                                : bill.requestPayment
                                                ? Colors.orange
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      NumberFormat(
                                        "#,##0",
                                        "vi_VN",
                                      ).format(bill.total),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              BillPage(billId: bill.id),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(body: Text("No data"));
        }
      },
    );
  }
}
