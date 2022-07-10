import 'package:state_libraries/model/todo.dart';

class TodoState {}

class TodoInitState extends TodoState {}

class UpdatedTodos extends TodoState {
  List<Todo> todos;

  UpdatedTodos({required this.todos});
}

class LoadingTodos extends TodoState {}
