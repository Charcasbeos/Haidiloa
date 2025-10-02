import 'package:get_it/get_it.dart';
import 'package:haidiloa/features/auth/data/data_sources/auth_service.dart';
import 'package:haidiloa/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:haidiloa/features/bills/domain/usecase/get_bills_by_user_id_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/get_bills_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/realtime/stream_bills_by_user_id_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/update_bill_payment.dart';
import 'package:haidiloa/features/bills/domain/usecase/update_total_bill_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/check_out_booking.dart';
import 'package:haidiloa/features/bookings/domain/usecase/get_bookings_by_user_id_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/realtime/stream_bookings_by_user_id_usecase.dart';
import 'package:haidiloa/features/user/data/repositories/user_repository_impl.dart';
import 'package:haidiloa/features/auth/domain/repositories/auth_repository.dart';
import 'package:haidiloa/features/user/domain/repositories/user_repository.dart';
import 'package:haidiloa/features/auth/domain/usecase/get_auth_usecase.dart';
import 'package:haidiloa/features/user/domain/usecase/create_user_usecase.dart';
import 'package:haidiloa/features/user/domain/usecase/get_user_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:haidiloa/features/auth/domain/usecase/sign_up_usecase.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:haidiloa/features/bills/data/datasources/bill_remote_datasource.dart';
import 'package:haidiloa/features/bills/data/repositories/bill_repository_impl.dart';
import 'package:haidiloa/features/bills/domain/repositories/bill_repository.dart';
import 'package:haidiloa/features/bills/domain/usecase/create_bill_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/get_bill_usecase.dart';
import 'package:haidiloa/features/bills/domain/usecase/request_payment_usecase.dart';
import 'package:haidiloa/features/bills/presentation/bloc/bill_bloc.dart';
import 'package:haidiloa/features/bookings/data/datasources/booking_remote_datasource.dart';
import 'package:haidiloa/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:haidiloa/features/bookings/domain/repositories/booking_repository.dart';
import 'package:haidiloa/features/bookings/domain/usecase/approve_booking_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/check_in_booking_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/create_booking_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/get_booking_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/get_bookings_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/mark_no_show_booking_usecase.dart';
import 'package:haidiloa/features/bookings/domain/usecase/reject_booking_usecase.dart';
import 'package:haidiloa/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:haidiloa/features/orders/domain/usecase/create_order_usecase.dart';
import 'package:haidiloa/features/orders/domain/usecase/create_orders_usecase.dart';
import 'package:haidiloa/features/orders/domain/usecase/get_orders_by_bill_id_usecase.dart';
import 'package:haidiloa/features/orders/presentation/bloc/order_bloc.dart';
import 'package:haidiloa/features/dishes/data/datasources/dish_remote_datasource.dart';
import 'package:haidiloa/features/dishes/data/repositories/dish_repository_impl.dart';
import 'package:haidiloa/features/dishes/domain/repositories/dish_repository.dart';
import 'package:haidiloa/features/dishes/domain/usecase/create_dish_usecase.dart';
import 'package:haidiloa/features/dishes/domain/usecase/delete_dish_usecase.dart';
import 'package:haidiloa/features/dishes/domain/usecase/get_dishes_usecase.dart';
import 'package:haidiloa/features/dishes/domain/usecase/update_dish_usecase.dart';
import 'package:haidiloa/features/dishes/domain/usecase/upload_image_usecase.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_bloc.dart';
import 'package:haidiloa/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:haidiloa/features/orders/data/repositories/order_repository_impl.dart';
import 'package:haidiloa/features/orders/domain/repositories/order_repository.dart';
import 'package:haidiloa/features/user/presentation/bloc/user_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Supabase client
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // ====================
  /// Auth
  /// ====================
  /* Auth service */
  sl.registerLazySingleton<AuthService>(
    () => AuthService(sl<SupabaseClient>()),
  );

  /* Auth Repository */
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthService>(), sl<SupabaseClient>()),
  );
  /* User Repository */
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<SupabaseClient>()),
  );
  /* Auth Usecases */
  sl.registerLazySingleton<SignInUsecase>(
    () => SignInUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOutUsecase>(
    () => SignOutUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignUpUsecase>(
    () => SignUpUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetAuthUsecase>(
    () => GetAuthUsecase(sl<AuthRepository>()),
  );
  /* User Usecases */
  sl.registerLazySingleton<GetUserUsecase>(
    () => GetUserUsecase(sl<UserRepository>()),
  );
  sl.registerLazySingleton<CreateUserUsecase>(
    () => CreateUserUsecase(sl<UserRepository>()),
  );
  /* Auth Bloc */
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      sl<SignInUsecase>(),
      sl<SignUpUsecase>(),
      sl<GetAuthUsecase>(),
      sl<SignOutUsecase>(),
      sl<GetUserUsecase>(),
      sl<CreateUserUsecase>(),
    ),
  );
  // ====================
  /// User
  /// ====================
  /* User service */

  /* User Usecases */

  /* User Bloc */
  sl.registerFactory<UserBloc>(
    () => UserBloc(
      sl<GetUserUsecase>(),
      sl<GetAuthUsecase>(),
      sl<GetBookingsByUserIdUsecase>(),
      sl<GetBillsByUserIdUsecase>(),
      sl<StreamBookingsByUserIdUsecase>(),
      sl<StreamBillsByUserIdUsecase>(),
    ),
  );

  // ====================
  /// Dish
  /// ====================
  /* Data source */
  sl.registerLazySingleton<DishRemoteDataSource>(
    () => DishRemoteDataSource(sl<SupabaseClient>()),
  );
  /* Dish Repository */
  sl.registerLazySingleton<DishRepository>(
    () => DishRepositoryImpl(sl<DishRemoteDataSource>()),
  );
  /* Dish Usecases */
  sl.registerLazySingleton<CreateDishUsecase>(
    () => CreateDishUsecase(sl<DishRepository>()),
  );
  sl.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(sl<DishRepository>()),
  );
  sl.registerLazySingleton<UpdateDishUsecase>(
    () => UpdateDishUsecase(sl<DishRepository>()),
  );
  sl.registerLazySingleton<GetDishesUsecase>(
    () => GetDishesUsecase(sl<DishRepository>()),
  );
  sl.registerLazySingleton<DeleteDishUsecase>(
    () => DeleteDishUsecase(sl<DishRepository>()),
  );
  /* Dish Bloc */
  sl.registerFactory<DishBloc>(
    () => DishBloc(
      sl<CreateDishUsecase>(),
      sl<UpdateDishUsecase>(),
      sl<DeleteDishUsecase>(),
      sl<GetDishesUsecase>(),
      sl<UploadImageUsecase>(),
    ),
  );
  // ====================
  /// Order Bloc
  /// ====================
  /* Data source */
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSource(sl<SupabaseClient>()),
  );
  /* Order Repository */
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      sl<OrderRemoteDataSource>(),
      sl<BillRemoteDataSource>(),
    ),
  );
  /* Order Usecase */
  sl.registerLazySingleton<CreateOrderUsecase>(
    () => CreateOrderUsecase(sl<OrderRepository>()),
  );
  sl.registerLazySingleton<GetOrdersByBillIdUsecase>(
    () => GetOrdersByBillIdUsecase(sl<OrderRepository>()),
  );
  sl.registerLazySingleton<CreateOrdersUsecase>(
    () => CreateOrdersUsecase(sl<OrderRepository>()),
  );
  sl.registerLazySingleton<UpdateTotalBillUsecase>(
    () => UpdateTotalBillUsecase(sl<BillRepository>()),
  );
  /* Order Bloc */
  sl.registerFactory<OrderBloc>(
    () => OrderBloc(
      sl<CreateOrdersUsecase>(),
      sl<CreateBillUsecase>(),
      sl<UpdateTotalBillUsecase>(),
      sl<GetBillUsecase>(),
    ), // vì CartBloc không cần usecase nào
  );
  // ====================
  /// Bill Bloc
  /// ====================
  /* Data source */
  sl.registerLazySingleton<BillRemoteDataSource>(
    () => BillRemoteDataSource(sl<SupabaseClient>()),
  );
  /* Bill Repository */

  sl.registerLazySingleton<BillRepository>(
    () => BillRepositoryImpl(sl<BillRemoteDataSource>()),
  );
  /* Bill Usecase */
  sl.registerLazySingleton<CreateBillUsecase>(
    () => CreateBillUsecase(sl<BillRepository>()),
  );
  sl.registerLazySingleton<GetBillUsecase>(
    () => GetBillUsecase(sl<BillRepository>()),
  );
  sl.registerLazySingleton<GetBillsByUserIdUsecase>(
    () => GetBillsByUserIdUsecase(sl<BillRepository>()),
  );
  sl.registerLazySingleton<StreamBillsByUserIdUsecase>(
    () => StreamBillsByUserIdUsecase(sl<BillRepository>()),
  );
  sl.registerLazySingleton<RequestPaymentUsecase>(
    () => RequestPaymentUsecase(sl<BillRepository>()),
  );
  sl.registerLazySingleton<UpdateBillPaymentedUsecase>(
    () => UpdateBillPaymentedUsecase(sl<BillRepository>()),
  );
  sl.registerLazySingleton<GetBillsUsecase>(
    () => GetBillsUsecase(sl<BillRepository>()),
  );
  /* Bill Bloc */
  sl.registerFactory<BillBloc>(
    () => BillBloc(
      sl<GetOrdersByBillIdUsecase>(),
      sl<RequestPaymentUsecase>(),
      sl<GetBillUsecase>(),
      sl<GetBillsUsecase>(),
      sl<UpdateBillPaymentedUsecase>(),
      sl<CheckOutBookingUseCase>(),
    ),
  );
  // ====================
  /// Booking Bloc
  /// ====================
  /* Data source */
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSource(sl<SupabaseClient>()),
  );
  /* Booking Repository */

  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl<BookingRemoteDataSource>()),
  );
  /* Booking Usecase */
  sl.registerLazySingleton<CreateBookingUsecase>(
    () => CreateBookingUsecase(sl<BookingRepository>()),
  );

  sl.registerLazySingleton<GetBookingUsecase>(
    () => GetBookingUsecase(sl<BookingRepository>()),
  );

  sl.registerLazySingleton<GetBookingsUsecase>(
    () => GetBookingsUsecase(sl<BookingRepository>()),
  );
  sl.registerLazySingleton<GetBookingsByUserIdUsecase>(
    () => GetBookingsByUserIdUsecase(sl<BookingRepository>()),
  );
  sl.registerLazySingleton<StreamBookingsByUserIdUsecase>(
    () => StreamBookingsByUserIdUsecase(sl<BookingRepository>()),
  );

  sl.registerLazySingleton<ApproveBookingUsecase>(
    () => ApproveBookingUsecase(sl<BookingRepository>()),
  );

  sl.registerLazySingleton<RejectBookingUsecase>(
    () => RejectBookingUsecase(sl<BookingRepository>()),
  );

  sl.registerLazySingleton<CheckInBookingUsecase>(
    () => CheckInBookingUsecase(sl<BookingRepository>()),
  );
  sl.registerLazySingleton<CheckOutBookingUseCase>(
    () => CheckOutBookingUseCase(sl<BookingRepository>()),
  );

  sl.registerLazySingleton<MarkNoShowBookingUsecase>(
    () => MarkNoShowBookingUsecase(sl<BookingRepository>()),
  );
  /* Booking Bloc */
  sl.registerFactory<BookingBloc>(
    () => BookingBloc(
      sl<GetBookingsUsecase>(),
      sl<CreateBookingUsecase>(),
      sl<ApproveBookingUsecase>(),
      sl<RejectBookingUsecase>(),
      sl<CheckInBookingUsecase>(),
      sl<MarkNoShowBookingUsecase>(),
    ),
  );
}
