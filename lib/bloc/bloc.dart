import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_libraries/bloc/bloc_event.dart';
import 'package:state_libraries/bloc/bloc_state.dart';
import 'package:state_libraries/model/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState>{

  List<Todo> todos = [];

  TodoBloc() : super(TodoInitState()) {
    on<AddTodo>((event, emit) async {
      emit(LoadingTodos());
      await Future.delayed(const Duration(seconds: 1));
      todos.add(event.todo);
      emit(UpdatedTodos(todos: todos));
    });
    on<UpdateTodo>((event, emit) async {
      emit(LoadingTodos());
      await Future.delayed(const Duration(seconds: 1));
      todos[todos.indexWhere((element) => element.id == event.todo.id)] = event.todo;
      emit(UpdatedTodos(todos: todos));
    });
    on<RemoveTodo>((event, emit) async {
      emit(LoadingTodos());
      await Future.delayed(const Duration(seconds: 1));
      todos.removeWhere((element) => element.id == event.id);
      emit(UpdatedTodos(todos: todos));
    });
  }

}