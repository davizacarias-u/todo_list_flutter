import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStorage {
  static String _stroragekey = 'tasks';

  Future<List<Task>> LoadTasks() async{
    final prefs = await SharedPreferences.getInstance();
    final jsonstring = prefs.getString(_stroragekey);

    if (jsonstring == null){
      return[];
    }
    final List<dynamic> decodedList = jsonDecode(jsonstring);

    return decodedList.map((item) => Task.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async{
    final prefs = await SharedPreferences.getInstance();

    final jsonstring = jsonEncode(tasks.map((task) => task.toJson()).toList(),);
    await prefs.setString(_stroragekey, jsonstring);
  }
}