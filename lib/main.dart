import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/game_creation_screen.dart';
import 'screens/games_list_screen.dart';
import 'screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'your-supabase-url',
    anonKey: 'your-supabase-anon-key',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/create': (context) => GameCreationScreen(),
        '/list': (context) => GamesListScreen(),
        '/game': (context) => GameScreen(gameId: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}
