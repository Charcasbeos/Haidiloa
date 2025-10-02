import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:haidiloa/features/bills/presentation/bloc/bill_bloc.dart';
import 'package:haidiloa/features/bills/presentation/bloc/bill_event.dart';
import 'package:haidiloa/features/bills/presentation/bloc/bill_state.dart';

class ManageBillsPage extends StatefulWidget {
  const ManageBillsPage({super.key});

  @override
  State<ManageBillsPage> createState() => _ManageBillsPageState();
}

class _ManageBillsPageState extends State<ManageBillsPage> {
  @override
  void initState() {
    super.initState();
    // Bắn event ngay khi trang được mở
    context.read<BillBloc>().add(GetBillsEvent());
  }

  Future<void> _confirmPayment(int billId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        // title: Center(child: const Text('Confirm')),
        content: const Text('Accept request payment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      context.read<BillBloc>().add(ConfirmPaymentEvent(billId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillBloc, BillState>(
      builder: (context, state) {
        if (state is BillLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BillsLoaded) {
          final bills = state.bills;
          print("aaa");
          return RefreshIndicator(
            onRefresh: () async {
              context.read<BillBloc>().add(GetBillsEvent());
            },
            child: ListView.builder(
              itemCount: bills.length,
              itemBuilder: (context, index) {
                final bill = bills[index];
                return ListTile(
                  leading: Icon(
                    bill.paymented ? Icons.check_circle : Icons.pending_actions,
                    color: bill.paymented
                        ? Colors.green
                        : bill.requestPayment
                        ? Colors.red
                        : Colors.orange,
                  ),
                  title: Text('Bill #${bill.id}'),
                  subtitle: Text(
                    'Total: ${NumberFormat("#,##0", "vi_VN").format(bill.total)} VNĐ  ${bill.paymented
                        ? "| Paid"
                        : bill.requestPayment
                        ? "Request"
                        : "| Waiting"}',
                  ),
                  trailing: !bill.paymented && bill.requestPayment
                      ? ElevatedButton(
                          onPressed: () {
                            _confirmPayment(bill.id!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffdc0405),
                          ),
                          child: Icon(Icons.check, color: Colors.white),
                        )
                      : null,
                  onTap: () {
                    // nếu muốn vào chi tiết bill
                  },
                );
              },
            ),
          );
        }
        if (state is BillFailure) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No data'));
      },
    );
  }
}
