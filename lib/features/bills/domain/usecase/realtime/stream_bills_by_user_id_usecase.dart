import 'package:haidiloa/app/core/usecases/stream_usecase.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/bills/domain/repositories/bill_repository.dart';

class StreamBillsByUserIdUsecase
    implements StreamUsecase<List<BillEntity>, String> {
  final BillRepository repo;

  StreamBillsByUserIdUsecase(this.repo);

  @override
  Stream<List<BillEntity>> call({required String params}) {
    return repo.streamBillsByUserId(params);
  }
}
