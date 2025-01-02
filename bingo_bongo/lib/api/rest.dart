import 'package:bingo_bongo/api/api.dart';
import 'package:dio/dio.dart';

class RestApi implements Api {
  final dio = Dio(
    BaseOptions(baseUrl: "https://dejawhu.chillers.dev"),
  );

  @override
  Future<(Game, Board)> create({
    required List<String> events,
  }) async {
    final response = await dio.post(
      "/create",
      options: userOptions,
    );
    final json = response.data as JsonMap;

    return (Game.fromJson(json["game"]), Board.fromJson(json["board"]));
  }

  @override
  Future<(Game, Board)> join(int gameId) async {
    final response = await dio.get(
      "/join/$gameId",
      options: userOptions,
    );

    final json = response.data as JsonMap;
    return (Game.fromJson(json["game"]), Board.fromJson(json["board"]));
  }

  @override
  Future<Game> play(int gameId, int event) async {
    final response = await dio.post(
      "/game/$gameId/play/$event",
      options: userOptions,
    );
    final json = response.data as JsonMap;

    return Game.fromJson(json["game"]);
  }

  @override
  Future<(Game, Board)> get(int gameId) async {
    final response = await dio.get(
      "/game/$gameId",
      options: userOptions,
    );

    final json = response.data as JsonMap;
    return (Game.fromJson(json["game"]), Board.fromJson(json["board"]));
  }

  @override
  int? userId;

  Options get userOptions {
    return Options(headers: {
      "USER_ID": userId,
    });
  }
}
