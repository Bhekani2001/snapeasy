import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapeasy/bloc/card_bloc.dart';
import 'package:snapeasy/bloc/card_event.dart';
import 'package:snapeasy/repositories/card_repo_impl.dart';
import 'package:snapeasy/repositories/card_repository.dart';
import 'package:snapeasy/view_models/card_viewmodel.dart';
import 'package:snapeasy/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final prefs = await SharedPreferences.getInstance();
    final cardRepo = CardRepoImpl(prefs); // Initialize with SharedPreferences
    runApp(MyApp(cardRepository: cardRepo));
  } catch (e) {
    debugPrint('Failed to initialize app: $e');
    runApp(const ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  final CardRepository cardRepository;

  const MyApp({required this.cardRepository, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CardBloc>(
          create: (context) => CardBloc(CardViewModel(cardRepository)),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RepositoryProvider(
          create: (context) => cardRepository,
          child: SplashScreen(),
        ),
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize app', style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}

