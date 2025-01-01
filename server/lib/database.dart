import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart' as pg;

part 'database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId => integer().nullable()();
  IntColumn get boardId => integer().nullable()();
  TextColumn get displayName => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class Games extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get events => text()(); // Stored as JSON string
  TextColumn get plays => text()(); // Store int[] as JSON string
  TextColumn get boardIds => text()(); // Store board IDs as JSON string
  TextColumn get name => text()();
}

class Boards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playerId => integer().references(Users, #id)();
  TextColumn get board => text()(); // Store board array as JSON string
}

@DriftDatabase(tables: [Users, Games, Boards])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return PgDatabase(
      endpoint: pg.Endpoint(
        host: Platform.environment["BONGO_DB_URL"] ?? "localhost",
        database: Platform.environment["BONGO_DB"] ?? "bingo",
        username: Platform.environment["BONGO_DB_USER"] ?? "bongo",
        password: Platform.environment["BONGO_DB_PW"] ?? "password",
      ),
    );
  }
}
