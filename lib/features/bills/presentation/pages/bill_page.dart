import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';
import 'package:haidiloa/features/orders/presentation/bloc/order_bloc.dart';
import 'package:haidiloa/features/orders/presentation/bloc/order_event.dart';
import 'package:intl/intl.dart';
import 'package:haidiloa/features/bills/presentation/bloc/bill_bloc.dart';
import 'package:haidiloa/features/bills/presentation/bloc/bill_event.dart';
import 'package:haidiloa/features/bills/presentation/bloc/bill_state.dart';

class BillPage extends StatefulWidget {
  final int? billId;
  const BillPage({Key? key, this.billId}) : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  double? total;
  @override
  void initState() {
    super.initState();
    if (widget.billId != null) {
      context.read<BillBloc>().add(LoadBillOrdersEvent(widget.billId!));
    }
  }

  Future<void> _submitBill(int billId, double total) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn yêu cầu thanh toán không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      context.read<BillBloc>().add(RequestPaymentEvent(billId, total));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BillBloc, BillState>(
      listener: (context, state) {
        if (state is BillFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi: ${state.message}')));
        }
        if (state is BillRequestPayment) {
          // backend đã update thành công, lúc này mới update UI ở HomePage
          context.read<OrderBloc>().add(BillRequestedPaymentEvent(true));
        }
      },
      builder: (context, state) {
        BillEntity? bill;
        List<OrderEntity> orders = [];
        bool requestPayment = false;
        bool payment = false;
        // Thêm biến loading
        bool loading = false;

        if (state is BillLoading) {
          loading = true; // đang loading dữ liệu
        }
        if (state is BillLoaded) {
          bill = state.bill;
          orders = state.orders;
          requestPayment = bill.requestPayment;
          payment = bill.paymented;
        } else if (state is BillRequestPayment) {
          bill = state.bill;
          orders = state.orders;
          requestPayment = bill.requestPayment;
          payment = bill.paymented;
        }
        total = orders.fold<double>(
          0,
          (sum, e) => sum + (e.price * e.quantity),
        );

        // xác định text và onPressed
        String buttonText = 'Thanh toán';
        VoidCallback? onPressed;

        if (payment == true) {
          buttonText = 'Đã thanh toán';
          onPressed = null;
        } else if (requestPayment == true) {
          buttonText = 'Đang chờ thanh toán';
          onPressed = null;
        } else {
          buttonText = 'Thanh toán';
          onPressed = () async => _submitBill(widget.billId!, total!);
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xfffcf4db),
            title: const Text(
              "Receipt",
              style: TextStyle(
                color: Color(0xffdc0405),
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : orders.isEmpty
              ? const Center(child: Text('Chưa có đặt món'))
              : ListView(
                  children: [
                    ...orders.map(
                      (order) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            order.imageURL,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          order.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${order.quantity} × ${NumberFormat("#,##0", "vi_VN").format(order.price)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    DateFormat(
                                      "HH:mm dd/MM/yyyy",
                                    ).format(order.createdAt!),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    order.served
                                        ? Icons.check_circle
                                        : Icons.access_time,
                                    color: order.served
                                        ? Colors.green
                                        : Colors.orange,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: Text(
                          NumberFormat(
                            "#,##0",
                            "vi_VN",
                          ).format(order.price * order.quantity),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total (VND)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            NumberFormat("#,##0", "vi_VN").format(total),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: loading
              ? Text("")
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ButtonStyle(
                      // sử dụng MaterialStateProperty.resolveWith để set màu
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (payment == true)
                          return Colors.green; // đã thanh toán => xanh
                        if (requestPayment == true)
                          return Colors.orange; // đang chờ => cam
                        return Color(0xffdc0405); // mặc định
                      }),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: 16,
                        // Nếu đã thanh toán thì chữ trắng để nổi bật
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
