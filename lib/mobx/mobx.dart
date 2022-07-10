import 'package:mobx/mobx.dart';
import 'package:state_libraries/model/todo.dart';

part 'mobx.g.dart';

class MobxTodo = _MobxTodo with _$MobxTodo;

abstract class _MobxTodo with Store{
  @observable
  List<Todo> todos = [];

  @observable
  bool loading = false;

  @action
  Future addTodo(Todo todo) async {
    loading = true;
    await Future.delayed(const Duration(seconds: 1));
    todos = [...todos, todo];
    loading = false;
  }

  @action
  Future updateTodo(Todo todo) async {
    loading = true;
    await Future.delayed(const Duration(seconds: 1));
    todos[todos.indexWhere((element) => element.id == todo.id)] = todo;
    loading = false;
  }

  @action
  Future removeTodo(String id) async {
    loading = true;
    await Future.delayed(const Duration(seconds: 1));
    todos.removeWhere((element) => element.id == id);
    todos = todos;
    loading = false;
  }

}