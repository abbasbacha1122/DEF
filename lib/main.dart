import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class Task {
  String name;
  DateTime dueDate;
  DateTime reminderDate;

  Task(this.name, this.dueDate, this.reminderDate);
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<Task>> categories = {
    'Category 1': [],
    'Category 2': [],
    'Category 3': [],
  };
  TextEditingController taskController = TextEditingController();
  int selectedIndex = 0;
  DateTime? dueDate;
  DateTime? reminderDate;
  Task? editingTask;
  int? editingTaskIndex;

  void addTask() {
    if (taskController.text.isNotEmpty &&
        dueDate != null &&
        reminderDate != null) {
      setState(() {
        if (editingTask == null) {
          categories[categories.keys.elementAt(selectedIndex)]!.add(
            Task(taskController.text, dueDate!, reminderDate!),
          );
        } else {
          categories[categories.keys.elementAt(selectedIndex)]![editingTaskIndex!] =
              Task(taskController.text, dueDate!, reminderDate!);
          editingTask = null;
          editingTaskIndex = null;
        }
        taskController.clear();
        dueDate = null;
        reminderDate = null;
      });
    }
  }

  void deleteTask(int index) {
    setState(() {
      categories[categories.keys.elementAt(selectedIndex)]!.removeAt(index);
    });
  }

  void editTask(int index) {
    setState(() {
      editingTask = categories[categories.keys.elementAt(selectedIndex)]![index];
      editingTaskIndex = index;
      taskController.text = editingTask!.name;
      dueDate = editingTask!.dueDate;
      reminderDate = editingTask!.reminderDate;
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  Future<void> _selectReminderDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: reminderDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != reminderDate) {
      setState(() {
        reminderDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedCategory = categories.keys.elementAt(selectedIndex);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 119),
      appBar: AppBar(
        backgroundColor: Colors.amber[200],
        title: Text('Todo List App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categories[selectedCategory]!.length,
              itemBuilder: (context, index) {
                Task task = categories[selectedCategory]![index];
                return ListTile(
                  title: Text(task.name),
                  subtitle: Text(
                      'Due: ${dateFormat.format(task.dueDate)}, Reminder: ${dateFormat.format(task.reminderDate)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editTask(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTask(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextField(
                          controller: taskController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[300],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            hintText: 'Enter task',
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: addTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 129, 236, 112),
                      ),
                      child: Text(editingTask == null ? 'Add Task' : 'Update Task'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _selectDueDate(context),
                      child: Text(dueDate == null
                          ? 'Select Due Date'
                          : 'Due: ${dateFormat.format(dueDate!)}'),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectReminderDate(context),
                      child: Text(reminderDate == null
                          ? 'Select Reminder Date'
                          : 'Reminder: ${dateFormat.format(reminderDate!)}'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: categories.keys.map((String key) {
          return BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: key,
          );
        }).toList(),
      ),
    );
  }
}
