import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;

  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t['isDone'] == true).length;
  int get pendingTasks => _tasks.where((t) => t['isDone'] == false).length;

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List decoded = jsonDecode(tasksJson);
      _tasks = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      notifyListeners(); // ← tells UI to rebuild
    }
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(_tasks));
  }

  // Add task
  Future<void> addTask(String title) async {
    _tasks.add({'title': title, 'isDone': false});
    notifyListeners();
    await _saveTasks();
  }

  // Delete task
  Future<void> deleteTask(int index) async {
    _tasks.removeAt(index);
    notifyListeners();
    await _saveTasks();
  }

  // Toggle task complete/incomplete
  Future<void> toggleTask(int index) async {
    _tasks[index]['isDone'] = !_tasks[index]['isDone'];
    notifyListeners();
    await _saveTasks();
  }
}