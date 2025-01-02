import 'dart:convert';

abstract class Api {
  int? userId;

  Future<(Game, Board)> create({
    required List<String> events,
  });

  Future<(Game, Board)> join(int gameId);

  Future<Game> play(int gameId, int event);

  Future<(Game, Board)> get(int gameId);

  Future<User> createUser({required String displayName});
}

class Game {
  const Game({
    required this.id,
    required this.events,
    required this.plays,
    this.name = "Deja Whu",
  });
  final int id;
  final List<String> events;
  final List<int> plays;
  final String name;

  factory Game.fromJson(JsonMap json) {
    return Game(
      id: json["id"],
      events: jsonDecode(json["events"]),
      plays: jsonDecode(json["plays"]),
      name: json["name"],
    );
  }
}

class Board {
  const Board({
    required this.id,
    required this.userId,
    required this.board,
  });

  final int id;
  final int userId;
  final List<int> board;

  factory Board.fromJson(JsonMap json) {
    return Board(
      id: json["id"],
      userId: json["playerId"],
      board: jsonDecode(json["board"]),
    );
  }
}

class User {
  const User({
    required this.id,
    this.displayName = "Player",
  });

  final int id;
  final String displayName;

  factory User.fromJson(JsonMap json) {
    return User(
      id: json["id"],
      displayName: json["displayName"],
    );
  }
}

typedef JsonMap = Map<String, dynamic>;
