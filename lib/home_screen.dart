import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when app starts
  }

  // Load tasks from SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List decoded = jsonDecode(tasksJson);
      setState(() {
        _tasks.clear();
        _tasks.addAll(decoded.map((e) => Map<String, dynamic>.from(e)));
      });
    }
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(_tasks));
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            hintText: 'Enter task name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _taskController.clear();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_taskController.text.isNotEmpty) {
                setState(() {
                  _tasks.add({
                    'title': _taskController.text,
                    'isDone': false,
                  });
                });
                _saveTasks(); // Save after adding
                _taskController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks(); // Save after deleting
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['isDone'] = !_tasks[index]['isDone'];
    });
    _saveTasks(); // Save after toggling
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTask,
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No tasks yet!\nTap + to add a task',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Checkbox(
                value: task['isDone'],
                onChanged: (val) => _toggleTask(index),
                activeColor: Colors.blue,
              ),
              title: Text(
                task['title'],
                style: TextStyle(
                  fontSize: 16,
                  decoration: task['isDone']
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: task['isDone'] ? Colors.grey : Colors.black,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteTask(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}