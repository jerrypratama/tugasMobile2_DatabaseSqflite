import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = "todo";
final String Column_id = "id";
final String Column_film = "film";

class TaskModel {
  final String film;
  int id;

  TaskModel({this.film, this.id});
  Map<String, dynamic> toMap() {
    return {Column_film: this.film};
  }
}

class TodoHelper {
  Database db;

  TodoHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "jerry.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName($Column_id INTERGER PRIMARY KEY AUTO INCREMENT , $Column_film TEXT)");
    }, version: 1);
  }

  Future<void> insertTask(TaskModel task) async {
    try {
      db.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {
      print(_);
    }
  }

  Future<List<TaskModel>> getAllTask() async {
    final List<Map<String, dynamic>> tasks = await db.query(tableName);

    List.generate(tasks.length, (i) {
      return TaskModel(film: tasks[i][Column_film], id: tasks[i][Column_id]);
    });
  }
}
