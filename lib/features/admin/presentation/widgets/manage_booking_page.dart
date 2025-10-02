import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/features/admin/presentation/widgets/manage_tables_page.dart';
// import 'package:haidiloa/features/bookings/presentation/pages/create_booking_page.dart';
import 'package:intl/intl.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';
import 'package:haidiloa/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:haidiloa/features/bookings/presentation/bloc/booking_event.dart';
import 'package:haidiloa/features/bookings/presentation/bloc/booking_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageBookingPage extends StatefulWidget {
  const ManageBookingPage({Key? key}) : super(key: key);

  @override
  State<ManageBookingPage> createState() => _ManageBookingPageState();
}

class _ManageBookingPageState extends State<ManageBookingPage> {
  DateTime selectedDate = DateTime.now();
  String selectedStatus = 'Pending';
  final List<String> statusList = [
    'Pending',
    'Approved',
    'Rejected',
    'Checkin',
    'Checkout',
    "Missed",
  ];

  RealtimeChannel? _bookingChannel;

  @override
  void initState() {
    super.initState();
    // Lấy danh sách ban đầu
    _loadBookings();
    // Đăng ký realtime Supabase
    _bookingChannel = Supabase.instance.client
        .channel('public:bookings')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bookings',
          callback: (payload) {
            // Khi có insert/update/delete -> reload
            _loadBookings();
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    // Hủy sub
    if (_bookingChannel != null) {
      Supabase.instance.client.removeChannel(_bookingChannel!);
    }
    super.dispose();
  }

  void _loadBookings() {
    context.read<BookingBloc>().add(
      LoadBookingsEvent(date: selectedDate, status: selectedStatus),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: () {
          //     // chuyển sang trang CreateBookingPage
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => BlocProvider.value(
          //           value: context.read<BookingBloc>(),
          //           child: const CreateBookingPage(),
          //         ),
          //       ),
          //     );
          //   },
          // ),
          // Filter
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Date Picker
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(selectedDate),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Status dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: statusList
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedStatus = value;
                      });
                      _loadBookings();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocConsumer<BookingBloc, BookingState>(
              listenWhen: (previous, current) =>
                  current is BookingSuccess || current is BookingFailure,
              listener: (context, state) {
                if (state is BookingSuccess) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is BookingFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: ${state.message}')),
                  );
                }
              },
              buildWhen: (previous, current) =>
                  current is BookingLoading ||
                  current is BookingLoaded ||
                  current is BookingFailure,
              builder: (context, state) {
                if (state is BookingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingLoaded) {
                  if (state.bookings.isEmpty) {
                    return const Center(child: Text('No booking'));
                  }
                  return ListView.builder(
                    itemCount: state.bookings.length,
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      return _buildBookingCard(booking);
                    },
                  );
                } else if (state is BookingFailure) {
                  return Center(child: Text('Lỗi: ${state.message}'));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BookingEntity booking) {
    // xây dựng nội dung subtitle từng dòng
    final buffer = StringBuffer();

    // luôn có giờ + số người
    buffer.writeln(
      '${DateFormat('HH:mm dd/MM').format(booking.time)} | ${booking.persons} người',
    );

    // ghi chú
    if (booking.note != null) {
      buffer.writeln(booking.note);
    }

    // lý do từ chối
    if (booking.rejectReason != null && booking.rejectReason!.isNotEmpty) {
      buffer.writeln('Từ chối: ${booking.rejectReason}');
    }

    // số bàn
    if (booking.tableId != -1) {
      buffer.writeln('Bàn số: ${booking.tableId}');
    }

    // khách không đến
    final normalizedStatus = booking.status
        .replaceAll('_', '')
        .replaceAll(' ', '')
        .toLowerCase();
    if (normalizedStatus == 'missed' || normalizedStatus == 'noshow') {
      buffer.writeln('Khách không đến');
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '${booking.name} - ${booking.phone}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            subtitle: Text(buffer.toString().trim()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: _actionIcons(booking),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _actionIcons(BookingEntity booking) {
    switch (booking.status.toLowerCase()) {
      case 'pending':
        return [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () {
              context.read<BookingBloc>().add(
                ApproveBookingEvent(booking.id, 'Approved'),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () async {
              final reason = await _showRejectDialog();
              if (reason != null) {
                context.read<BookingBloc>().add(
                  RejectBookingEvent(booking.id, reason, 'Rejected'),
                );
              }
            },
          ),
        ];

      case 'approved':
        return [
          IconButton(
            icon: const Icon(Icons.login, color: Colors.blue),
            onPressed: () async {
              // final tableId = await _showSelectTableDialog();
              // if (tableId != null) {
              //   context.read<BookingBloc>().add(
              //     CheckInBookingEvent(
              //       bookingId: booking.id,
              //       tableId: tableId,
              //       status: 'Checkin',
              //     ),
              //   );
              // }
              final tableId = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (_) => ManageTablesPage(bookingId: booking.id),
                ),
              );
              if (tableId != null) {
                // update booking
                context.read<BookingBloc>().add(
                  CheckInBookingEvent(
                    bookingId: booking.id,
                    tableId: tableId,
                    status: 'checked_in',
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.not_interested, color: Colors.orange),
            onPressed: () {
              context.read<BookingBloc>().add(
                MarkNoShowBookingEvent(booking.id, 'Missed'), // hoặc 'NoShow'
              );
            },
          ),
        ];

      case 'checkin': // nếu DB ghi kiểu này
        return [
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.grey),
            tooltip: 'Đã check-in',
            onPressed: null, // không cho thao tác nữa
          ),
        ];

      case 'missed':
      case 'noshow':
        return [
          IconButton(
            icon: const Icon(Icons.block, color: Colors.grey),
            tooltip: 'Khách vắng',
            onPressed: null,
          ),
        ];

      default:
        return [];
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
      _loadBookings();
    }
  }

  Future<String?> _showRejectDialog() async {
    String reason = '';
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nhập lý do từ chối'),
          content: TextField(
            onChanged: (value) => reason = value,
            decoration: const InputDecoration(hintText: 'Lý do'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, reason),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  // Future<int?> _showSelectTableDialog() async {
  //   int? tableId;
  //   return showDialog<int>(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Chọn bàn'),
  //         content: DropdownButtonFormField<int>(
  //           decoration: const InputDecoration(border: OutlineInputBorder()),
  //           value: tableId,
  //           items: List.generate(15, (i) {
  //             return DropdownMenuItem<int>(
  //               value: i + 1,
  //               child: Text('Bàn ${i + 1}'),
  //             );
  //           }),
  //           onChanged: (value) => tableId = value,
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Hủy'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () => Navigator.pop(context, tableId),
  //             child: const Text('Xác nhận'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
