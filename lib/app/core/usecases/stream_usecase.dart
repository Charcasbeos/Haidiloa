abstract class StreamUsecase<Type, Params> {
  Stream<Type> call({required Params params});
}
