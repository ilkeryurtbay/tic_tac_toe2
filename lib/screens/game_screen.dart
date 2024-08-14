import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/move.dart';
import '../supabase_service.dart';

class GameScreen extends StatefulWidget {
  final String gameId;

  GameScreen({required this.gameId});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late Game _game;
  List<List<String>> _board = List.generate(3, (_) => List.generate(3, (_) => ''));
  String _currentPlayer = 'X';

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    final response = await _supabaseService.query('games', filters: {'id': widget.gameId});
    
    if (response.error != null) {
      print('Error fetching game: ${response.error?.message}');
      return;
    }

    final gameData = response.data as List<dynamic>;
    if (gameData.isNotEmpty) {
      setState(() {
        _game = Game.fromJson(gameData.first as Map<String, dynamic>);
        _currentPlayer = _game.status == 'ongoing' ? 'X' : '';
      });
    }
  }

  Future<void> _makeMove(int row, int col) async {
    if (_board[row][col] == '' && _currentPlayer != '') {
      setState(() {
        _board[row][col] = _currentPlayer;
      });

      final move = Move(
        id: DateTime.now().toString(),
        gameId: widget.gameId,
        player: _currentPlayer,
        row: row,
        column: col,
      );

      final response = await _supabaseService.insert('moves', move.toJson());
      if (response.error != null) {
        print('Error making move: ${response.error?.message}');
        return;
      }

      if (_checkWin(row, col)) {
        _updateGameStatus('completed');
      } else if (_board.every((row) => row.every((cell) => cell != ''))) {
        _updateGameStatus('completed');
      } else {
        setState(() {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        });
      }
    }
  }

Future<void> _updateGameStatus(String status) async {
  final response = await _supabaseService.update('games', widget.gameId, {'status': status});
  if (response.error != null) {
    print('Error updating game status: ${response.error?.message}');
    return;
  }
  setState(() {
    _game = _game.copyWith(status: status);
  });
}



 bool _checkWin(int row, int col) {
  final player = _board[row][col];

  // Check row
  if (_board[row].every((cell) => cell == player)) return true;

  // Check column
  if (_board.every((r) => r[col] == player)) return true;

  // Check diagonals
  if (row == col && _board.asMap().entries.every((entry) => entry.value[entry.key] == player)) return true;
  if (row + col == 2 && _board.asMap().entries.every((entry) => entry.value[2 - entry.key] == player)) return true;

  return false;
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
        backgroundColor: Color(int.parse(_game.backgroundColor, radix: 16)).withOpacity(1.0),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Color(int.parse(_game.backgroundColor, radix: 16)).withOpacity(1.0),
            child: Column(
              children: List.generate(3, (row) => Row(
                children: List.generate(3, (col) => Expanded(
                  child: GestureDetector(
                    onTap: () => _makeMove(row, col),
                    child: Container(
                      height: 100,
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          _board[row][col],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
