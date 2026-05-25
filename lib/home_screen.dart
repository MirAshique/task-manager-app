import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/task_provider.dart';
import 'screens/users_list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load tasks via Provider
    Future.microtask(() =>
        Provider.of<TaskProvider>(context, listen: false).loadTasks());
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: TextField(
          controller: _taskController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter task name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                Provider.of<TaskProvider>(context, listen: false)
                    .addTask(_taskController.text);
                _taskController.clear();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
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
            icon: const Icon(Icons.person),
            tooltip: 'My Profile',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfileScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'View Users',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UsersListScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;

          return Column(
            children: [
              // 📊 Stats Bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                color: Colors.blue.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statChip('Total', taskProvider.totalTasks, Colors.blue),
                    _statChip('Done', taskProvider.completedTasks, Colors.green),
                    _statChip('Pending', taskProvider.pendingTasks, Colors.orange),
                  ],
                ),
              ),

              // 📋 Task List
              Expanded(
                child: tasks.isEmpty
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
                    : AnimatedList(
                  key: GlobalKey<AnimatedListState>(),
                  padding: const EdgeInsets.all(16),
                  initialItemCount: tasks.length,
                  itemBuilder: (context, index, animation) {
                    return _buildAnimatedTask(
                        context, index, animation, taskProvider);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  // Animated task card
  Widget _buildAnimatedTask(BuildContext context, int index,
      Animation<double> animation, TaskProvider taskProvider) {
    final task = taskProvider.tasks[index];
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0), // slides in from right
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: FadeTransition(
        opacity: animation,
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            leading: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Checkbox(
                value: task['isDone'],
                onChanged: (val) => taskProvider.toggleTask(index),
                activeColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            title: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 16,
                decoration: task['isDone']
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task['isDone'] ? Colors.grey : Colors.black,
              ),
              child: Text(task['title']),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => taskProvider.deleteTask(index),
            ),
          ),
        ),
      ),
    );
  }

  // Stats chip widget
  Widget _statChip(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}