import 'package:get/get.dart';
import 'package:state_libraries/model/todo.dart';

class GetTodo extends GetxController {
  RxList<Todo> todos = RxList.empty(growable: true);
  RxBool loading = RxBool(false);

  Future addTodo(Todo todo) async {
    loading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    todos.add(todo);
    loading.value = false;
  }

  Future updateTodo(Todo todo) async {
    loading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    todos[todos.indexWhere((element) => element.id == todo.id)] = todo;
    loading.value = false;
  }

  Future removeTodo(String id) async {
    loading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    todos.removeWhere((element) => element.id == id);
    loading.value = false;
  }
}
