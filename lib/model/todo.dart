class Todo {
  String id;
  String todo;
  bool finished;

  Todo({required this.id, required this.todo, required this.finished});

  Todo copyWith({String? id, String? todo, bool? finished}) {
    return Todo(
        id: id ?? this.id,
        todo: todo ?? this.todo,
        finished: finished ?? this.finished);
  }
}
