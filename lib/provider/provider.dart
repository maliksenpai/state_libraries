import 'package:flutter/widgets.dart';
import 'package:state_libraries/model/todo.dart';

class TodoProvider extends ChangeNotifier{
  List<Todo> todos = [];
  bool loading = false;

  Future addTodo(Todo todo) async {
    loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    todos.add(todo);
    loading = false;
    notifyListeners();
  }

  Future updateTodo(Todo todo) async {
    loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    todos[todos.indexWhere((element) => element.id == todo.id)] = todo;
    loading = false;
    notifyListeners();
  }

  Future removeTodo(String id) async {
    loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    todos.removeWhere((element) => element.id == id);
    loading = false;
    notifyListeners();
  }
}