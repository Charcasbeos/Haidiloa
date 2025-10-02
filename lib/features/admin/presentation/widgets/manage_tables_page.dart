import 'package:flutter/material.dart';

enum TableStatus { empty, ordered, served, paymentRequested }

class TableEntity {
  final int number;
  final TableStatus status;

  TableEntity({required this.number, required this.status});
}

class ManageTablesPage extends StatelessWidget {
  final int? bookingId; // nếu null => khách ngoài
  final bool? noBooking;
  const ManageTablesPage({super.key, this.bookingId, this.noBooking});

  Color _getColorForStatus(TableStatus status) {
    switch (status) {
      case TableStatus.empty:
        return Colors.green; // bàn trống
      case TableStatus.ordered:
        return Colors.yellow[700]!; // đã gọi món
      case TableStatus.served:
        return Colors.blue; // đã lên đủ món
      case TableStatus.paymentRequested:
        return Colors.red; // yêu cầu thanh toán
    }
  }

  @override
  Widget build(BuildContext context) {
    // ví dụ dữ liệu bàn
    final List<TableEntity> tables = List.generate(15, (index) {
      if (index % 4 == 0) {
        return TableEntity(number: index + 1, status: TableStatus.empty);
      } else if (index % 4 == 1) {
        return TableEntity(number: index + 1, status: TableStatus.ordered);
      } else if (index % 4 == 2) {
        return TableEntity(number: index + 1, status: TableStatus.served);
      } else {
        return TableEntity(
          number: index + 1,
          status: TableStatus.paymentRequested,
        );
      }
    });

    return Scaffold(
      appBar: bookingId != null || noBooking != null
          ? AppBar(
              backgroundColor: const Color(0xfffcf4db),
              title: const Text(
                "Table",
                style: TextStyle(
                  color: Color(0xffdc0405),
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              elevation: 0,
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  final table = tables[index];
                  final color = _getColorForStatus(table.status);

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      if (table.status != TableStatus.empty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Bàn ${table.number} đang phục vụ, vui lòng chọn bàn khác.',
                            ),
                          ),
                        );
                        return;
                      }

                      // Bàn trống
                      if (bookingId != null || noBooking == true) {
                        // khách có booking: hỏi xác nhận
                        final confirm = await _showConfirmDialog(
                          context,
                          table.number,
                        );
                        if (confirm == true) {
                          Navigator.pop(context, table.number); // trả tableId
                        }
                      } else {
                        // khách ngoài: hỏi số điện thoại
                        final phone = await _showPhoneDialog(context);
                        if (phone != null && phone.isNotEmpty) {
                          Navigator.pop(context, {
                            'tableId': table.number,
                            'phone': phone,
                          });
                        }
                      }
                    },
                    child: Card(
                      color: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.table_restaurant,
                              size: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bàn ${table.number}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // chú thích
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildLegendItem(Colors.green, 'Bàn trống'),
                _buildLegendItem(Colors.yellow[700]!, 'Đã gọi món'),
                _buildLegendItem(Colors.blue, 'Đã lên đủ món'),
                _buildLegendItem(Colors.red, 'Yêu cầu thanh toán'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black26),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, int tableNumber) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận chọn bàn $tableNumber?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showPhoneDialog(BuildContext context) {
    // String phone = '';
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nhập số điện thoại khách'),
          content: TextField(
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: 'Số điện thoại'),
            // onChanged: (value) => phone = value,
          ),
          actions: [
            // TextButton(
            //   onPressed: () => Navigator.pop(context),
            //   child: const Text('Hủy'),
            // ),
            // ElevatedButton(
            //   onPressed: () => Navigator.pop(context, phone),
            //   child: const Text('Xác nhận'),
            // ),
          ],
        );
      },
    );
  }
}
