import 'package:flutter/material.dart';
import '../models/game.dart';
import '../supabase_service.dart';

class GameCreationScreen extends StatefulWidget {
  @override
  _GameCreationScreenState createState() => _GameCreationScreenState();
}

class _GameCreationScreenState extends State<GameCreationScreen> {
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final SupabaseService _supabaseService = SupabaseService();

  Future<void> _createGame() async {
    final name = _nameController.text;
    final color = _colorController.text;

    if (name.isNotEmpty && color.isNotEmpty) {
      final game = Game(
        id: DateTime.now().toString(),
        name: name,
        backgroundColor: color,
        status: 'ongoing',
      );

      final response = await _supabaseService.insert('games', game.toJson());
      
      if (response.error != null) {
        final errorMessage = response.error?.message ?? 'Unknown error';
        print('Error creating game: $errorMessage');
        return;
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Game'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Game Name'),
            ),
            TextField(
              controller: _colorController,
              decoration: InputDecoration(labelText: 'Background Color (Hex)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createGame,
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
