// domain/usecase/request_payment_usecase.dart
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/bills/domain/repositories/bill_repository.dart';

class GetBillsUsecase {
  final BillRepository repository; // repo của bill

  GetBillsUsecase(this.repository);

  Future<DataState<List<BillEntity>>> call({void params}) async {
    return await repository.getBills();
  }
}
