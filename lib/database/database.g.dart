// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DiaryentryDao? _diaryentryDaoInstance;

  ReportDao? _reportDaoInstance;

  HRdao? _hRdaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Diaryentry` (`date` TEXT NOT NULL, `entry` TEXT NOT NULL, `mood` TEXT NOT NULL, PRIMARY KEY (`date`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Report` (`date` TEXT NOT NULL, `content` TEXT NOT NULL, PRIMARY KEY (`date`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `HREntity` (`date` TEXT NOT NULL, `time` REAL NOT NULL, `value` INTEGER NOT NULL, PRIMARY KEY (`date`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DiaryentryDao get diaryentryDao {
    return _diaryentryDaoInstance ??= _$DiaryentryDao(database, changeListener);
  }

  @override
  ReportDao get reportDao {
    return _reportDaoInstance ??= _$ReportDao(database, changeListener);
  }

  @override
  HRdao get hRdao {
    return _hRdaoInstance ??= _$HRdao(database, changeListener);
  }
}

class _$DiaryentryDao extends DiaryentryDao {
  _$DiaryentryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _diaryentryInsertionAdapter = InsertionAdapter(
            database,
            'Diaryentry',
            (Diaryentry item) => <String, Object?>{
                  'date': item.date,
                  'entry': item.entry,
                  'mood': item.mood
                }),
        _diaryentryDeletionAdapter = DeletionAdapter(
            database,
            'Diaryentry',
            ['date'],
            (Diaryentry item) => <String, Object?>{
                  'date': item.date,
                  'entry': item.entry,
                  'mood': item.mood
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Diaryentry> _diaryentryInsertionAdapter;

  final DeletionAdapter<Diaryentry> _diaryentryDeletionAdapter;

  @override
  Future<List<Diaryentry>> findAllEntries() async {
    return _queryAdapter.queryList('SELECT * FROM Diaryentry',
        mapper: (Map<String, Object?> row) => Diaryentry(row['date'] as String,
            row['entry'] as String, row['mood'] as String));
  }

  @override
  Future<List<String?>> findEntriesWhere(String date) async {
    return _queryAdapter.queryList(
        'SELECT entry,mood FROM Diaryentry WHERE date = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        arguments: [date]);
  }

  @override
  Future<int?> howManyEntries() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM Diaryentry',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertDiaryentry(Diaryentry diaryentry) async {
    await _diaryentryInsertionAdapter.insert(
        diaryentry, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDiaryentry(Diaryentry diaryentry) async {
    await _diaryentryDeletionAdapter.delete(diaryentry);
  }
}

class _$ReportDao extends ReportDao {
  _$ReportDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _reportInsertionAdapter = InsertionAdapter(
            database,
            'Report',
            (Report item) =>
                <String, Object?>{'date': item.date, 'content': item.content}),
        _reportDeletionAdapter = DeletionAdapter(
            database,
            'Report',
            ['date'],
            (Report item) =>
                <String, Object?>{'date': item.date, 'content': item.content});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Report> _reportInsertionAdapter;

  final DeletionAdapter<Report> _reportDeletionAdapter;

  @override
  Future<List<Report>> findAllReports() async {
    return _queryAdapter.queryList('SELECT * FROM Report',
        mapper: (Map<String, Object?> row) =>
            Report(row['date'] as String, row['content'] as String));
  }

  @override
  Future<int?> howManyReports() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM Report',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertReport(Report report) async {
    await _reportInsertionAdapter.insert(report, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteReport(Report report) async {
    await _reportDeletionAdapter.delete(report);
  }
}

class _$HRdao extends HRdao {
  _$HRdao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _hREntityInsertionAdapter = InsertionAdapter(
            database,
            'HREntity',
            (HREntity item) => <String, Object?>{
                  'date': item.date,
                  'time': item.time,
                  'value': item.value
                }),
        _hREntityDeletionAdapter = DeletionAdapter(
            database,
            'HREntity',
            ['date'],
            (HREntity item) => <String, Object?>{
                  'date': item.date,
                  'time': item.time,
                  'value': item.value
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HREntity> _hREntityInsertionAdapter;

  final DeletionAdapter<HREntity> _hREntityDeletionAdapter;

  @override
  Future<List<HREntity>> findAllHR() async {
    return _queryAdapter.queryList('SELECT * FROM HREntity',
        mapper: (Map<String, Object?> row) => HREntity(
            row['date'] as String, row['time'] as double, row['value'] as int));
  }

  @override
  Future<List<int?>> findEntriesAfter(
    String date,
    double time,
  ) async {
    return _queryAdapter.queryList(
        'SELECT value FROM HREntity WHERE (date = ?1) AND (time >= ?2)',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [date, time]);
  }

  @override
  Future<List<int?>> findEntriesBefore(
    String date,
    double time,
  ) async {
    return _queryAdapter.queryList(
        'SELECT value FROM HREntity WHERE (date = ?1) AND (time <= ?2)',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [date, time]);
  }

  @override
  Future<int?> howManyHR() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM HREntity',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertHR(HREntity hrentity) async {
    await _hREntityInsertionAdapter.insert(hrentity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteHR(HREntity hrentity) async {
    await _hREntityDeletionAdapter.delete(hrentity);
  }
}
