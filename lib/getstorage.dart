import 'package:get_storage/get_storage.dart';

import 'todo_model.dart';

class TodoStorageService {
  final GetStorage _box = GetStorage();
  final String _key = 'todos';

  // Save the list of todos to GetStorage
  void saveTodos(List<TodoModel> todos) {
    final List<Map<String, dynamic>> todoList =
        todos.map((todo) => todo.toJson()).toList();
    _box.write(_key, todoList);
  }

  // Retrieve the list of todos from GetStorage
  List<TodoModel> loadTodos() {
    final List<dynamic>? todoList = _box.read(_key);
    if (todoList != null) {
      return todoList.map((todo) => TodoModel.fromJson(todo)).toList();
    }
    return [];
  }
}
