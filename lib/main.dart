import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/app/core/constants/constants.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:haidiloa/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:haidiloa/features/auth/presentation/pages/auth_gate.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_bloc.dart';
import 'package:haidiloa/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(CheckSessionEvent()),
        ),
        BlocProvider<DishBloc>(
          create: (_) => sl<DishBloc>(), // không có CheckSessionEvent ở đây
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
      ),
    );
  }
}
