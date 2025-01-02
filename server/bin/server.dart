import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:server/database.dart';
import 'package:server/log.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_multipart/shelf_multipart.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..post('/createUser', _createUserHandler)
  ..post('/create', _createGameHandler)
  ..get('/game/<id>', _getGameHandler)
  ..post('/game/<id>/play/<event>', _playHandler)
  ..get('/join/<id>', _joinHandler);

const middle = (5 * 2) + 3 - 1; // 2nd row, 3rd square, start at 0

Future<Response> _createUserHandler(Request request) async {
  final form = request.formData();
  if (form == null) {
    return Response.badRequest(body: "No multipart form body");
  }
  // Read all form-data parameters into a single map:
  final parameters = <String, String>{
    await for (final formData in form.formData)
      formData.name: await formData.part.readString(),
  };
  log.info("Received body: $parameters");
  final user = await database.into(database.users).insertReturning(
        UsersCompanion(
          displayName: Value(parameters["displayName"] ?? "Player"),
        ),
      );

  return Response.ok(user.toJsonString());
}

Future<Response> _createGameHandler(Request request) async {
  final uId = userId(request);
  if (uId == null) {
    return Response.badRequest(body: "USER_ID is not valid");
  }
  log.info("Creating game for $uId");
  final form = request.formData();
  if (form == null) {
    return Response.badRequest(body: "No multipart form body");
  }
  // Read all form-data parameters into a single map:
  final parameters = <String, String>{
    await for (final formData in form.formData)
      formData.name: await formData.part.readString(),
  };
  log.info("Received body: $parameters");
  if (!parameters.containsKey("events")) {
    return Response.badRequest(body: "form data does not include events");
  }
  log.info("Parsed parameters $parameters");
  final json = jsonDecode(parameters["events"]!) as List<dynamic>;
  log.info("Parsed $json");
  final events = json.map((son) => son as String).toList();
  if (events.length != 25) {
    return Response.badRequest(body: "need 25 events to create a game");
  }
  final game = await createGame(
    uID: uId,
    events: events,
  );

  final board = await createBoardForGame(uId: uId, game: game);

  return Response.ok(jsonEncode({
    "game": game.toJson(),
    "board": board.toJson(),
  }));
}

Future<Response> _getGameHandler(Request request) async {
  final id = gameId(request);
  if (id == null) {
    return Response.badRequest(body: "id is not a valid number");
  }
  final game = await getGameFromId(id);
  if (game == null) {
    return Response.notFound("Game not found");
  }
  return Response.ok(game!.toJson());
}

Future<Response> _joinHandler(Request request) async {
  final id = gameId(request);
  if (id == null) {
    return Response.badRequest(body: "id is not a valid number");
  }
  final uId = userId(request);
  if (uId == null) {
    return Response.badRequest(body: "USER_ID is not valid");
  }

  // TODO: This should be a transaction :shrug:

  final game = await getGameFromId(id);
  if (game == null) {
    return Response.notFound("Game not found");
  }

  final board = await createBoard(uId: uId);

  final boardIds = jsonDecode(game!.boardIds) as List<int>;
  boardIds.add(board.id);
  log.info("Adding ${board.id} to $id");

  (database.update(database.games)..where((row) => row.id.equals(game.id)))
      .write(GamesCompanion(
    boardIds: Value(jsonEncode(boardIds)),
  ));

  return Response.ok(jsonEncode({
    "game": game.toJson(),
    "board": board.toJson(),
  }));
}

Future<Response> _playHandler(Request request) async {
  final id = gameId(request);
  if (id == null) {
    return Response.badRequest(body: "id is not a valid number");
  }

  // TODO: This should be a transaction :shrug:

  final game = await getGameFromId(id);
  if (game == null) {
    return Response.notFound("Game not found");
  }
  final event = int.tryParse(request.params['event'] ?? "");
  if (event == null || (event < 0) || event > 24) {
    return Response.badRequest(body: "event is not a valid number");
  }

  final json = jsonDecode(game.plays) as List<dynamic>;
  final events = json.map((son) => son as int).toList();
  events.add(event);

  log.info("Adding $event to game $id");

  final newGame = await (database.update(database.games)
        ..whereSamePrimaryKey(game))
      .writeReturning(
    GamesCompanion(
      events: Value(jsonEncode(events)),
    ),
  );

  // TODO(casey): Check if someone won

  return Response.ok(jsonEncode({"game": newGame.first.toJson()}));
}

Future<Board> createBoardForGame({
  required int uId,
  required Game game,
}) async {
  final board = await createBoard(uId: uId);
  log.info("Created board ${board.id}");

  final json = jsonDecode(game.boardIds) as List<dynamic>;
  final boardIds = json.map((son) => son as int).toList();
  boardIds.add(board.id);

  (database.update(database.games)..where((row) => row.id.equals(game.id)))
      .write(
    GamesCompanion(
      boardIds: Value(jsonEncode(boardIds)),
    ),
  );

  log.info("Added board ${board.id} to game ${game.id}");

  return board;
}

Future<Game> createGame({
  required int uID,
  required List<String> events,
  String name = "Game!",
}) async {
  final game = await database.into(database.games).insertReturning(
        GamesCompanion(
          events: Value(jsonEncode(events)),
          plays: Value(jsonEncode([middle])),
          boardIds: Value(jsonEncode([])),
          name: Value(name),
        ),
      );
  log.info("Created game ${game.id}");

  return game;
}

Future<Board> createBoard({
  required int uId,
}) async {
  // TODO: Make sure board is unique.

  final events = List.generate(5 * 5, (i) => i);
  events.shuffle();

  // Remove the wild card, and explicitly put it in the middle.
  events.removeWhere((e) => e == middle);
  events.insert(middle, middle);

  log.info("Shuffled events to $events");

  final board = await database.into(database.boards).insertReturning(
        BoardsCompanion(
          board: Value(jsonEncode(events)),
          playerId: Value(uId),
        ),
      );

  return board;
}

int? gameId(Request request) {
  // TODO: Could extend this to be a string of letters as well, and decode it with base64
  final id = int.tryParse(request.params['id'] ?? "");
  return id;
}

int? userId(Request request) {
  log.fine("Checking headers: ${request.headers}");
  final id = int.tryParse(request.headers["USER_ID"] ?? "");
  return id;
}

Future<Game?> getGameFromId(int id) async {
  log.info("Looking up game $id");
  // TODO: This isn't finding anything...
  final game = await (database.select(database.games)
        ..where((row) => row.id.equals(id)))
      .get();
  log.info("Found $game");
  return game.firstOrNull;
}

final database = AppDatabase();

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
