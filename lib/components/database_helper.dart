import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    //A database is created then opened and is attached to our custom database, then a table tasks is created in the database with the id(s) and required parameters.
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'todo3.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
        await db.execute(
            'CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)');
      },
      version: 1,
    );
  }

  Future<void> insertTask(Task task) async {
    //A object _db of database() is created and the insert function is used to map a object of class task into the the table tasks.
    final _db = await database();
    await _db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void>updateTaskTitle(int id,String title)async{
    final _db=await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void>updateTaskDescription(int id,String description)async{
    final _db=await database();
    await _db.rawUpdate("UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  Future<List<Task>> getTasks() async {
    //Querying the data by creating a List of Maps<String,dynamic> and awaiting on the query function to query tasks then a list is generated which passes the created list length and index and a list of Task objects is returned
    final _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description']);
    });
  }

  Future<void>deleteTask(int id)async{
    final _db=await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }

  Future<void> insertTodo(Todo todo) async {
    //A object _db of database() is created and the insert function is used to map a object of class todo into the the table todo.
    final _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void>updateTodoDone(int id,int isDone)async{
    final _db=await database();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  Future<List<Todo>> getTodo(int taskId) async {
    //Querying the data by creating a List of Maps<String,dynamic> and awaiting on the query function to query tasks then a list is generated which passes the created list length and index and a list of Todo objects is returned
    final _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo  WHERE taskId = '$taskId'");
    return List.generate(todoMap.length, (index) {
      return Todo(
        id: todoMap[index]['id'],
        title: todoMap[index]['title'],
        taskId: todoMap[index]['taskId'],
        isDone: todoMap[index]['isDone'],
      );
    });
  }

  Future<int> getTodoLength() async {
    //Querying the data by creating a List of Maps<String,dynamic> and awaiting on the query function to query tasks then a list is generated which passes the created list length and index and a list of Todo objects is returned
    final _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.query('todo');
    return Future.value(todoMap.length);
  }
}
