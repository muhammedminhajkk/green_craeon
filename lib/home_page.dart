import 'package:flutter/material.dart';
import 'package:machine_test/getstorage.dart';
import 'package:machine_test/todo_model.dart';
import 'package:machine_test/weather.dart';

class HomePage extends StatefulWidget {
  final String city;
  const HomePage({super.key, required this.city});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TodoStorageService _storageService = TodoStorageService();
  List<TodoModel> todos = [];
  List<TodoModel> completedTodos = [];
  List<TodoModel> notcompletedTodos = [];
  double? temperature;
  final String apiKey = 'a98a36694bb14bf8b0750605240511';

  @override
  void initState() {
    super.initState();
    todos = _storageService.loadTodos();
    _updateTodoLists(); // Load and categorize todos
    fetchTemperatureData();
  }

  Future<void> fetchTemperatureData() async {
    print(widget.city);
    final temp = await fetchTemperature(widget.city, apiKey);
    setState(() {
      temperature = temp;
    });
  }

  void _updateTodoLists() {
    // Separate todos into completed and not completed lists
    completedTodos = todos.where((todo) => todo.isCompleted).toList();
    notcompletedTodos = todos.where((todo) => !todo.isCompleted).toList();
  }

  void _addTodo(TodoModel newTodo) {
    setState(() {
      todos.add(newTodo);
      _updateTodoLists();
    });
    _storageService.saveTodos(todos);
  }

  void _toggleTodoCompletion(TodoModel todo) {
    setState(() {
      todo.isCompleted = !todo.isCompleted;
      _updateTodoLists();
    });
    _storageService.saveTodos(todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text(
          temperature != null
              ? '${widget.city} ${temperature!.toStringAsFixed(1)}°C'
              : 'Loading...',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: todos.isNotEmpty
          ? Column(
              children: [
                // Incomplete Todos
                Expanded(
                  child: ListView.builder(
                    itemCount: notcompletedTodos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24, bottom: 10),
                        child: Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text(notcompletedTodos[index].todo),
                            trailing: Checkbox(
                              value: notcompletedTodos[index].isCompleted,
                              onChanged: (value) {
                                _toggleTodoCompletion(notcompletedTodos[index]);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Completed Todos
                const Divider(color: Colors.white),
                Expanded(
                  child: ListView.builder(
                    itemCount: completedTodos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24, bottom: 10),
                        child: Container(
                          height: 70,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  completedTodos[index].todo,
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey),
                                ),
                                const Expanded(child: SizedBox()),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        todos.removeAt(index);
                                        _updateTodoLists();
                                      });
                                      _storageService.saveTodos(todos);
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.delete)),
                                Checkbox(
                                  value: completedTodos[index].isCompleted,
                                  onChanged: (value) {
                                    _toggleTodoCompletion(completedTodos[index]);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Container(
                color: Colors.amber,
                height: 100,
                width: 100,
                child: const Center(child: Text('No Data')),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await showAlertDialog(context);
          if (newTodo != null) {
            _addTodo(newTodo);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<TodoModel?> showAlertDialog(BuildContext context) async {
  TextEditingController todoController = TextEditingController();

  return showDialog<TodoModel>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Todo'),
        content: TextField(
          controller: todoController,
          decoration: const InputDecoration(hintText: 'Enter todo item'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog without adding
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final todoText = todoController.text;
              if (todoText.isNotEmpty) {
                Navigator.of(context).pop(TodoModel(todo: todoText));
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
