import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/bills/domain/repositories/bill_repository.dart';

class GetBillsByUserIdUsecase
    implements Usecase<DataState<List<BillEntity>>, String> {
  final BillRepository _billRepository;
  GetBillsByUserIdUsecase(this._billRepository);

  @override
  Future<DataState<List<BillEntity>>> call({required String params}) {
    return _billRepository.getBillsByUserId(userId: params);
  }
}
