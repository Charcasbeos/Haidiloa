// domain/usecase/request_payment_usecase.dart
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bills/domain/repositories/bill_repository.dart';
import 'package:haidiloa/features/bills/domain/usecase/params/request_payment_params.dart';

class RequestPaymentUsecase {
  final BillRepository repository; // repo của bill

  RequestPaymentUsecase(this.repository);

  Future<DataState<void>> call(RequestPaymentParams params) async {
    return await repository.requestPayment(
      billId: params.billId,
      total: params.total,
    );
  }
}
