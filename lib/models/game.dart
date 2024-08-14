class Game {
  final String id;
  final String name;
  final String backgroundColor;
  final String status;

  Game({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.status,
  });

  // `copyWith` methodu
  Game copyWith({
    String? id,
    String? name,
    String? backgroundColor,
    String? status,
  }) {
    return Game(
      id: id ?? this.id,
      name: name ?? this.name,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      status: status ?? this.status,
    );
  }

  // JSON dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'backgroundColor': backgroundColor,
      'status': status,
    };
  }

  // JSON'dan oluşturma
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      backgroundColor: json['backgroundColor'],
      status: json['status'],
    );
  }
}
