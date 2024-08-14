import 'package:flutter/material.dart';
import '../models/game.dart';
import '../supabase_service.dart';

class GamesListScreen extends StatefulWidget {
  @override
  _GamesListScreenState createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Game> _games = [];

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    final response = await _supabaseService.query('games');
    
    if (response.error != null) {
      print('Error fetching games: ${response.error?.message}');
      return;
    }

    final gamesData = response.data as List<dynamic>;
    setState(() {
      _games = gamesData.map((json) => Game.fromJson(json as Map<String, dynamic>)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games List'),
      ),
      body: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return ListTile(
            title: Text(game.name),
            onTap: () => Navigator.pushNamed(context, '/game', arguments: game.id),
          );
        },
      ),
    );
  }
}
