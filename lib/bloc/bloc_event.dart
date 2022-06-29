import 'package:state_libraries/model/todo.dart';

class TodoEvent {}

class AddTodo extends TodoEvent {
  Todo todo;

  AddTodo({required this.todo});
}

class RemoveTodo extends TodoEvent {
  String id;

  RemoveTodo({required this.id});
}

class UpdateTodo extends TodoEvent {
  Todo todo;

  UpdateTodo({required this.todo});
}