class Move {
  final String id;
  final String gameId;
  final String player;
  final int row;
  final int column;

  Move({
    required this.id,
    required this.gameId,
    required this.player,
    required this.row,
    required this.column,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      id: json['id'],
      gameId: json['game_id'],
      player: json['player'],
      row: json['row'],
      column: json['column'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'player': player,
      'row': row,
      'column': column,
    };
  }
}
