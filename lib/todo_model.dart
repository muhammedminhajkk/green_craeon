class TodoModel {
  String todo;
  bool isCompleted;

  TodoModel({required this.todo, this.isCompleted = false});

  // Convert a TodoModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'todo': todo,
      'isCompleted': isCompleted,
    };
  }

  // Create a TodoModel from a JSON map
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      todo: json['todo'],
      isCompleted: json['isCompleted'],
    );
  }
}
