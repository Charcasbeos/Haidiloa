import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bills/domain/repositories/bill_repository.dart';
import 'package:haidiloa/features/bills/domain/usecase/params/create_bill_params.dart';

import '../../../../app/core/usecases/base_usecase.dart';

class CreateBillUsecase implements Usecase<DataState<void>, CreateBillParams> {
  final BillRepository _billRepository;
  CreateBillUsecase(this._billRepository);

  @override
  Future<DataState<void>> call({required CreateBillParams params}) {
    return _billRepository.createBill(createBillParams: params);
  }
}
